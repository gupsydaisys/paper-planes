//
//  PPBox.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/23/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPBox.h"
#import <Parse/PFObject+Subclass.h>

@implementation PPBox

@dynamic displayName;
@dynamic originX;
@dynamic originY;
@dynamic width;
@dynamic height;
@dynamic comments;

+ (NSString *) parseClassName {
    return @"Box";
}

- (void) addComment:(NSString *)text {
    [self addObject:text forKey:@"comments"];
}

@end
