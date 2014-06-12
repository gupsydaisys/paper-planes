//
//  HSSummaryCell.h
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLastLabel;

@end
