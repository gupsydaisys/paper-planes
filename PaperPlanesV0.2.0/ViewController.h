//
//  ViewController.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, HPGrowingTextViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) HPGrowingTextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postCommentHeight;
@property (weak, nonatomic) IBOutlet UIView *postCommentContainer;

- (IBAction)tapPostComment:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;


@end