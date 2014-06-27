//
//  PPComment.h
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 6/27/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPComment : NSObject

@property NSString* content;
@property NSDate* createdAt;
@property NSString* creator;
@property int thanksNum;

@end
