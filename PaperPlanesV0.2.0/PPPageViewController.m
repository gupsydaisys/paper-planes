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
#import "PPOrganizerViewController.h"

@interface PPPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
}

@property (nonatomic, strong) PPOrganizerViewController* organizerViewController;
@property (nonatomic, strong) PPFeedbackViewController* requestViewController;
@property (nonatomic, strong) PPFeedbackViewController* feedbackViewController;
@property (nonatomic, strong) NSArray* allViewControllers;

// This may not be necessary but it seems to decrease the chances of
// getting a NSInternalInconsistencyException upon transitioning while the screen is touched
// See: http://stackoverflow.com/questions/12916422/assertion-failure-in-uiqueuingscrollview-didscrollwithanimationforce
@property BOOL transitioning;

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
    
    self.requestViewController = (PPFeedbackViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PPRequestFeedbackViewController"];
    self.requestViewController.pageViewController = self;
    
    self.feedbackViewController = (PPFeedbackViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PPAddFeedbackViewController"];
    self.feedbackViewController.pageViewController = self;
    
    self.allViewControllers = [[NSArray alloc] initWithObjects:self.requestViewController, self.organizerViewController, self.feedbackViewController, nil];
    
    [self setViewControllers:[NSArray arrayWithObject:self.requestViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int nextIndex = [self.allViewControllers indexOfObject:viewController] + 1;
    if (nextIndex >= self.allViewControllers.count) {
        return nil;
    } else {
        return [(PPViewController*)[self.allViewControllers objectAtIndex:nextIndex] controllerForPaging];
    }
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int nextIndex = [self.allViewControllers indexOfObject:viewController] - 1;
    if (nextIndex < 0) {
        return nil;
    } else {
        return [(PPViewController*)[self.allViewControllers objectAtIndex:nextIndex] controllerForPaging];
    }
}

- (void) transitionToRequestViewController {
    [self transitionToRequestViewController:^{}];
}

- (void) transitionToRequestViewController:(void(^)(void)) callback {
    [self transitionToController:self.requestViewController completion:^{
        callback();
    }];
}

- (void) transitionToOrganizerViewController {
    [self transitionToOrganizerViewController:^{}];
}

- (void) transitionToOrganizerViewController:(void(^)(void)) callback {
    [self transitionToController:self.organizerViewController completion:^{
        callback();
    }];
}

- (void) transitionToFeedbackViewController {
    [self transitionToFeedbackViewController:^{}];
}

- (void) transitionToFeedbackViewController:(void(^)(void)) callback {
    [self transitionToController:self.feedbackViewController completion:^{
        callback();
    }];
}

- (PPViewController *) currentlyShownViewController {
    // We only show 1 view controller at a time
    return (PPViewController*)[self.viewControllers objectAtIndex:0];
}


- (void) transitionToController: (UIViewController*) controller completion:(void(^)(void)) callback {
    
    UIPageViewControllerNavigationDirection direction;
    PPViewController* currentController = [self currentlyShownViewController];
    NSArray* nextController = [NSArray arrayWithObject:controller];
    
    if ([self.allViewControllers indexOfObject:controller] > [self.allViewControllers indexOfObject:currentController]) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    __block PPPageViewController *blocksafeSelf = self;
    [self setScrollEnabled:FALSE];
    if (!self.transitioning) {
        [currentController pageViewController:self willTransitionToViewControllers:nextController];
        [self setViewControllers:nextController direction:direction animated:YES completion:^(BOOL finished) {
            if (finished) {
                [blocksafeSelf setScrollEnabled:TRUE];
                blocksafeSelf.transitioning = FALSE;
                callback();
            }
        }];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    [[self currentlyShownViewController] pageViewController:pageViewController willTransitionToViewControllers:pendingViewControllers];
    self.transitioning = TRUE;
}

- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished) {
        self.transitioning = FALSE;
    }
}

- (void) setScrollEnabled:(BOOL)enabled {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            [scrollView setScrollEnabled:enabled];
            return;
        }
    }
}

- (BOOL) prefersStatusBarHidden {
    return TRUE;
}

@end
