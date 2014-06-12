//
//  HSComment.m
//  improvisio-v4.2
//
//  Created by lux on 6/10/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSComment.h"
#import <Parse/PFObject+Subclass.h>

@implementation HSComment

@dynamic displayName;
@dynamic content;
@dynamic creator;

+ (NSString *)parseClassName {
    return @"Comment";
}

@end
