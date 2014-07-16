//
//  PPCameraButton.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/16/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPCameraButton.h"

@interface PPCameraButton () {
    UILabel* cameraIcon;
}

@end

@implementation PPCameraButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        cameraIcon = [[UILabel alloc] initWithFrame:frame];
        cameraIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:frame.size.width - 10];
        cameraIcon.text = [NSString fontAwesomeIconStringForEnum:FACamera];

        [cameraIcon setTextColor:[UIColor whiteColor]];
        [self addSubview:cameraIcon];
    }
    return self;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    cameraIcon.textColor = selected ? [UIColor colorWithRed:190.0f / 255.0f green:190.0f / 255.0f blue:190.0f / 255.0f alpha:1] : [UIColor colorWithWhite:1 alpha:0.95];
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
