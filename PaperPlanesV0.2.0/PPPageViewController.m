//
//  PPPageViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/8/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPPageViewController.h"

@interface PPPageViewController () {
    UIViewController* cameraViewController;
    UIViewController* feedbackViewController;
}

@end

@implementation PPPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = self;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    cameraViewController = [sb instantiateViewControllerWithIdentifier:@"PPCameraViewController"];
    feedbackViewController = [sb instantiateViewControllerWithIdentifier:@"PPFeedbackViewController"];
    
//    NSArray *viewControllers = [NSArray arrayWithObjects:cameraViewController, feedbackViewController, nil];
    
    
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *viewControllers = [NSArray arrayWithObject:cameraViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (viewController == cameraViewController) {
        return feedbackViewController;
    } else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == feedbackViewController) {
        return cameraViewController;
    } else {
        return nil;
    }
}

@end
