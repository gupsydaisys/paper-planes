//
//  ViewController.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "PPBoxView.h"
#import "PPBoxViewController.h"
#import "PPViewController.h"
#import "PPCenteredScrollView.h"
#import "PPPageViewController.h"

@interface PPFeedbackViewController : PPViewController <UIScrollViewDelegate, HPGrowingTextViewDelegate, UIGestureRecognizerDelegate, BoxViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) UIImage *image;

/* Main View */
@property (weak, nonatomic) IBOutlet UIView *mainView;

/* Image View */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet PPCenteredScrollView *imageScrollView;

/* Comment Table Container */
@property (weak, nonatomic) IBOutlet UIView *tableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContainerHeight;
@property (weak, nonatomic) IBOutlet UIView *tableHandle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/* Post Comment Paraphenilia */
@property (strong, nonatomic) HPGrowingTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *postCommentContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postCommentHeight;

/* Post & Associated */
@property (weak, nonatomic) IBOutlet UIButton *postButton;
- (IBAction) tapPostComment:(id) sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;

/* Drag Post Comment */
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *dragPostCommentContainerRecognizer;
- (IBAction) dragPostCommentContainer:(id) sender;

/* Drag Comments Table Container */
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *dragTableHandleRecognizer;
- (IBAction)dragTableHandle:(UIPanGestureRecognizer *)sender;

@property (nonatomic, weak) PPPageViewController* pageViewController;

enum commentStateTypes
{
    CLOSED = 0,
    ONE = 1,
    HALF = 2,
    FULL = 3,
} typedef CommentState;

- (void) initCamera;
- (void) initMainView;
- (void) transitionToMainView;

@end