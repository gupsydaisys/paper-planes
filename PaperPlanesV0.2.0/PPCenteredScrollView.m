//
//  PPCenteredScrollView.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/9/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//
//  **Credit to Peter Steinberger (github.com/steipete) for this code**
//

#import "PPCenteredScrollView.h"

@implementation PPCenteredScrollView

- (void)centerContent {
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width-self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height-self.contentSize.height) * 0.5f;
    }
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView {
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self centerContent];
}

@end
