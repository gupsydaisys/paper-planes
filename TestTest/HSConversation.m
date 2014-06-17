//
//  HSConversation.m
//  improvisio-v4.2
//
//  Created by lux on 6/10/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSConversation.h"
#import <Parse/PFObject+Subclass.h>

@implementation HSConversation

@dynamic displayName;
@dynamic title;
@dynamic isQuickQuestion;
@dynamic comments;
@dynamic dotboxes;
@dynamic image;
@dynamic creator;

+ (NSString *)parseClassName {
    return @"Conversation";
}


@end
