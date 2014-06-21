//
//  PPDotBoxView.h
//  PaperPlanesV0.1.0
//
//  Created by lux on 6/12/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPDotBox.h"

@interface PPDotBoxView : UIView

+ (PPDotBoxView *) dotBoxAtPoint: (CGPoint) point;

- (id) initWithModel:(PPDotBox*) model;
- (BOOL) toggleSelected;
- (BOOL) setSelected:(BOOL) isSelected;
- (void) blink;
- (void) logComments;
- (BOOL) isSelected;

@property float minWidth;
@property (nonatomic, strong) PPDotBox *model;
@property (nonatomic, strong) UIView *deleteButton;
@property (nonatomic, strong) CAShapeLayer* dotLayer;

@end
