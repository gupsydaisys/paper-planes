//
//  PPUtilities.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/22/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPUtilities.h"

@implementation PPUtilities

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
    NSError *error = [NSError errorWithDomain:@"PP" code:418 userInfo:details];
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
