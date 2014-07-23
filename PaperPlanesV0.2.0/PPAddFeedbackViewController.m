//
//  PPAddFeedbackViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/18/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPAddFeedbackViewController.h"

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
    [self.pageViewController transitionToOrganizerViewController];
}

- (void) touchUpInsideSendButton {
    [self.pageViewController transitionToOrganizerViewController];
}

- (UIViewController*) controllerForPaging {
    if (self.image) {
        return self;
    } else {
        return nil;
    }
}


@end
