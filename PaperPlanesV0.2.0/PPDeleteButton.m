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
}

@end

@implementation PPDeleteButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self circleWithFrame:frame]];
        [self setColor:self.tintColor];
    }
    return self;
}

- (UIView*) circleWithFrame:(CGRect) rect {
    CGPoint fontAwesomeAdjustment = CGPointMake(2.0f, 0);
    CGRect circleRect = CGRectMake(fontAwesomeAdjustment.x, fontAwesomeAdjustment.y, rect.size.width, rect.size.height);
    circle = [[UILabel alloc] initWithFrame:circleRect];
    circle.font = [UIFont fontWithName:kFontAwesomeFamilyName size:rect.size.width];
    circle.text = [NSString fontAwesomeIconStringForEnum:FACircle];
    return circle;
}

#pragma mark - Convenience methods
- (void) setColor: (UIColor*) color {
    [circle setTextColor:color];
}

+ (PPDeleteButton*) deleteButtonCenteredAtPoint: (CGPoint) point {
    CGSize size = CGSizeMake(BUTTON_DEFAULT_WIDTH, BUTTON_DEFAULT_WIDTH);
    return [self deleteButtonAtPoint:CGPointMake(point.x - size.width / 2, point.y - size.height / 2) withSize:size];
}

+ (PPDeleteButton*) deleteButtonAtPoint: (CGPoint) point {
    return [self deleteButtonAtPoint:point withSize:CGSizeMake(BUTTON_DEFAULT_WIDTH, BUTTON_DEFAULT_WIDTH)];
}

+ (PPDeleteButton*) deleteButtonAtPoint: (CGPoint) point withSize: (CGSize) size {
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
