//
//  PPTakePhotoButton.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/10/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPTakePhotoButton.h"
#import "NSString+FontAwesome.h"
#import "UIOutlineLabel.h"

@interface PPTakePhotoButton () {
    UILabel *takePhotoButton;
}

@end

@implementation PPTakePhotoButton



- (instancetype) init {
    self = [super init];
    if (self) {
        CGFloat buttonSize = 80;
        takePhotoButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
        takePhotoButton.font = [UIFont fontWithName:kFontAwesomeFamilyName size:buttonSize];
        takePhotoButton.text = [@[@" ", [NSString fontAwesomeIconStringForEnum:FAcircleThin], @" "] componentsJoinedByString:@""];
        takePhotoButton.textColor = [UIColor colorWithWhite:1 alpha:0.95];
        takePhotoButton.layer.contentsScale = [[UIScreen mainScreen] scale];
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:takePhotoButton];
    }
    return self;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    takePhotoButton.textColor = selected ? [self.tintColor colorWithAlphaComponent:0.95] : [UIColor colorWithWhite:1 alpha:0.95];
}

@end
