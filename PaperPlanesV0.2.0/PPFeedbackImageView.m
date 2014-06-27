//
//  PPFeedbackImageView.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/27/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPFeedbackImageView.h"
#import "PPBoxView.h"

@interface PPFeedbackImageView () {
    CGAffineTransform invertedTransform;
}

@end

@implementation PPFeedbackImageView

- (void) setTransform:(CGAffineTransform)transform {
    [super setTransform:transform];
    
    invertedTransform = CGAffineTransformInvert(transform);
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[PPBoxView class]]) {
            [self resizeBoxViewControls:(PPBoxView*) view];
        }
    }
}

- (void) addSubview:(UIView *)view {
    [super addSubview:view];
    
    if ([view isKindOfClass:[PPBoxView class]]) {
        [self resizeBoxViewControls:(PPBoxView*) view];
    }
}

// We want the control buttons on boxViews to stay the same size when we zoom in
- (void) resizeBoxViewControls:(PPBoxView*) boxView {
    for (UIView *control in boxView.controls) {
        [control setTransform:invertedTransform];
    }
    [boxView setNeedsDisplay];
}

@end
