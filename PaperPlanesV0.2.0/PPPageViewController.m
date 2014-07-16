//
//  PPPageViewController.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/16/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPPageViewController.h"
#import "PPOrganizerViewController.h"
#import "PPFeedbackViewController.h"

@interface PPPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) PPOrganizerViewController* organizerViewController;
@property (nonatomic, strong) PPFeedbackViewController* feedbackViewController;

@end

@implementation PPPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.organizerViewController = (PPOrganizerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PPOrganizerViewController"];
    self.organizerViewController.pageViewController = self;
    self.feedbackViewController = (PPFeedbackViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PPFeedbackViewController"];
    self.feedbackViewController.pageViewController = self;
    
    [self setViewControllers:[NSArray arrayWithObject:self.feedbackViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (BOOL) prefersStatusBarHidden {
    return TRUE;
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == self.organizerViewController) {
        return nil;
    } else {
        return self.organizerViewController;
    }
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == self.feedbackViewController) {
        return nil;
    } else {
        return self.feedbackViewController;
    }
}

- (void) transitionToFeedbackViewController {
    [self setViewControllers:[NSArray arrayWithObject:self.feedbackViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
