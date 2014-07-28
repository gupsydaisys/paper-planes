//
//  PPFeedbackItem.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/23/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPFeedbackItem.h"
#import <Parse/PFObject+Subclass.h>

@implementation PPFeedbackItem

@dynamic displayName;
@dynamic imageObject;
@dynamic creator;
@dynamic boxes;
@dynamic haveViewed;

+ (NSString *) parseClassName {
    return @"FeedbackItem";
}

@end
