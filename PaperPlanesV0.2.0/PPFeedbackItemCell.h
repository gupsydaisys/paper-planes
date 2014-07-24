//
//  PPFeedbackItemCell.h
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/15/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPFeedbackItem.h"
#import "MJCollectionViewCell.h"

@interface PPFeedbackItemCell : MJCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *creator;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) PPFeedbackItem* feedbackItem;

@end
