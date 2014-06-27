//
//  PPBoxView.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPBoxView : UIView

- (void) marchingAnts: (BOOL) turnOn;
- (void) showControls: (BOOL) show;

@property (nonatomic, strong) UIPanGestureRecognizer* moveButtonPanGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer* resizeButtonPanGestureRecognizer;
@property (nonatomic, strong) NSMutableArray* controls;

@property (nonatomic, assign) id delegate;

@end

@protocol BoxViewDelegate

- (void) boxViewWasDeleted:(PPBoxView*) boxView;

@end

