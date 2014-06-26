//
//  PPResizeButton.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/25/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPResizeButton.h"
#import "NSString+FontAwesome.h"

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
//        [self setBackgroundColor:[UIColor blackColor]];
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


- (UILabel*) fontAwesomeLabel:(FAIcon) iconName withFrame:(CGRect) rect {
    CGPoint fontAwesomeAdjustment = CGPointMake(2.0f, 0);
    CGRect fontIconRect = CGRectMake(rect.origin.x + fontAwesomeAdjustment.x, rect.origin.y + fontAwesomeAdjustment.y, rect.size.width, rect.size.height);
    UILabel* fontIcon = [[UILabel alloc] initWithFrame:fontIconRect];
    fontIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:rect.size.width];
    fontIcon.text = [NSString fontAwesomeIconStringForEnum:iconName];
    return fontIcon;
}

- (void) setColor: (UIColor*) color {
    [resizeShape setTextColor:[UIColor whiteColor]];
    [circle setTextColor:color];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (PPResizeButton*) centeredAtPoint: (CGPoint) point {
    PPResizeButton* view = [self atPoint:point];
    view.center = CGPointMake(view.frame.origin.x - view.frame.size.width / 2, view.frame.origin.y - view.frame.size.height / 2);
    return view;
}

+ (PPResizeButton*) atPoint: (CGPoint) point {
    return [self atPoint:point withSize:CGSizeMake(BUTTON_DEFAULT_WIDTH, BUTTON_DEFAULT_WIDTH)];
}

+ (PPResizeButton*) atPoint: (CGPoint) point withSize: (CGSize) size {
    CGRect boxRect = CGRectMake(point.x, point.y, size.width, size.height);
    return [[self alloc] initWithFrame:boxRect];
}

@end
