//
//  PPBoxView.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPBoxView.h"
#import "PPDeleteButton.h"
#import "PPResizeButton.h"
#import "PPMoveButton.h"
#import "UIView+Util.h"

@interface PPBoxView () {
    CAShapeLayer* boxLayer;
    PPDeleteButton* deleteButton;
    PPResizeButton* resizeButton;
    PPMoveButton* moveButton;
}

@property (nonatomic, strong) UITapGestureRecognizer* boxLayerTapGestureRecognizer;


@end

#define BOX_DEFAULT_WIDTH 60.0f

@implementation PPBoxView

@synthesize delegate;

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:[self boxLayer]];
        [self addControl:[self deleteButton]];
        [self addControl:[self resizeButton]];
        [self addControl:[self moveButton]];
        [self setColor:self.tintColor];
        [self resizeBoundsToFitSubviews];
        self.userInteractionEnabled = YES;
        self.opaque = NO;
    }
    return self;
}

#pragma mark - Drawing

- (void) drawRect:(CGRect)rect {
    [self resizeBoundsToFitSubviews];
    CGRect boxRect = [self boxRect];
    // boxRect is drawn based on positions of top left button and bottom right button
    // So we must 'manually' set the moveButton on the top right corner
    moveButton.center = CGPointMake(CGRectGetMaxX(boxRect), CGRectGetMinY(boxRect));
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:boxRect];
    boxLayer.path = rectPath.CGPath;
}

- (void) addControl:(UIView*) control {
    if (self.controls == nil) {
        self.controls = [[NSMutableArray alloc] init];
    }
    
    [self.controls addObject:control];
    [self addSubview:control];
}

- (void) resizeBoundsToFitSubviews {
    CGRect bounds = CGRectZero;
    bounds = CGRectUnion(bounds, [self boxRect]);
    float deleteButtonInset = deleteButton.frame.size.width / 2;
    float resizeButtonInset = resizeButton.frame.size.width / 2;
    float moveButtonInset = moveButton.frame.size.width / 2;
    
    bounds = CGRectMake(bounds.origin.x - deleteButtonInset,
                        bounds.origin.y - deleteButtonInset,
                        bounds.size.width + MAX(resizeButtonInset, moveButtonInset) + deleteButtonInset,
                        bounds.size.height + MAX(resizeButtonInset, moveButtonInset) + deleteButtonInset);
    
    self.bounds = bounds;
}

#pragma mark - Animation

- (void) marchingAnts:(BOOL)turnOn {
    float currentLineDashPhase = [boxLayer.presentationLayer lineDashPhase];
    if (turnOn) {
        float endLineDashPhase = 10.0f;
        float duration = 0.75f;
        CABasicAnimation *marchingAntsAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [marchingAntsAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [marchingAntsAnimation setToValue:[NSNumber numberWithFloat:endLineDashPhase]];
        [marchingAntsAnimation setDuration:duration];
        [marchingAntsAnimation setRepeatCount:10000];
        // This will start the dashes to animate from the place they last stopped, rather than resetting to phase 0
        marchingAntsAnimation.timeOffset = (currentLineDashPhase / endLineDashPhase) * duration;
        [boxLayer addAnimation:marchingAntsAnimation forKey:@"linePhase"];
    } else {
        // Sets the model layer to match the presentation layer
        [boxLayer setLineDashPhase:currentLineDashPhase];
        [boxLayer removeAnimationForKey:@"linePhase"];
    }
}

- (void) toggleMarchingAnts {
    if ([boxLayer animationForKey:@"linePhase"]) {
        [self marchingAnts:TRUE];
    } else {
        [self marchingAnts:FALSE];
    }
}

- (void) showControls:(BOOL)show {
    [deleteButton setHidden:!show];
    [resizeButton setHidden:!show];
    [moveButton setHidden:!show];
}

#pragma mark - Subviews/Sublayers

- (CAShapeLayer*) boxLayer {
    boxLayer = [CAShapeLayer layer];
    [boxLayer setFillColor:[UIColor clearColor].CGColor];
    [boxLayer setLineWidth:2.0f];
    [boxLayer setLineJoin:kCALineCapSquare];
    [boxLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:5], nil]];
    
    return boxLayer;
}

- (CGRect) boxRect {
    float width = resizeButton.center.x - deleteButton.center.x;
    float height = resizeButton.center.y - deleteButton.center.y;
    return CGRectMake(deleteButton.center.x, deleteButton.center.y, width, height);
}

- (UIView*) deleteButton {
    deleteButton = [PPDeleteButton centeredAtPoint:CGPointZero];
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteButtonTapped)];
    [deleteButton addGestureRecognizer:recognizer];
    return deleteButton;
}

- (UIView*) resizeButton {
    resizeButton = [PPResizeButton centeredAtPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    self.resizeButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeButtonPanned:)];
    [resizeButton addGestureRecognizer:self.resizeButtonPanGestureRecognizer];
    return resizeButton;
    
}

- (UIView*) moveButton {
    moveButton = [PPMoveButton centeredAtPoint:CGPointMake(CGRectGetMaxX(self.bounds), 0)];
    
    self.moveButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveButtonPanned:)];
    [moveButton addGestureRecognizer:self.moveButtonPanGestureRecognizer];
    return moveButton;
}

#pragma mark - Action methods


- (void) deleteButtonTapped {
//    [self removeFromSuperview];
    [delegate boxViewWasDeleted:self];
}

- (void) resizeButtonPanned: (UIPanGestureRecognizer *) gesture {
    CGPoint translation = [gesture translationInView:gesture.view.superview];
    resizeButton.frame = CGRectOffset(resizeButton.frame, translation.x, translation.y);
    self.frame = CGRectOffset(self.frame, translation.x / 2, translation.y / 2);
    [self setNeedsDisplay];
    [gesture setTranslation:CGPointZero inView:gesture.view.superview];
}

- (void) moveButtonPanned: (UIPanGestureRecognizer* ) gesture {
    CGPoint translation = [gesture translationInView:gesture.view.superview];
    self.frame = CGRectOffset(self.frame, translation.x, translation.y);
    [delegate boxViewWasPanned:self];
    [self setNeedsDisplay];
    [gesture setTranslation:CGPointZero inView:gesture.view.superview];
}

#pragma mark - Convenience methods

- (void) setColor:(UIColor*) color {
    [boxLayer setStrokeColor:color.CGColor];
    [deleteButton setColor:color];
    [resizeButton setColor:color];
    [moveButton setColor:color];
}

+ (float) getDefaultWidth {
    return BOX_DEFAULT_WIDTH;
}

@end
