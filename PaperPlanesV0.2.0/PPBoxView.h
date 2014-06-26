//
//  PPBoxView.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPBoxView : UIView

+ (PPBoxView *) atPoint: (CGPoint) point;
+ (PPBoxView *) centeredAtPoint: (CGPoint) point;
+ (PPBoxView *) atPoint: (CGPoint) point withSize: (CGSize) size;

- (void) marchingAnts: (BOOL) turnOn;
- (void) showControls: (BOOL) show;

@end
