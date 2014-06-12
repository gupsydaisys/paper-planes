//
//  HSConversation.h
//  improvisio-v4.2
//
//  Created by lux on 6/10/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <Parse/Parse.h>

@interface HSConversation : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *displayName;
@property NSString* title;
@property BOOL isQuickQuestion;
@property (retain, nonatomic) NSArray* comments;
@property (retain) PFFile *image;
@property (retain) PFUser *creator;


@end
