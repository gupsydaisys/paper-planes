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
    
    self.requestViewController = (PPFeedbackViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PPRequestViewController"];
    self.requestViewController.pageViewController = self;
    
    self.feedbackViewController = (PPFeedbackViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PPFeedbackViewController"];
    self.feedbackViewController.pageViewController = self;
    
    self.allViewControllers = [[NSArray alloc] initWithObjects:self.requestViewController, self.organizerViewController, self.feedbackViewController, nil];
    
    [self setViewControllers:[NSArray arrayWithObject:self.requestViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int nextIndex = [self.allViewControllers indexOfObject:viewController] + 1;
    if (nextIndex >= self.allViewControllers.count) {
        return nil;
    } else {
        return [self.allViewControllers objectAtIndex:nextIndex];
    }
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int nextIndex = [self.allViewControllers indexOfObject:viewController] - 1;
    if (nextIndex < 0) {
        return nil;
    } else {
        return [self.allViewControllers objectAtIndex:nextIndex];
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

- (UIViewController *) currentlyShownViewController {
    // We only show 1 view controller at a time
    return [self.viewControllers objectAtIndex:0];
}


- (void) transitionToController: (UIViewController*) controller completion:(void(^)(void)) callback {
    
    UIPageViewControllerNavigationDirection direction;
    
    if ([self.allViewControllers indexOfObject:controller] > [self.allViewControllers indexOfObject:[self currentlyShownViewController]]) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    __block PPPageViewController *blocksafeSelf = self;
    [self setScrollEnabled:FALSE];
    if (!self.transitioning) {
        [self setViewControllers:[NSArray arrayWithObject:controller] direction:direction animated:YES completion:^(BOOL finished) {
            if (finished) {
                [blocksafeSelf setScrollEnabled:TRUE];
                blocksafeSelf.transitioning = FALSE;
                callback();
            }
        }];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
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

# pragma mark - iPhone Preference UI Methods
- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

- (BOOL) prefersStatusBarHidden {
    return TRUE;
}

@end
