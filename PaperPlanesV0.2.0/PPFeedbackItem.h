//
//  PPFeedbackItem.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/23/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <Parse/Parse.h>

@interface PPFeedbackItem : PFObject<PFSubclassing>

+ (NSString *) parseClassName;

@property (retain) NSString *displayName;
@property (retain) PFObject *imageObject;
@property (retain, nonatomic) NSArray* boxes;

@end
