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
#import "UIView+Util.h"

@interface PPBoxView () {
    CAShapeLayer* boxLayer;
    PPDeleteButton* deleteButton;
    PPResizeButton* resizeButton;
}

@end

#define BOX_DEFAULT_WIDTH 30.0f

@implementation PPBoxView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:[self boxLayer]];
        [self addSubview:[self deleteButton]];
        [self addSubview:[self resizeButton]];
        [self setColor:self.tintColor];
        self.opaque = NO;
    }
    return self;
}

#pragma mark - Drawing

- (void) drawRect:(CGRect)rect {
    [self resizeBoundsToFitSubviews];
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:[self boxRect]];
    boxLayer.path = rectPath.CGPath;
}

- (void) resizeBoundsToFitSubviews {
    CGPoint initialOrigin = self.frame.origin;
    CGRect bounds = CGRectZero;
    bounds = CGRectUnion(bounds, [self boxRect]);
    bounds = CGRectUnion(bounds, deleteButton.frame);
    bounds = CGRectUnion(bounds, resizeButton.frame);
    self.bounds = bounds;
    self.frame = CGRectMake(initialOrigin.x, initialOrigin.y, self.frame.size.width, self.frame.size.height);
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
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeButtonPanned:)];
    [resizeButton addGestureRecognizer:recognizer];
    return resizeButton;
    
}

#pragma mark - Action methods
- (void) deleteButtonTapped {
    [self removeFromSuperview];
}

- (void) resizeButtonPanned: (UIPanGestureRecognizer *) gesture {
    CGPoint translation = [gesture translationInView:gesture.view];
    resizeButton.frame = CGRectOffset(resizeButton.frame, translation.x, translation.y);
    [self setNeedsDisplay];
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

#pragma mark - Convenience methods

- (void) setColor:(UIColor*) color {
    [boxLayer setStrokeColor:color.CGColor];
    [deleteButton setColor:color];
    [resizeButton setColor:color];
}

+ (float) getDefaultWidth {
    return BOX_DEFAULT_WIDTH;
}

@end
