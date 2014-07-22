//
//  PPAddCommentButton.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/21/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPAddCommentButton.h"
#import "NSString+FontAwesome.h"

@interface PPAddCommentButton () {
    UILabel* addCommentButton;
}

@end

@implementation PPAddCommentButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        addCommentButton = [[UILabel alloc] initWithFrame:frame];
        addCommentButton.font = [UIFont fontWithName:kFontAwesomeFamilyName size:frame.size.width - 10];
        addCommentButton.text = [NSString fontAwesomeIconStringForEnum:FACamera];
        [addCommentButton setTextColor:self.tintColor];
        [self addSubview:addCommentButton];
    }
    return self;
}

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
}
@end
