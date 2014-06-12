//
//  HSUtilities.m
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/7/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSUtilities.h"
#import <Parse/Parse.h>

@implementation HSUtilities

+ (NSString*) trim: (NSString*) text {
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*) getEmailUsername: (NSString*) text {
    NSArray *temp = [text componentsSeparatedByString: @"@"];
    return [temp objectAtIndex:0];
}

+ (NSError*) newError: (NSString*) message {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:@"error"];
    NSError *error = [NSError errorWithDomain:@"SH" code:418 userInfo:details];
    return error;
}

+ (void) showError:(NSError *) error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:[error.userInfo objectForKey:@"error"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
