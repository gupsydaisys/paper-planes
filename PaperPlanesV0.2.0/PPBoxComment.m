//
//  PPComment.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 6/27/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPBoxComment.h"
#import <Parse/PFObject+Subclass.h>

@implementation PPBoxComment

@dynamic displayName;
@dynamic text;
@dynamic creator;
@dynamic haveViewed;

+ (NSString *) parseClassName {
    return @"BoxComment";
}

+ (PPBoxComment*) commentWithText:(NSString*) text {
    PPBoxComment* comment = [self object];
    comment.text = text;
    comment.creator = [PFUser currentUser];
    comment.haveViewed = [[NSArray alloc] initWithObjects:[PFUser currentUser].objectId, nil];
    return comment;
}

@end
