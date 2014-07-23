//
//  PPPageViewController.h
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/16/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PPOrganizerViewController.h"
//#import "PPFeedbackViewController.h"
//#import "PPOrganizerViewController.h"


@interface PPPageViewController : UIPageViewController

- (void) transitionToRequestViewController;
- (void) transitionToRequestViewController:(void(^)(void)) callback;
- (UIViewController*) getRequestViewController;

- (void) transitionToFeedbackViewController;
- (void) transitionToFeedbackViewController:(void(^)(void)) callback;
- (UIViewController*) getFeedbackViewController;

- (void) transitionToOrganizerViewController;
- (void) transitionToOrganizerViewController:(void(^)(void)) callback;
- (UIViewController*) getOrganizerViewController;

@end
