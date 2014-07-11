//
//  PPPushNoAnimationSegue.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/10/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPPushNoAnimationSegue.h"

@implementation PPPushNoAnimationSegue

- (void) perform {
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
