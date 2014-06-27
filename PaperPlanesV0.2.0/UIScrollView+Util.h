//
//  UIScrollView+Util.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/26/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Util)

-(void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                            animated:(BOOL)animated;
@end
