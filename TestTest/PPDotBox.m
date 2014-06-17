//
//  PPDotBox.m
//  PaperPlanesV0.1.0
//
//  Created by lux on 6/16/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "PPDotBox.h"
#import <Parse/PFObject+Subclass.h>

@implementation PPDotBox

@dynamic displayName;
@dynamic originX;
@dynamic originY;
@dynamic width;
@dynamic height;


+ (NSString *)parseClassName {
    return @"DotBox";
}

@end
