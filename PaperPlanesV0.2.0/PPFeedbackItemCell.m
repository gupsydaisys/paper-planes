//
//  PPFeedbackItemCell.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/15/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPFeedbackItemCell.h"

@implementation PPFeedbackItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
