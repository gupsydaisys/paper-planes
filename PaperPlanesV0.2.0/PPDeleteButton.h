//
//  PPDeleteButton.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPDeleteButton : UIControl

+ (PPDeleteButton *) atPoint: (CGPoint) point;
+ (PPDeleteButton *) centeredAtPoint: (CGPoint) point;
+ (PPDeleteButton *) atPoint: (CGPoint) point withSize: (CGSize) size;
- (void) setColor: (UIColor*) color;

@end
