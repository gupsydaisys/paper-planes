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
    UILabel *cameraButton;
}

@end

@implementation PPTakePhotoButton



- (instancetype) init {
    self = [super init];
    if (self) {
        CGFloat buttonSize = 80;
        cameraButton = [[UIOutlineLabel alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
        cameraButton.font = [UIFont fontWithName:kFontAwesomeFamilyName size:buttonSize];
        cameraButton.text = [@[@" ", [NSString fontAwesomeIconStringForEnum:FAcircleThin], @" "] componentsJoinedByString:@""];
        cameraButton.textColor = [UIColor whiteColor];
        cameraButton.layer.contentsScale = [[UIScreen mainScreen] scale];
        cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:cameraButton];
    }
    return self;
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    cameraButton.textColor = selected ? self.tintColor : [UIColor whiteColor];
}

@end
