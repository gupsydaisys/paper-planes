//
//  PPFeedbackImageView.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/27/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPFeedbackImageView.h"
#import "PPBoxView.h"

@implementation PPFeedbackImageView

- (void) setTransform:(CGAffineTransform)transform {
    [super setTransform:transform];
    
    // We want the control buttons on boxViews to stay the same size when we zoom in
    CGAffineTransform invertedTransform = CGAffineTransformInvert(transform);
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[PPBoxView class]]) {
            PPBoxView* boxView = (PPBoxView*) view;
            for (UIView *control in boxView.controls) {
                [control setTransform:invertedTransform];
//                NSLog(@"Inverting control transform");
            }
            [boxView setNeedsDisplay];
        }
    }
}

@end
