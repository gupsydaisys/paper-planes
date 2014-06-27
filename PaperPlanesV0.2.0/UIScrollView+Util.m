//
//  UIScrollView+Util.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/26/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "UIScrollView+Util.h"

@implementation UIScrollView (Util)

-(void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                              animated:(BOOL)animated {
    
    CGPoint center = visibleRect.origin;
    center.x += visibleRect.size.width/2;
    center.y += visibleRect.size.height/2;
    
    center.x *= self.zoomScale;
    center.y *= self.zoomScale;
    
    
    CGRect centeredRect = CGRectMake(center.x - self.frame.size.width/2.0,
                                     center.y - self.frame.size.height/2.0,
                                     self.frame.size.width,
                                     self.frame.size.height);
    [self scrollRectToVisible:centeredRect
                     animated:animated];
}

@end
