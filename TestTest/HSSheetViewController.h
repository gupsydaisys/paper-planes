//
//  HSSheetViewController.h
//  improvisio-v4.2
//
//  Created by lux on 6/11/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPDotBoxView.h"

@interface HSSheetViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>

- (void) commentAdded;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *fadeView;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;

@property (weak, nonatomic) IBOutlet UIView *commentsViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UIView *commentsHandle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsTableViewHeightConstraint;

enum commentStateTypes
{
    CLOSED = 0,
    HALFUP = 1,
    FULL = 2,
    HALFDOWN = 3,
} typedef CommentState;

@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *dragCommentsRecognizer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapCommentsRecognizer;

- (IBAction)dragCommentsHandle:(UIPanGestureRecognizer *)sender;
- (IBAction)tapCommentsHandle:(UITapGestureRecognizer *)sender;

@property (strong, nonatomic) PPDotBoxView* currentlySelectedDotBox;

@end
