//
//  PPDeleteButton.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPDeleteButton.h"
#import "NSString+FontAwesome.h"

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
        [self addSubview:[self circleWithFrame:frame]];
        [self addSubview:[self xShapeWithFrame:frame]];
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
    CGRect fontIconRect = CGRectMake(fontAwesomeAdjustment.x, fontAwesomeAdjustment.y, rect.size.width, rect.size.height);
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

+ (PPDeleteButton*) centeredAtPoint: (CGPoint) point {
    PPDeleteButton* view = [self atPoint:point];
    view.center = CGPointMake(view.frame.origin.x - view.frame.size.width / 2, view.frame.origin.y - view.frame.size.height / 2);
    return view;
}

+ (PPDeleteButton*) atPoint: (CGPoint) point {
    return [self atPoint:point withSize:CGSizeMake(BUTTON_DEFAULT_WIDTH, BUTTON_DEFAULT_WIDTH)];
}

+ (PPDeleteButton*) atPoint: (CGPoint) point withSize: (CGSize) size {
    CGRect buttonRect = CGRectMake(point.x, point.y, size.width, size.height);
    return [[self alloc] initWithFrame:buttonRect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
