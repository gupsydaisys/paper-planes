//
//  PPRequestFeedbackViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/18/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPRequestFeedbackViewController.h"
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
    /* Alert iff selected dotbox has unsaved text in comment field */
    if (self.selectedBox != nil && ![self.textView.text isEqualToString:@""]) {
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
    /* Alert iff selected dotbox has unsaved text in comment field */
    if (self.selectedBox != nil && ![self.textView.text isEqualToString:@""]) {
        UIBAlertView *alert = [PPUtilities getAlertUnsavedCommentAbandon:@"screen"];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel) {
                return;
            } else {
                [self.pageViewController transitionToOrganizerViewController:^{
                    [self transitionToCameraView];
                }];
            }
        }];
    } else {
        [self.pageViewController transitionToOrganizerViewController:^{
            [self transitionToCameraView];
        }];
    }
}

- (UIViewController*) controllerForPaging {
    return self;
}

@end
