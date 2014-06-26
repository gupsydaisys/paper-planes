//
//  PPButton.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/26/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"

@interface PPButton : UIView

- (UILabel*) fontAwesomeLabel:(FAIcon) iconName withFrame:(CGRect) rect;

@end
