//
//  PPPageViewController.h
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/16/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPPageViewController : UIPageViewController

- (void) transitionToFeedbackViewController;
- (void) transitionToOrganizerViewController;
- (void) transitionToFeedbackViewController:(void(^)(void)) callback;
- (void) transitionToOrganizerViewController:(void(^)(void)) callback;

@end
