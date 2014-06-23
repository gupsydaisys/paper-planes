//
//  HSAddCommentViewController.h
//  improvisio-v4.2/Users/Matchbook/Dev/improvisio-v4.2/improvisio-v4.2/HSNewConversationViewController.m
//
//  Created by lux on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface HSAddCommentViewController : UIViewController <HPGrowingTextViewDelegate>

@property (strong, nonatomic) HPGrowingTextView *textView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)postComment:(id)sender;
@end
