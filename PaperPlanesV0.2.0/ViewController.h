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

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) HPGrowingTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postCommentHeight;
@property (weak, nonatomic) IBOutlet UIView *postCommentContainer;

@property (weak, nonatomic) IBOutlet UIButton *postButton;
- (IBAction) tapPostComment:(id) sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *dragPostCommentContainerRecognizer;
- (IBAction) dragPostCommentContainer:(id) sender;

@end