//
//  AppDelegate.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "AppDelegate.h"
#import "PPPageViewController.h"
#import "PPOrganizerViewController.h"
#import "PPFeedbackItem.h"
#import "PPBox.h"
#import "PPBoxComment.h"
#import <Parse/Parse.h>

@interface AppDelegate ()
            

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PPFeedbackItem registerSubclass];
    [PPBox registerSubclass];
    [PPBoxComment registerSubclass];
    
    [Parse setApplicationId:@"GWcbVtJelPpTL3yJB4ajgHcsxJFdlFDCnBnopNoe"
                  clientKey:@"SnU5aen5AC3SfTyPViOvKIeU8s2xBJ3aVHMCDH9w"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [application registerForRemoteNotificationTypes:
                     UIRemoteNotificationTypeBadge |
                     UIRemoteNotificationTypeAlert |
                     UIRemoteNotificationTypeSound];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:@"FeedbackItem" forKey:@"channels"];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSString *feedbackItemObjectId = [userInfo objectForKey:@"objectId"];
    PFQuery *userFilter = [PFUser query];
    [userFilter whereKey:@"role" notEqualTo:@"admin"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FeedbackItem"];
    [query includeKey:@"imageObject"];
    [query includeKey:@"boxes"];
    [query includeKey:@"creator"];
    [query includeKey:@"boxes.comments"];
    [query includeKey:@"boxes.comments.creator"];
    [query whereKey:@"objectId" equalTo:feedbackItemObjectId];
    [query whereKey:@"creator" matchesQuery:userFilter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error fetching feedback item: %@", error);
        } else {
            if ([objects count] > 0) {
                PPFeedbackItem* feedbackItem = [objects lastObject];
                UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
                PPPageViewController* pageViewController = (PPPageViewController*)[navigationController.viewControllers lastObject];
                PPOrganizerViewController* organizerViewController = (PPOrganizerViewController*)[pageViewController getOrganizerViewController];
                [organizerViewController handleFeedbackItemPush:feedbackItem];
            } else {
                NSLog(@"non-existent feedback item? -> %@", feedbackItemObjectId);
            }
        }
    }];
}


@end
