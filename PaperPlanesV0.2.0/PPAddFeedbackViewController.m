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
    [self transitionToMainViewWithFeedbackItem:self.feedbackItem];
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
    
    [self showComments:YES state:FULL];
    
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
    [super touchUpInsideSendButton];
    [self.feedbackItem saveInBackground];
    [self transitionToOrganizerViewController];
}

- (void) transitionToOrganizerViewController {
    /* Alert iff selected dotbox has unsaved text in comment field */
    if (self.selectedBox != nil && ![self.textView.text isEqualToString:@""]) {
        UIBAlertView *alert = [PPUtilities getAlertUnsavedComment];
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
