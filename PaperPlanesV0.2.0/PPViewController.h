//
//  PPViewController.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/18/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPageViewController.h"

@interface PPViewController : UIViewController <UIPageViewControllerDelegate>

- (UIViewController*) controllerForPaging;
@property (nonatomic, weak) PPPageViewController* pageViewController;

@end
