//
//  HSUtilities.h
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/7/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSUtilities : NSObject

+ (NSString*) trim: (NSString*) text;
+ (NSString*) getEmailUsername: (NSString*) text;
+ (NSError*) newError: (NSString*) message;
+ (void) showError:(NSError *) error;

@end
