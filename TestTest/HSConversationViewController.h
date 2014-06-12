//
//  HSConversationViewController.h
//  improvisio-v4.2
//
//  Created by lux on 6/10/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSAddCommentViewController.h"
#import "HSConversation.h"

@interface HSConversationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *sheetView;
@property (weak, nonatomic) IBOutlet UIView *threadView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (strong, nonatomic) HSConversation *conversation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *flipButton;


- (IBAction)tapFlip:(id)sender;

- (void) addComment:(NSString*) commentText;

@end
