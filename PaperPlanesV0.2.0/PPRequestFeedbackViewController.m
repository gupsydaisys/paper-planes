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

@end
