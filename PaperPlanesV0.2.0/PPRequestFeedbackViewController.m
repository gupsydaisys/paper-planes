//
//  PPRequestFeedbackViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/18/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPRequestFeedbackViewController.h"
#import "PPOrganizerViewController.h"
#import "PPFeedbackItem.h"
#import <Parse/Parse.h>
#import "PPUtilities.h"
#import "UIBAlertView.h"

@interface PPRequestFeedbackViewController ()

@end

@implementation PPRequestFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCamera];
    [self initMainView];
    self.mainView.hidden = true;
}

- (NSString*) placeholderText {
    return @"Add a comment on selected area...";
}

- (void) touchUpInsideExitButton {
    BOOL hasComments = self.selectedBox.comments.count > 0;
    BOOL hasUnsavedComment = self.selectedBox != nil && ![self.textView.text isEqualToString:@""];
    BOOL hasChangedForm = [self.selectedBox boxHasChangedForm];
    
    /* Alert iff selected dotbox has unsaved text in comment field */
    if (!hasComments && (hasUnsavedComment || hasChangedForm)) {
        UIBAlertView *alert = [PPUtilities getAlertUnsavedCommentAbandon:@"screen"];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel) {
                return;
            } else {
                [self transitionToCameraView];
            }
        }];
    } else {
        [self transitionToCameraView];
    }
}

- (void) touchUpInsideSendButton {
    BOOL hasComments = self.selectedBox.comments.count > 0;
    BOOL hasUnsavedComment = self.selectedBox != nil && ![self.textView.text isEqualToString:@""];
    BOOL hasChangedForm = [self.selectedBox boxHasChangedForm];
    
    /* Alert iff selected dotbox has unsaved text in comment field */
    if (!hasComments && (hasUnsavedComment || hasChangedForm)) {
        UIBAlertView *alert = [PPUtilities getAlertUnsavedCommentAbandon:@"screen"];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel) {
                return;
            } else {
                [self transitionToOrganizerViewController];
            }
        }];
    } else {
        [self transitionToOrganizerViewController];
    }
}

- (void) transitionToOrganizerViewController {
    for (PPBoxViewController* box in self.childViewControllers) {
        [self.feedbackItem addObject:[box getModel] forKey:@"boxes"];
    }
    
    // Because self.feedbackItem could be changing, we keep a pointer to it
    // so that we push the correct feedbackItem after the save completes.
    PPFeedbackItem* feedbackItem = self.feedbackItem;
    [feedbackItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFPush *newFeedbackItemPush = [PPUtilities pushWithFeedbackItem:feedbackItem];
            [newFeedbackItemPush sendPushInBackground];
        } else {
            NSLog(@"There was an error saving the feedback item");
        }
    }];
    
    [self.pageViewController transitionToOrganizerViewController:^{
        [self transitionToCameraView];
    }];
}

- (UIViewController*) controllerForPaging {
    return self;
}

@end
