//
//  ViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "ViewController.h"
#import "PPBoxView.h"

/* Post Comment Constants */
//#define X_COMMENT_OFFSET 7.0f
//#define Y_COMMENT_OFFSET 7.0f
//#define COMMENT_WIDTH 236.0f
//#define COMMENT_MIN_HEIGHT 36.0f
//#define COMMENT_MAX_HEIGHT 77.5f
//#define TEXT_SIZE 15.0f
//#define PLACEHOLDER_TEXT @"Give Feedback here..."

#define COMMENT_CONTAINTER_WIDTH 480.0f
#define COMMENT_CONTAINTER_HEIGHT 45.0f
#define POST_BUTTON_WIDTH 40.0f
#define SIDE_MARGIN 10.0f

#define COMMENT_INIT_HEIGHT 37.0f
#define COMMENT_WIDTH 250.0f
#define X_COMMENT_OFFSET SIDE_MARGIN
#define Y_COMMENT_OFFSET 3.0f
#define TEXT_SIZE 18.0f
#define PLACEHOLDER_TEXT @"Give Feedback here..."

@interface ViewController () {
    PPBoxView* selectedBox;
    NSMutableArray* comments;
}
            

@end

@implementation ViewController

#pragma mark - Initialization of Views
- (void) viewDidLoad {
    [super viewDidLoad];
    [self initTextView];
    [self addObservers];
    [self addGestureRecognizers];
    comments = [NSMutableArray new];
}
  
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.imageScrollView.contentSize = self.imageView.frame.size;
    self.postButton.enabled = NO;
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) addGestureRecognizers {
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageHandler:)];
    [self.imageView addGestureRecognizer:tapRecognizer];
}

# pragma mark - Resizing Text View Methods
- (void) initTextView {
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(X_COMMENT_OFFSET, Y_COMMENT_OFFSET, COMMENT_WIDTH, 0.0f)];
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

    self.textView.internalTextView.layer.borderWidth = .6f;
    self.textView.internalTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.internalTextView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.textView.internalTextView.clipsToBounds = YES;
    self.textView.internalTextView.layer.cornerRadius = 10.0f;
}

- (void) growingTextView:(HPGrowingTextView *) growingTextView willChangeHeight:(float) height {
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.postCommentContainer.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.postCommentContainer.frame = r;

}

- (void) growingTextViewDidChange:(HPGrowingTextView *) growingTextView {
    if ([growingTextView.text isEqualToString:@""]) {
        self.postButton.enabled = NO;
    } else {
        self.postButton.enabled = YES;
    }
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

/* Dismiss Keyboard */
- (IBAction)dragPostCommentContainer:(id)sender {
    CGPoint vectorVelocity = [sender velocityInView:self.mainView];
    if (vectorVelocity.y > 0) {
        [self.view endEditing:YES];
    }
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


#pragma mark - Post Comment Methods
- (IBAction)tapPostComment:(id)sender {
    [comments addObject:self.textView.text];
    NSLog(@"comments %@", comments);
    [self didPostComment];
}

- (void) didPostComment {
    self.textView.text = @"";
    [self.view endEditing:YES];
}

@end
