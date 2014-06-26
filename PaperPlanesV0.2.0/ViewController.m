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
#define COMMENT_CONTAINTER_WIDTH 480.0f
#define COMMENT_CONTAINTER_HEIGHT 45.0f
#define POST_BUTTON_WIDTH 40.0f
#define SIDE_MARGIN 10.0f

/* Post Comment Text View Constants */
#define COMMENT_INIT_HEIGHT 37.0f
#define COMMENT_WIDTH 250.0f
#define X_COMMENT_OFFSET SIDE_MARGIN
#define Y_COMMENT_OFFSET 3.0f
#define TEXT_SIZE 18.0f
#define PLACEHOLDER_TEXT @"Give Feedback here..."

@interface ViewController () {
    PPBoxView* selectedBox;

    NSMutableArray* comments;
    CommentState tableHandleState;
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
}


@end

@implementation ViewController

#pragma mark - Initialization of Views
- (void) viewDidLoad {
    [super viewDidLoad];
    [self initTextView];
    [self addObservers];
    [self addGestureRecognizers];
    
    /* Comment Drawer initalization Stuff */
    comments = [NSMutableArray new];
    tableHandleState = CLOSED;
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
    tapRecognizer.delegate = self;
    [self.imageView addGestureRecognizer:tapRecognizer];
}

# pragma mark - Resizing Text View Methods
- (void) initTextView {
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(X_COMMENT_OFFSET, Y_COMMENT_OFFSET, COMMENT_WIDTH, 0.0f)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 4;
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
    
    self.postCommentHeight.constant = r.size.height;
    [self.view setNeedsUpdateConstraints];

    
    r = self.tableContainer.frame;
    r.origin.y += diff;
    self.tableContainer.frame = r;
    self.tableContainerHeight.constant = r.size.height;
    [self.view setNeedsUpdateConstraints];
    
}

- (void) growingTextViewDidChange:(HPGrowingTextView *) growingTextView {
    if ([growingTextView.text isEqualToString:@""]) {
        self.postButton.enabled = NO;
    } else {
        self.postButton.enabled = YES;
    }
}

#pragma mark - Comments Table Handle Methods
- (IBAction) dragTableHandle:(UIPanGestureRecognizer *) sender {
//
//    // NEXT STEP call correct updateBLAHCenter to get what each should actually be
//    CGPoint closedCenter;
//    CGPoint halfCenter;
//    CGPoint fullCenter;
//    closedCenter = CGPointMake(160, 353.5);
//    fullCenter = CGPointMake(160, 183);
//    halfCenter = CGPointMake(160, 265);
//
//    if ([sender state] == UIGestureRecognizerStateBegan) {
//        
//        startPos = self.tableContainer.center;
//        
//        minPos = fullCenter;
//        maxPos = closedCenter;
//        
//    } else if ([sender state] == UIGestureRecognizerStateChanged) {
//        // Moves the view, keeping it constrained between closed and full
//        
//        CGPoint translate = [sender translationInView:self.mainView];
//        
//        CGPoint newPos = CGPointMake(startPos.x, startPos.y + translate.y);
//        
//        if (newPos.y < minPos.y) {
//            newPos.y = minPos.y;
//            translate = CGPointMake(0, newPos.y - startPos.y);
//        }
//        
//        if (newPos.y > maxPos.y) {
//            newPos.y = maxPos.y;
//            translate = CGPointMake(0, newPos.y - startPos.y);
//        }
//        
//        [sender setTranslation:translate inView:self.mainView];
//        
//        self.commentsViewContainer.center = newPos;
//    } else if ([sender state] == UIGestureRecognizerStateEnded) {
//        
//        // decides which state to keep
//        
//        CGPoint vectorVelocity = [sender velocityInView:self.mainView];
//        float yTranslation = self.commentsViewContainer.center.y;
//        CommentState curr;
//        
//        if (vectorVelocity.y > 0) {
//            if (yTranslation <= halfCenter.y) {
//                curr = HALFDOWN;
//            } else {
//                curr = CLOSED;
//            }
//        } else {
//            if (yTranslation >= halfCenter.y + delta) {
//                curr = HALFUP;
//            } else {
//                curr = FULL;
//            }
//        }
//
//        [self setOpenedState:curr animated:animate];
//
//    }
}
//
//- (void) setOpenedState:(CommentState)curr animated:(BOOL)anim {
//    commentState = curr;
//    
//    if (anim) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:animationDuration];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//    }
//    
//    [self adjustHeightofTableContainer];
////    [self adjustHeightOfTableview];
//    
//    if (anim) {
//        
//        // For the duration of the animation, no further interaction with the view is permitted
//        self.dragCommentsRecognizer.enabled = NO;
//        self.tapCommentsRecognizer.enabled = NO;
//        
//        [UIView commitAnimations];
//        
//    } else {
//        NSLog(@"Changing");
//    }
//}
//
//- (void) adjustHeightofTableContainer {
//    switch (commentState) {
//        case CLOSED:
//            self.commentsViewContainer.frame = (CGRect){.origin = {0, self.mainView.frame.size.height - commentsHandleHeight}, .size = {self.mainView.frame.size.width, commentsHandleHeight}};
//            //            NSLog(@"Center point in closed mode %@", NSStringFromCGPoint(self.commentsViewContainer.center));
//            break;
//        case FULL:
//            self.commentsViewContainer.frame = (CGRect){.origin = {0, 0}, .size = {self.mainView.frame.size.width, self.mainView.frame.size.height}};
//            //            NSLog(@"Center point in full mode %@", NSStringFromCGPoint(self.commentsViewContainer.center));
//            break;
//        /* HALF */
//        default:
//            self.commentsViewContainer.frame = (CGRect){.origin = {0, self.mainView.frame.size.height - commentsContainerHalfHeight}, .size = {self.mainView.frame.size.width, commentsContainerHalfHeight}};
//            //            NSLog(@"Center point in half mode %@", NSStringFromCGPoint(self.commentsViewContainer.center));
//            break;
//    }
//}

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
        touchedBox = [PPBoxView centeredAtPoint:touchPoint];
        [gesture.view addSubview:touchedBox];
    }

    [self selectBox:touchedBox];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[PPBoxView class]] || touch.view == self.imageView) {
        return YES;
    }
    return NO;
}

- (UIView*) getHitView: (UIGestureRecognizer *) gesture {
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    return [gesture.view hitTest:touchPoint withEvent:nil];
}

#pragma mark - Box methods

- (void) deselect: (PPBoxView*) box {
    [box marchingAnts:FALSE];
    [box showControls:FALSE];
    selectedBox = nil;
}

- (void) select: (PPBoxView*) box {
    [box marchingAnts:TRUE];
    [box showControls:TRUE];
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
