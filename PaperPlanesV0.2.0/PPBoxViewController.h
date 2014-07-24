//
//  PPBoxViewController.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/1/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPBoxView.h"

@interface PPBoxViewController : UIViewController <UIGestureRecognizerDelegate, BoxViewDelegate>

- (void) makeSelection: (BOOL) select;
- (BOOL) boxHasChangedForm;

@property (strong, nonatomic) PPBoxView *view;
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSMutableArray* comments;

@end

@protocol BoxViewControllerDelegate

- (void) boxSelectionChanged:(PPBoxViewController*) box toState:(BOOL) selectionState;
- (void) boxWasDeleted:(PPBoxViewController*) box;
- (void) boxWasPanned:(PPBoxViewController*) box;

@end

