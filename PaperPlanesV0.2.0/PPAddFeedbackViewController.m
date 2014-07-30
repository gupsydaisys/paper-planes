//
//  PPAddFeedbackViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/18/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPAddFeedbackViewController.h"
#import "PPUtilities.h"
#import "UIBAlertView.h"

@interface PPAddFeedbackViewController ()

@end

@implementation PPAddFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /* Adds the current user to the ones who haveViewed the comment */
    for (PPBox* box in self.feedbackItem.boxes) {
        for (PPBoxComment *comment in box.comments) {
            [comment addUniqueObject:[PFUser currentUser].objectId forKey:@"haveViewed"];
        }
    }
    [self transitionToMainViewWithFeedbackItem:self.feedbackItem];
}

- (void) viewWillDisappear:(BOOL) animated {
    /* must save whether or not user has read it */
    [super viewWillDisappear:animated];
    [self.feedbackItem addUniqueObject:[PFUser currentUser].objectId forKey:@"haveViewed"];
    [self.feedbackItem saveInBackground];
}

- (void) transitionToMainViewWithFeedbackItem:(PPFeedbackItem*) feedbackItem {
    // clear old boxes first
    [self deleteChildBoxes];
    
    for (PPBox* boxModel in feedbackItem.boxes) {
        PPBoxViewController *box = [[PPBoxViewController alloc] initWithModel:boxModel];
        [self addBoxController:box toView:self.imageView];
        [box disableEditing];
        [box makeSelection:false];
    }

    UIImage *image = [PPUtilities getImageFromObject:feedbackItem.imageObject];
    [self transitionToMainViewWithImage:image];
}


- (NSString*) placeholderText {
    return @"Add a comment on selected area...";
}

- (void) touchUpInsideExitButton {
    [self transitionToOrganizerViewController];
}

- (void) touchUpInsideSendButton {
    [self saveFeedbackItem];
    [self transitionToOrganizerViewController];
}

- (void) saveFeedbackItem {
    [self saveChildBoxes];
    [self.feedbackItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFPush* feedbackItemPush = [PPUtilities pushWithFeedbackItem:self.feedbackItem];
            [feedbackItemPush sendPushInBackground];
        } else {
            NSLog(@"There was an error saving feedback item %@", self.feedbackItem);
        }
    }];
}

- (void) transitionToOrganizerViewController {
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
                [self performTransitionToOrganizerViewController];
            }
        }];
    } else {
        [self performTransitionToOrganizerViewController];
    }
}

- (void) performTransitionToOrganizerViewController {
    [self.pageViewController transitionToOrganizerViewController];
}

- (UIViewController*) controllerForPaging { 
    if (self.feedbackItem) {
        return self;
    } else {
        return nil;
    }
}


@end
