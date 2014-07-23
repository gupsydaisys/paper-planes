//
//  AppDelegate.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()
            

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


@end
