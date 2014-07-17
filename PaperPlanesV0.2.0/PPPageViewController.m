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
@property (nonatomic, strong) PPFeedbackViewController* feedbackViewController;
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
    self.feedbackViewController = (PPFeedbackViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"PPFeedbackViewController"];
    self.feedbackViewController.pageViewController = self;
    
    [self setViewControllers:[NSArray arrayWithObject:self.feedbackViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (BOOL) prefersStatusBarHidden {
    return TRUE;
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == self.organizerViewController) {
        return nil;
    } else {
        return self.organizerViewController;
    }
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == self.feedbackViewController) {
        return nil;
    } else {
        return self.feedbackViewController;
    }
}

- (void) transitionToFeedbackViewController {
    __block PPPageViewController *blocksafeSelf = self;
    [self setScrollEnabled:FALSE];
    
    if (!self.transitioning) {
        [self setViewControllers:[NSArray arrayWithObject:self.feedbackViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            if (finished) {
                [blocksafeSelf setScrollEnabled:TRUE];
                blocksafeSelf.transitioning = FALSE;
                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [blocksafeSelf setViewControllers:[NSArray arrayWithObject:blocksafeSelf.feedbackViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
                });
            }
        }];
    }

}

- (void) transitionToOrganizerViewController {
    __block PPPageViewController *blocksafeSelf = self;
    [self setScrollEnabled:FALSE];
    if (!self.transitioning) {

        [self setViewControllers:[NSArray arrayWithObject:self.organizerViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            if (finished) {
                [blocksafeSelf setScrollEnabled:TRUE];
                blocksafeSelf.transitioning = FALSE;
                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [blocksafeSelf setViewControllers:[NSArray arrayWithObject:blocksafeSelf.organizerViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                });
            }
        }];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    self.transitioning = TRUE;
//    [self setScrollEnabled:FALSE];
}

- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished) {
        self.transitioning = FALSE;
//        [self setScrollEnabled:TRUE];
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

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touch began");
//    self.isBeingTouched = YES;
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touch cancelled");
//    self.isBeingTouched = NO;
//    [super touchesCancelled:touches withEvent:event];
//}
//
//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touch ended");
//    self.isBeingTouched = NO;
//    [super touchesEnded:touches withEvent:event];
//}




@end
