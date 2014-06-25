//
//  PPBoxView.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPBoxView.h"
#import "PPDeleteButton.h"

@interface PPBoxView () {
    CAShapeLayer* boxLayer;
    PPDeleteButton* deleteButton;
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
        [self setColor:self.tintColor];
        self.opaque = NO;
    }
    return self;
}

#pragma mark - Drawing

- (void) drawRect:(CGRect)rect {
    self.bounds = CGRectUnion([self boxRect], deleteButton.frame);
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:[self boxRect]];
    boxLayer.path = rectPath.CGPath;
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
    return CGRectMake(deleteButton.center.x, deleteButton.center.y, BOX_DEFAULT_WIDTH, BOX_DEFAULT_WIDTH);
}

- (UIView*) deleteButton {
    deleteButton = [PPDeleteButton deleteButtonCenteredAtPoint:CGPointZero];
    [deleteButton addTarget:self action:@selector(deleteButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    return deleteButton;
}

#pragma mark - Action methods
- (void) deleteButtonTouched {
    [self removeFromSuperview];
}

#pragma mark - Convenience methods

- (void) setColor:(UIColor*) color {
    [boxLayer setStrokeColor:color.CGColor];
    [deleteButton setColor:color];
}

+ (PPBoxView*) boxViewCenteredAtPoint: (CGPoint) point {
    CGSize size = CGSizeMake(BOX_DEFAULT_WIDTH, BOX_DEFAULT_WIDTH);
    return [self boxViewAtPoint:CGPointMake(point.x - size.width / 2, point.y - size.height / 2) withSize:size];
}

+ (PPBoxView*) boxViewAtPoint: (CGPoint) point {
    return [self boxViewAtPoint:point withSize:CGSizeMake(BOX_DEFAULT_WIDTH, BOX_DEFAULT_WIDTH)];
}

+ (PPBoxView*) boxViewAtPoint: (CGPoint) point withSize: (CGSize) size {
    CGRect boxRect = CGRectMake(point.x, point.y, size.width, size.height);
    return [[self alloc] initWithFrame:boxRect];
}



@end
