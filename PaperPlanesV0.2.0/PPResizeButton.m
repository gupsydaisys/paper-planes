//
//  PPResizeButton.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/25/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPResizeButton.h"
#import "NSString+FontAwesome.h"
#import "UIView+Util.h"

#define BUTTON_DEFAULT_WIDTH 30.0f

@interface PPResizeButton () {
    UILabel* circle;
    UILabel* resizeShape;
}

@end

@implementation PPResizeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self circleWithFrame:self.bounds]];
        [self addSubview:[self resizeShapeWithFrame:self.bounds]];
        [self setColor:self.tintColor];
    }
    return self;
}

- (UIView*) circleWithFrame:(CGRect) rect {
    circle = [self fontAwesomeLabel:FACircle withFrame:rect];
    return circle;
}

- (UIView*) resizeShapeWithFrame:(CGRect) rect {
    CGSize sizeAdjustment = CGSizeMake(-6.0f, -6.0f);
    CGPoint positionAdjustment = CGPointMake(-2.0f, 1.0f);
    rect = CGRectInset(rect, -sizeAdjustment.width, -sizeAdjustment.height);
    rect = CGRectOffset(rect, positionAdjustment.x, positionAdjustment.y);
    resizeShape = [self fontAwesomeLabel:FAExpand withFrame:rect];
    resizeShape.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    return resizeShape;
}

- (void) setColor: (UIColor*) color {
    [resizeShape setTextColor:[UIColor whiteColor]];
    [circle setTextColor:color];
}

+ (float) getDefaultWidth {
    return BUTTON_DEFAULT_WIDTH;
}


@end
