//
//  ViewController.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, HPGrowingTextViewDelegate>

/* Main View */
@property (weak, nonatomic) IBOutlet UIView *mainView;

/* Image View */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

/* Comment Table Container */
@property (weak, nonatomic) IBOutlet UIView *tableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContainerHeight;

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
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *dragTableHandleRecognizer;
- (IBAction)dragTableHandle:(UIPanGestureRecognizer *)sender;

enum commentStateTypes
{
    CLOSED = 0,
    HALFUP = 1,
    FULL = 2,
    HALFDOWN = 3,
} typedef CommentState;

@end