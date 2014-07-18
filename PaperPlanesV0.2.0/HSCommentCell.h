//
//  HSCommentCell.h
//  improvisio-v4.2
//
//  Created by lux on 6/11/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *creator;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *thanksCount;
@property (weak, nonatomic) IBOutlet UITextView *content;

- (IBAction)sayThanks:(id)sender;


@end