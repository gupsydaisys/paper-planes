//
//  PPBox.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/23/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <Parse/Parse.h>

@interface PPBox : PFObject<PFSubclassing>

+ (NSString *) parseClassName;
@property (retain) NSString *displayName;

@property float originX;
@property float originY;
@property float width;
@property float height;
@property (retain, nonatomic) NSMutableArray* comments;

- (void) addComment:(NSString*) text;

@end
