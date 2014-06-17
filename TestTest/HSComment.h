//
//  HSComment.h
//  improvisio-v4.2
//
//  Created by lux on 6/10/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <Parse/Parse.h>
#import "PPDotBox.h"

@interface HSComment : PFObject<PFSubclassing>

+ (NSString *)parseClassName;
@property (retain) NSString* displayName;
@property NSString* content;
@property (retain) PFUser* creator;
@property (retain) PPDotBox* dotBox;

@end
