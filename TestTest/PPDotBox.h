//
//  PPDotBox.h
//  PaperPlanesV0.1.0
//
//  Created by lux on 6/16/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <Parse/Parse.h>

@interface PPDotBox : PFObject<PFSubclassing>

@property (retain) NSString* displayName;
@property float originX;
@property float originY;
@property float width;
@property float height;
@property bool selected;
@property (retain, nonatomic) NSArray* comments;

@end
