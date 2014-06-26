//
//  UIView+Util.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/25/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

+ (instancetype) atPoint: (CGPoint) point;
+ (instancetype) centeredAtPoint: (CGPoint) point;
+ (instancetype) atPoint: (CGPoint) point withSize: (CGSize) size;
+ (float) getDefaultWidth;

@end
