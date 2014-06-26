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

#define BUTTON_DEFAULT_WIDTH 60.0f

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
    float sizeTweak = -[PPResizeButton getDefaultWidth] / 5;
    float positionXTweak = -[PPResizeButton getDefaultWidth] / 15;
    float positionYTweak = [PPResizeButton getDefaultWidth] / 30;
    
    CGSize sizeAdjustment = CGSizeMake(sizeTweak, sizeTweak);
    CGPoint positionAdjustment = CGPointMake(positionXTweak, positionYTweak);
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
