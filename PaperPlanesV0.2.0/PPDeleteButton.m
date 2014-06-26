//
//  PPDeleteButton.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPDeleteButton.h"
#import "NSString+FontAwesome.h"
#import "UIView+Util.h"

#define BUTTON_DEFAULT_WIDTH 30.0f

@interface PPDeleteButton () {
    UILabel* circle;
    UILabel* xShape;
}

@end

@implementation PPDeleteButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self circleWithFrame:self.bounds]];
        [self addSubview:[self xShapeWithFrame:self.bounds]];
        [self setColor:self.tintColor];
    }
    return self;
}

- (UIView*) circleWithFrame:(CGRect) rect {
    circle = [self fontAwesomeLabel:FACircle withFrame:rect];
    return circle;
}

- (UIView*) xShapeWithFrame:(CGRect) rect {
    xShape = [self fontAwesomeLabel:FATimesCircle withFrame:rect];
    return xShape;
}

- (UILabel*) fontAwesomeLabel:(FAIcon) iconName withFrame:(CGRect) rect {
    CGPoint fontAwesomeAdjustment = CGPointMake(2.0f, 0);
    CGRect fontIconRect = CGRectMake(rect.origin.x + fontAwesomeAdjustment.x, rect.origin.y + fontAwesomeAdjustment.y, rect.size.width, rect.size.height);
    UILabel* fontIcon = [[UILabel alloc] initWithFrame:fontIconRect];
    fontIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:rect.size.width];
    fontIcon.text = [NSString fontAwesomeIconStringForEnum:iconName];
    return fontIcon;
}


#pragma mark - Convenience methods
- (void) setColor: (UIColor*) color {
    [xShape setTextColor:color];
    [circle setTextColor:[UIColor whiteColor]];
}

+ (float) getDefaultWidth {
    return BUTTON_DEFAULT_WIDTH;
}

@end
