//
//  UIOutlineLabel.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/11/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "UIOutlineLabel.h"

@implementation UIOutlineLabel

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    CGRect insetRect = CGRectOffset(rect, 1, 0);
    [super drawTextInRect:insetRect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:insetRect];
    
    self.shadowOffset = shadowOffset;
    
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
