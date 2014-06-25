//
//  ViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "ViewController.h"

/* Post Comment Constants */
#define X_COMMENT_OFFSET 7.0f
#define Y_COMMENT_OFFSET 7.0f
#define COMMENT_WIDTH 236.0f
#define COMMENT_MIN_HEIGHT 36.0f
#define COMMENT_MAX_HEIGHT 77.5f
#define TEXT_SIZE 15.0f
#define PLACEHOLDER_TEXT @"Give Feedback here..."

@interface ViewController ()


@end

@implementation ViewController

#pragma mark - Initialization of Views
- (void) viewDidLoad {
    [super viewDidLoad];
    [self initTextView];
    [self addObservers];
}
  
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.imageScrollView.contentSize = self.imageView.frame.size;
    
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

# pragma mark - Resizing Text View Methods
- (void) initTextView {
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(X_COMMENT_OFFSET, Y_COMMENT_OFFSET, COMMENT_WIDTH, COMMENT_MIN_HEIGHT)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 4;
    self.textView.returnKeyType = UIReturnKeyGo;
    self.textView.font = [UIFont systemFontOfSize:TEXT_SIZE];
    self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.placeholder = PLACEHOLDER_TEXT;
    [self.postCommentContainer addSubview:self.textView];

    self.textView.internalTextView.layer.borderWidth = 1.0f;
    self.textView.internalTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.internalTextView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.textView.internalTextView.clipsToBounds = YES;
    self.textView.internalTextView.layer.cornerRadius = 10.0f;
}



- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.postCommentContainer.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.postCommentContainer.frame = r;

}

#pragma mark - Keyboard Hiding and Showing
- (void) keyboardWillShow:(NSNotification *) aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize KbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.keyboardHeight.constant = KbSize.height;
    [self.view setNeedsUpdateConstraints];
    
    float animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void) keyboardWillBeHidden:(NSNotification *) aNotification {
    self.keyboardHeight.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    float animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Image Scroll View Methods
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


#pragma mark - Post Comment Methods
- (IBAction)tapPostComment:(id)sender {
}

@end
