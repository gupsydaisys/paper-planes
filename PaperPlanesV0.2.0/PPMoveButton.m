//
//  PPMoveButton.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/25/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPMoveButton.h"
#import "NSString+FontAwesome.h"
#import "UIView+Util.h"

#define BUTTON_DEFAULT_WIDTH 60.0f

@interface PPMoveButton () {
    UILabel* circle;
    UILabel* moveShape;
}

@end

@implementation PPMoveButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self circleWithFrame:self.bounds]];
        [self addSubview:[self moveShapeWithFrame:self.bounds]];
        [self setColor:self.tintColor];
    }
    return self;
}

- (UIView*) circleWithFrame:(CGRect) rect {
    circle = [self fontAwesomeLabel:FACircle withFrame:rect];
    return circle;
}

- (UIView*) moveShapeWithFrame:(CGRect) rect {
    float sizeTweak = -[PPMoveButton getDefaultWidth] / 5;
    float positionTweak = -[PPMoveButton getDefaultWidth] / 15;
    CGSize sizeAdjustment = CGSizeMake(sizeTweak, sizeTweak);
    CGPoint positionAdjustment = CGPointMake(positionTweak, 0.0f);
    rect = CGRectInset(rect, -sizeAdjustment.width, -sizeAdjustment.height);
    rect = CGRectOffset(rect, positionAdjustment.x, positionAdjustment.y);
    moveShape = [self fontAwesomeLabel:FAArrows withFrame:rect];
    return moveShape;
}

- (void) setColor: (UIColor*) color {
    [moveShape setTextColor:[UIColor whiteColor]];
    [circle setTextColor:color];
}

+ (float) getDefaultWidth {
    return BUTTON_DEFAULT_WIDTH;
}

@end
