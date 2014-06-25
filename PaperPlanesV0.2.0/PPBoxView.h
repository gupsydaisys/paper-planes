//
//  PPBoxView.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPBoxView : UIView

+ (PPBoxView *) boxViewAtPoint: (CGPoint) point;
+ (PPBoxView *) boxViewCenteredAtPoint: (CGPoint) point;
+ (PPBoxView *) boxViewAtPoint: (CGPoint) point withSize: (CGSize) size;

- (void) marchingAnts: (BOOL) turnOn;

@end
