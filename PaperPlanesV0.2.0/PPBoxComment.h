//
//  PPComment.h
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 6/27/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <Parse/Parse.h>

@interface PPBoxComment : PFObject<PFSubclassing>

@property (retain) NSString *displayName;
+ (NSString *) parseClassName;

@property (retain) NSString *text;
@property (retain) PFUser *creator;
@property (retain, nonatomic) NSArray* haveViewed;

+ (PPBoxComment*) commentWithText:(NSString*) text;

@end
