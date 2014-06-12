//
//  HSAddCommentViewController.h
//  improvisio-v4.2/Users/Matchbook/Dev/improvisio-v4.2/improvisio-v4.2/HSNewConversationViewController.m
//
//  Created by lux on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAddCommentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *commentField;
- (IBAction)addImage:(id)sender;
- (IBAction)postComment:(id)sender;

- (void) commentAdded;
@end
