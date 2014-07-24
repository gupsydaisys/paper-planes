//
//  PPBoxViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/1/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPBoxViewController.h"
#import "PPBoxView.h"

@interface PPBoxViewController () {
    BOOL selectionState;
    UITapGestureRecognizer* boxTapGestureRecognizer;
}


@end

@implementation PPBoxViewController

@dynamic view;
@synthesize delegate;

- (void) toggleSelection {
    selectionState = !selectionState;
    [self makeSelection:selectionState];
}

- (void) makeSelection:(BOOL) select {
    /* Delete unselected box without a comment */
    if ((self.comments == nil || self.comments.count == 0) && !select) {
        [delegate boxWasDeleted:self];
    } else {
        selectionState = select;
        [self.view showControls:selectionState];
        [self.view marchingAnts:selectionState];
        [delegate boxSelectionChanged:self toState:selectionState];
    }

}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    boxTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boxTapped:)];
    [self.view addGestureRecognizer:boxTapGestureRecognizer];
    self.view.delegate = self;
    self.comments = [[NSMutableArray alloc] init];
}

- (void) boxTapped: (UITapGestureRecognizer *) gesture {
    /* Can't unselecte a box without a comment */
    if (self.comments != nil && self.comments.count > 0) {
        [self toggleSelection];
    }
}

- (void) boxViewWasDeleted:(PPBoxView *)boxView {
    [delegate boxWasDeleted:self];
}

- (void) boxViewWasPanned:(PPBoxView *) boxView {
    [delegate boxWasPanned:self];
}

- (BOOL) boxHasChangedForm {
    return [self.view hasChangedForm];
}

@end
