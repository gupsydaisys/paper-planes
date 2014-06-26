//
//  PPButton.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/26/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPButton.h"

@implementation PPButton

- (UILabel*) fontAwesomeLabel:(FAIcon) iconName withFrame:(CGRect) rect {
    CGPoint fontAwesomeAdjustment = CGPointMake(2.0f, 0);
    CGRect fontIconRect = CGRectMake(rect.origin.x + fontAwesomeAdjustment.x, rect.origin.y + fontAwesomeAdjustment.y, rect.size.width, rect.size.height);
    UILabel* fontIcon = [[UILabel alloc] initWithFrame:fontIconRect];
    fontIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:rect.size.width];
    fontIcon.text = [NSString fontAwesomeIconStringForEnum:iconName];
    return fontIcon;
}

@end
