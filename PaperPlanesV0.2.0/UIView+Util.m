//
//  UIView+Util.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/25/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

+ (instancetype) centeredAtPoint: (CGPoint) point {
    UIView* view = [self atPoint:point];
    view.center = point;
    return view;
}

+ (instancetype) atPoint: (CGPoint) point {
    float width = [self getDefaultWidth];
    return [self atPoint:point withSize:CGSizeMake(width, width)];
}

+ (instancetype) atPoint: (CGPoint) point withSize: (CGSize) size {
    CGRect buttonRect = CGRectMake(point.x, point.y, size.width, size.height);
    return [[self alloc] initWithFrame:buttonRect];
}

+ (float) getDefaultWidth {
    // Stub method, meant to be overwritten in subclass
    return 0.0f;
}

@end
