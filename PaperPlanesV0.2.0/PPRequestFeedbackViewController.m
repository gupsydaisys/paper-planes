//
//  PPRequestFeedbackViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/18/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPRequestFeedbackViewController.h"

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
    return @"Ask for feedback here...";
}

- (void) touchUpInsideExitButton {
    // Overridden in subclass
    [self transitionToCameraView];
}

- (void) touchUpInsideSendButton {
    [self.pageViewController transitionToOrganizerViewController:^{
        [self transitionToCameraView];
    }];
}

- (UIViewController*) controllerForPaging {
    return self;
}

@end
