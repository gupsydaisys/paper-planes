//
//  PPSendButton.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/14/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPSendButton.h"
#import "UIOutlineLabel.h"
#import "NSString+FontAwesome.h"

@implementation PPSendButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        int adjustmentForOutlinedIcon = -5;
//        UILabel *paperPlane = [self fontAwesomeLabel:FApaperPlane withFrame:CGRectInset(frame, -5, 0)];
        
//        UILabel* outlinedPaperPlane = [self fontAwesomeLabel:FApaperPlane withFrame:frame];
//        
        UIOutlineLabel* outlinedPaperPlane = [[UIOutlineLabel alloc] initWithFrame:frame];
        
        // We shrink the icon font a bit so that the outline doesn't get cut off
        int adjustmentForOutlinedIcon = -15;
        outlinedPaperPlane.font = [UIFont fontWithName:kFontAwesomeFamilyName size:frame.size.width + adjustmentForOutlinedIcon];
        outlinedPaperPlane.text = [NSString fontAwesomeIconStringForEnum:FApaperPlane];
        [outlinedPaperPlane setTextColor:[UIColor colorWithWhite:1 alpha:0.95]];
        outlinedPaperPlane.outlineColor = [UIColor clearColor];
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectInset(CGRectOffset(frame, -6, -1), 1, 1)];
        [background setBackgroundColor:[self.tintColor colorWithAlphaComponent:0.95]];
        [background.layer setCornerRadius:frame.size.width / 6];
        [background.layer setBorderColor:[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor];
        [background.layer setBorderWidth:0.5f];
//        [background addSubview:outlinedPaperPlane];

        
        [self addSubview:background];
        [self addSubview:outlinedPaperPlane];
    }
    return self;
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
