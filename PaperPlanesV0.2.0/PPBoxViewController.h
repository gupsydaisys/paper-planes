//
//  PPBoxViewController.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/1/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPBox.h"
#import "PPBoxView.h"
#import "PPBoxComment.h"

@interface PPBoxViewController : UIViewController <UIGestureRecognizerDelegate, BoxViewDelegate>

- (void) makeSelection: (BOOL) select;
- (void) addComment: (PPBoxComment*) comment;
- (BOOL) boxHasChangedForm;
- (NSArray*) comments;
- (void) savePosition;
- (id) initWithModel:(PPBox*) model;
- (PPBox*) getModel;
- (void) disableEditing;
- (void) enableEditing;

@property (strong, nonatomic) PPBoxView *view;
@property (nonatomic, assign) id delegate;

@end

@protocol BoxViewControllerDelegate

- (void) boxSelectionChanged:(PPBoxViewController*) box toState:(BOOL) selectionState;
- (void) boxWasDeleted:(PPBoxViewController*) box;
- (void) boxWasPanned:(PPBoxViewController*) box;

@end

