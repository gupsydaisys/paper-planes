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
    BOOL disableEditing;
    UITapGestureRecognizer* boxTapGestureRecognizer;
}
@property (nonatomic, strong) PPBox *model;


@end

@implementation PPBoxViewController

@dynamic view;
@synthesize delegate;

- (id) initWithModel:(PPBox*) model {
    self = [self init];
    if (self) {
        self.model = model;
        CGRect boxFrame = CGRectMake(model.originX, model.originY, model.width, model.height);
        PPBoxView* boxView = [[PPBoxView alloc] initWithFrame:boxFrame];
        self.view = boxView;
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self) {
        self.model = [PPBox object];
        self.comments = [[NSMutableArray alloc] init];
    }
    return self;
}

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
        if (disableEditing) {
            [self.view showControls:FALSE];
        } else {
            [self.view showControls:selectionState];
        }
        [self.view marchingAnts:selectionState];
        [delegate boxSelectionChanged:self toState:selectionState];
    }

}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    boxTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boxTapped:)];
    [self.view addGestureRecognizer:boxTapGestureRecognizer];
    self.view.delegate = self;
}

- (void) boxTapped: (UITapGestureRecognizer *) gesture {
    /* This condition is to prevent deselection of a new box without any comments on it */
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

- (void) addComment:(PPBoxComment *)comment {
    [self.model addComment:comment];
}

- (BOOL) boxHasChangedForm {
    return [self.view hasChangedForm];
}

- (NSArray*) comments {
    return self.model.comments;
}

- (void) setComments: (NSMutableArray*) comments {
    self.model.comments = comments;
}

- (PPBox*) getModel {
    [self savePosition];
    return self.model;
}

- (void) disableEditing {
    disableEditing = TRUE;
}

- (void) enableEditing {
    disableEditing = FALSE;
}

- (void) savePosition {
    CGRect boxFrame = [self.view boxFrame];
    self.model.originX = boxFrame.origin.x;
    self.model.originY = boxFrame.origin.y;
    self.model.width  = boxFrame.size.width;
    self.model.height  = boxFrame.size.height;
}


@end
