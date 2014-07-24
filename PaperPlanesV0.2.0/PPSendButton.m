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

@interface PPSendButton ()

@property (strong, nonatomic) UILabel* paperPlane;

@end
@implementation PPSendButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.paperPlane = [[UILabel alloc] initWithFrame:CGRectOffset(frame, 6, 1)];
        
        // We shrink the icon font a bit so that the outline doesn't get cut off
        int adjustmentForOutlinedIcon = -13;
        self.paperPlane.font = [UIFont fontWithName:kFontAwesomeFamilyName size:frame.size.width + adjustmentForOutlinedIcon];
        self.paperPlane.text = [NSString fontAwesomeIconStringForEnum:FApaperPlane];
        [self.paperPlane setTextColor:[UIColor colorWithWhite:1 alpha:0.95]];
        
        UIView *background = [[UIView alloc] initWithFrame:frame];
        [background setBackgroundColor:[self.tintColor colorWithAlphaComponent:0.95]];
        [background.layer setCornerRadius:5.0f];
//        [background.layer setBorderColor:[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor];
//        [background.layer setBorderWidth:0.5f];
        background.layer.shadowColor = [UIColor blackColor].CGColor;
        background.layer.shadowOpacity = 0.7f;
        background.layer.shadowRadius = 1.0f;
        background.layer.shadowOffset = CGSizeMake(0, 0);
//    } else {
//        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowOpacity = 1.0;
//        self.layer.shadowRadius = 30.0;

        /* Subviews don't cancel the hit from UIControlEvent */
        [background setUserInteractionEnabled:NO];
        [self.paperPlane setUserInteractionEnabled:NO];
        
        [self addSubview:background];
        [self addSubview:self.paperPlane];
        

    }
    return self;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.paperPlane.textColor = selected ? [UIColor colorWithRed:190.0f / 255.0f green:190.0f / 255.0f blue:190.0f / 255.0f alpha:1] : [UIColor colorWithWhite:1 alpha:0.95];
}

@end
