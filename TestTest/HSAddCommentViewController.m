//
//  HSAddCommentViewController.m
//  improvisio-v4.2
//
//  Created by lux on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSAddCommentViewController.h"
#import "HSConversationViewController.h"
#import "HSComment.h"
#import "HSUtilities.h"

@interface HSAddCommentViewController () {
    HSComment* comment;
}

@end

@implementation HSAddCommentViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // use "viewDidAppear" because container view requires you to know when added to heirarchy, not cache
    comment = [HSComment object];
}

- (void) viewWillDisappear:(BOOL)animated {
    // Dismiss keyboard
    [self.commentField resignFirstResponder];
}

- (HSConversationViewController*) getConversationViewController {
    return (HSConversationViewController*)self.parentViewController;
}

- (IBAction)postComment:(id)sender {
    NSLog(@"in post");
    [[self getConversationViewController] addComment:self.commentField.text];
}

- (IBAction)addImage:(id)sender {
}

- (void) commentAdded {
    self.commentField.text = @"";
    [self.commentField resignFirstResponder];
}

@end
