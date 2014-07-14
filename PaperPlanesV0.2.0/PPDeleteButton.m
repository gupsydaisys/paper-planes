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
#import "UIOutlineLabel.h"

#define BUTTON_DEFAULT_WIDTH 60.0f

@interface PPDeleteButton () {
    UILabel* circle;
    UILabel* xShape;
    UIOutlineLabel* outlinedXShape;
}

@end

@implementation PPDeleteButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        circle = [self circleWithFrame:self.bounds];
        xShape = [self xShapeWithFrame:self.bounds];
        [self addSubview:circle];
        [self addSubview:xShape];
        [self setColor:self.tintColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame circleShown:(BOOL)isShown
{
    self = [self initWithFrame:frame];
    if (self) {
        if (!isShown) {
            [circle removeFromSuperview];
            [xShape removeFromSuperview];
            
            // TODO: Remove this sizing magic-ness
            CGRect outlinedXShapeRect = CGRectInset(self.bounds, 10, 10);
            outlinedXShape = [[UIOutlineLabel alloc] initWithFrame:outlinedXShapeRect];
            outlinedXShape.font = [UIFont fontWithName:kFontAwesomeFamilyName size:outlinedXShapeRect.size.width];
            outlinedXShape.text = [NSString fontAwesomeIconStringForEnum:FATimes];
            [outlinedXShape setTextColor:[UIColor whiteColor]];
            
            [self addSubview:outlinedXShape];
        }
    }
    return self;
}


- (UILabel*) circleWithFrame:(CGRect) rect {
    return [self fontAwesomeLabel:FACircle withFrame:rect];
}

- (UILabel*) xShapeWithFrame:(CGRect) rect {
    CGRect xShapeFrame = CGRectOffset(CGRectInset(rect, 10, 10), 0, -2);
    return [self fontAwesomeLabel:FATimes withFrame:xShapeFrame];
}

#pragma mark - Convenience methods
- (void) setColor: (UIColor*) color {
    [xShape setTextColor:[UIColor whiteColor]];
    [circle setTextColor:color];
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [outlinedXShape setTextColor:self.tintColor];
    } else {
        [outlinedXShape setTextColor:[UIColor whiteColor]];
    }
    }

+ (float) getDefaultWidth {
    return BUTTON_DEFAULT_WIDTH;
}

@end
