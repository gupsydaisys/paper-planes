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
    [self transitionToMainView];
}

- (NSString*) placeholderText {
    return @"Add a comment on selected area...";
}

- (void) touchUpInsideExitButton {
    [self transitionToOrganizerViewController];
}

- (void) touchUpInsideSendButton {
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
                [self.pageViewController transitionToOrganizerViewController];
            }
        }];
    } else {
        [self.pageViewController transitionToOrganizerViewController];
    }
}

- (UIViewController*) controllerForPaging {
    if (self.image) {
        return self;
    } else {
        return nil;
    }
}


@end
