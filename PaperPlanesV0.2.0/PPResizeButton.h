//
//  PPResizeButton.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/25/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPResizeButton : UIView

+ (PPResizeButton *) atPoint: (CGPoint) point;
+ (PPResizeButton *) centeredAtPoint: (CGPoint) point;
+ (PPResizeButton *) atPoint: (CGPoint) point withSize: (CGSize) size;
- (void) setColor: (UIColor*) color;

@end
