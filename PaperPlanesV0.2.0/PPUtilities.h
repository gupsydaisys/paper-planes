//
//  PPUtilities.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/22/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PPFeedbackItem.h"
#import "UIBAlertView.h"

@interface PPUtilities : NSObject

+ (NSString*) trim: (NSString*) text;
+ (NSString*) getEmailUsername: (NSString*) text;
+ (NSError*) newError: (NSString*) message;
+ (void) showError:(NSError *) error;

+ (UIBAlertView*) getAlertUnsavedCommentAbandon:(NSString*) nameOfAbandonedObject;
+ (UIBAlertView*) getAlertUnsavedEdits;
+ (UIImage*) getImageFromObject:(PFObject*) imageObject;
+ (PFPush*) pushWithFeedbackItem:(PPFeedbackItem*) feedbackItem;

@end
