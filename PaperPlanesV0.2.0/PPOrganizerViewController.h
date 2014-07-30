//
//  PPOrganizerViewController.h
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/15/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PPViewController.h"
#import "PPFeedbackItem.h"

@interface PPOrganizerViewController : PPViewController

- (void) addImageObject:(PFObject*)imageObject;
- (void) handleFeedbackItemPush:(PPFeedbackItem *) feedbackItem;

@end
