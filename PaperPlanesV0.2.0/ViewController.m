//
//  ViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "ViewController.h"
#import "PPBoxView.h"

@interface ViewController () {
    PPBoxView* selectedBox;
}
            

@end

@implementation ViewController

#pragma mark - initialization code

- (void) viewDidLoad {
    [super viewDidLoad];
    [self addGestureRecognizers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.imageScrollView.contentSize = self.imageView.frame.size;
}

- (void) addGestureRecognizers {
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageHandler:)];
    [self.imageView addGestureRecognizer:tapRecognizer];
}

#pragma mark - Gesture recognizer delegate

- (void) tapImageHandler: (UITapGestureRecognizer *) gesture {
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    PPBoxView* touchedBox = [self getTouchedBox:gesture];
    if (touchedBox == nil) {
        touchedBox = [PPBoxView boxViewCenteredAtPoint:touchPoint];
        [gesture.view addSubview:touchedBox];
    }

    [self selectBox:touchedBox];
}

- (UIView*) getHitView: (UIGestureRecognizer *) gesture {
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    return [gesture.view hitTest:touchPoint withEvent:nil];
}

#pragma mark - Box methods

- (void) deselect: (PPBoxView*) box {
    [box marchingAnts:FALSE];
    selectedBox = nil;
}

- (void) select: (PPBoxView*) box {
    [box marchingAnts:TRUE];
    selectedBox = box;
}

- (void) selectBox: (PPBoxView*) box {
    [self deselect:selectedBox];
    [self select:box];
}

- (PPBoxView*) getTouchedBox: (UIGestureRecognizer*) gesture {
    UIView *hitView = [self getHitView:gesture];
    if ([hitView isKindOfClass:[PPBoxView class]]) {
        return (PPBoxView*)hitView;
    }
    return nil;
}

#pragma mark - Scroll view delegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark -



@end
