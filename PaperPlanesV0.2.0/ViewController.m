//
//  ViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 6/24/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "ViewController.h"
#import "HSCommentCell.h"
#import "PPBoxView.h"
#import "UIView+Util.h"
#import "UIScrollView+Util.h"

/* Post Comment Constants */
#define POST_COMMENT_CONTAINTER_WIDTH 480.0f
#define POST_COMMENT_CONTAINTER_HEIGHT 45.0f
#define POST_BUTTON_WIDTH 40.0f
#define SIDE_MARGIN 10.0f

/* Post Comment Text View Constants */
#define COMMENT_INIT_HEIGHT 37.0f
#define COMMENT_WIDTH 250.0f
#define X_COMMENT_OFFSET SIDE_MARGIN
#define Y_COMMENT_OFFSET 3.0f
#define TEXT_SIZE 18.0f
#define PLACEHOLDER_TEXT @"Give Feedback here..."

/* Table Comments Constants */
#define TABLE_HANDLE_HEIGHT 25.0f
#define TABLE_CONTAINER_HALF_HEIGHT 202.0f

/* Other Constants */
#define HEADING_HEIGHT 20.0f
#define ANIMATE 1
#define ANIMATION_DURATION 0.2f

@interface ViewController () {
    PPBoxView* selectedBox;

    NSMutableArray* comments;
    
    CommentState tableHandleState;
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    
    BOOL isKeyboardUp;

    UIView *heightTEMP;
    
    BOOL scrollViewDidLayoutOnce;
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
    isKeyboardUp = NO;
    [self showComments:NO];
    
    
    /* Temporarliy there for debugging */
    self.tableContainer.layer.borderWidth = 3;
    self.tableContainer.layer.borderColor = [[UIColor greenColor] CGColor];
    
    heightTEMP = [UIView new];
    [self.mainView addSubview:heightTEMP];
    heightTEMP.layer.backgroundColor = [UIColor redColor].CGColor;
//    self.postCommentContainer.layer.borderWidth = 3;
//    self.postCommentContainer.layer.borderColor = [[UIColor redColor] CGColor];
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
    
    if (diff > 0) {
        if (tableHandleState == CLOSED) {
            [self updateTableContainerFrame:CLOSED];
        } else { // FULL (can't be half in this stage)
            [self updateTableContainerFrame:FULL];
        }
    } else {
        [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                       :self.tableContainer.frame.origin.y + diff
                                       :self.tableContainer.frame.size.width
                                       :self.tableContainer.frame.size.height];
    }

}

- (void) growingTextViewDidChange:(HPGrowingTextView *) growingTextView {
    if ([growingTextView.text isEqualToString:@""]) {
        self.postButton.enabled = NO;
    } else {
        self.postButton.enabled = YES;
    }
}

#pragma mark - Comments Table Handle Methods

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction) dragTableHandle:(UIPanGestureRecognizer *) sender {
    // NEXT STEP call correct updateBLAHCenter to get what each should actually be
    CGPoint closedCenter = CGPointMake(160, 422.5);
    CGPoint halfCenter = CGPointMake(160, 334);
    CGPoint fullCenter = CGPointMake(160, 227.5);

    if ([sender state] == UIGestureRecognizerStateBegan) {
        startPos = self.tableContainer.center;
        [self setBoundsDragTableHandle];

    } else if ([sender state] == UIGestureRecognizerStateChanged) {
        
        // NEXT STEP height still doesn't quite work
        
        CGPoint translate = [sender translationInView:self.mainView];
        CGPoint newPos = CGPointMake(startPos.x, startPos.y + translate.y);
        
        if (newPos.y < minPos.y) {
            newPos.y = minPos.y;
            translate = CGPointMake(0, newPos.y - startPos.y);
        }
        
        if (newPos.y > maxPos.y) {
            newPos.y = maxPos.y;
            translate = CGPointMake(0, newPos.y - startPos.y);
        }
        
        [sender setTranslation:translate inView:self.mainView];
//        self.tableContainer.center = newPos;
        
        float maxHeight = self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - HEADING_HEIGHT;
        float minHeight = TABLE_HANDLE_HEIGHT;
        float newOriginY = newPos.y - self.tableContainer.frame.size.height / 2;
        float newHeight = self.postCommentContainer.frame.origin.y - newOriginY;
//        float newHeight = self.postCommentContainer.frame.origin.y - self.tableContainer.frame.origin.y;
        if (newHeight > maxHeight) {
            newHeight = maxHeight;
        }
        
        if (newHeight < minHeight) {
            newHeight = minHeight;
        }
//
        self.tableContainerHeight.constant = newHeight;
        [self.view setNeedsUpdateConstraints];
//        self.tableContainer.center = newPos;

//         center.y - height / 2
//        heightTEMP.frame = CGRectMake(0, newPos.y - self.tableContainer.frame.size.height / 2, 3.0f, 3.0f);
//        heightTEMP.frame = CGRectMake(self.tableContainer.frame.origin.x, self.tableContainer.frame.origin.y, 3.0f, newHeight);
        
        
//        self.tableContainer.frame = CGRectMake(self.tableContainer.frame.origin.x, newOriginY, self.tableContainer.frame.size.width, newHeight);
//        self.tableContainerHeight.constant = self.tableContainer.frame.size.height;
//        [self.view setNeedsUpdateConstraints];

    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        CGPoint vectorVelocity = [sender velocityInView:self.mainView];
        CommentState curr = [self getNextTableHandleState:vectorVelocity];
        [self setOpenedState:curr animated:ANIMATE];
    }
}


- (void) setOpenedState:(CommentState) curr animated:(BOOL) anim {
    if (anim) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIMATION_DURATION];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationForTableHandleDidStop:finished:context:)];
    }
    
    [self updateTableContainerFrame:curr];
//    [self adjustHeightOfTableview];
    
    if (anim) {
        self.dragTableHandleRecognizer.enabled = NO;
        [UIView commitAnimations];
        
    } else {
        NSLog(@"Changing");
    }
}

- (void) animationForTableHandleDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
    if (finished) {
        self.dragTableHandleRecognizer.enabled = YES;
    }
}

- (void) setBoundsDragTableHandle {
    // NEXT STEP call to procure correct values / calculated ones
    CGPoint closedCenter = CGPointMake(160, 422.5);
    CGPoint halfCenter = CGPointMake(160, 334);
    CGPoint fullCenter = CGPointMake(160, 227.5);
    
    if (isKeyboardUp) {
            minPos = CGPointMake(160, 119);
            maxPos = CGPointMake(160, 207);

    } else {
        if (tableHandleState == CLOSED) {
            minPos = CGPointMake(160, HEADING_HEIGHT + TABLE_HANDLE_HEIGHT / 2);
            maxPos = closedCenter;
        } else if (tableHandleState == HALF) {
            minPos = CGPointMake(160, halfCenter.y - TABLE_CONTAINER_HALF_HEIGHT - TABLE_HANDLE_HEIGHT / 2);
            maxPos = CGPointMake(160, halfCenter.y + TABLE_CONTAINER_HALF_HEIGHT - TABLE_HANDLE_HEIGHT / 2);
        } else { // FULL
            minPos = fullCenter;
            maxPos = CGPointMake(160, 620);;
        }
    }
}

- (CommentState) getNextTableHandleState:(CGPoint) vectorVelocity {
    // NEXT STEP change so that if you are half-way or something and change direction it still snaps in place
    
    CGPoint halfCenter = CGPointMake(160, 334);
    float yTranslation = self.tableContainer.center.y;

    if (vectorVelocity.y > 0) {
        if (yTranslation <= halfCenter.y && !isKeyboardUp) return HALF;
        else return CLOSED;
    } else {
        if (yTranslation >= halfCenter.y && !isKeyboardUp) return HALF;
        else return FULL;
    }

}

- (void) updateTableContainerFrame:(CommentState) curr {
    switch (curr) {
        case CLOSED:
        [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                       :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - TABLE_HANDLE_HEIGHT
                                       :self.tableContainer.frame.size.width
                                       :TABLE_HANDLE_HEIGHT];
        break;

        case FULL:
        [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                       :HEADING_HEIGHT
                                       :self.tableContainer.frame.size.width
                                       :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - HEADING_HEIGHT];
        break;

        /* HALF */
        default:
        [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                       :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - TABLE_CONTAINER_HALF_HEIGHT
                                       :self.tableContainer.frame.size.width
                                       :TABLE_CONTAINER_HALF_HEIGHT];
        break;
    }

}

- (void) updateTableContainerFrame:(float) x :(float) y :(float) w :(float) h {
    float maxHeight = self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - HEADING_HEIGHT;
    float minHeight = TABLE_HANDLE_HEIGHT;

    if (maxHeight < h) {
        [self updateTableContainerFrame:FULL];
    } else if (minHeight > h) {
        [self updateTableContainerFrame:CLOSED];
    } else {
        self.tableContainer.frame = (CGRect){.origin = {x, y}, .size = {w, h}};
    }

    self.tableContainerHeight.constant = self.tableContainer.frame.size.height;
    [self.view setNeedsUpdateConstraints];

    [self updateTableHandleState];
    
}

- (void) updateTableHandleState {
    if (self.tableContainer.frame.origin.y == HEADING_HEIGHT) {
        tableHandleState = FULL;
    } else if (self.tableContainer.frame.size.height == TABLE_HANDLE_HEIGHT) {
        tableHandleState = CLOSED;
    } else {
        tableHandleState = HALF;
    }
}

#pragma mark - Keyboard Hiding and Showing
- (void) keyboardWillShow:(NSNotification *) aNotification {

    NSDictionary* info = [aNotification userInfo];
    CGSize KbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self updateKeyboardHeight:KbSize.height];
    
    float animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (selectedBox) {
            [self.imageScrollView zoomToRect:selectedBox.frame animated:YES];
        }
    }];
    [UIView setAnimationDidStopSelector:@selector(animationForKeyboardShowDidStop:finished:context:)];
    isKeyboardUp = YES;

}

- (void) animationForKeyboardShowDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
    if (finished) {
        //if half & closed -> closed
        if (tableHandleState == HALF) {
            [self updateTableContainerFrame:CLOSED];
        }

        // so that FULL mode is corrected
        [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                       :self.tableContainer.frame.origin.y
                                       :self.tableContainer.frame.size.width
                                       :self.tableContainer.frame.size.height];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *) aNotification {
    [self updateKeyboardHeight:0];
    
    //call updateTableContainerFrame ??
    
    //if half and full -> half
    //if closed -> closed
    
    float animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    isKeyboardUp = NO;
}

/* Dismiss Keyboard */
- (IBAction)dragPostCommentContainer:(id) sender {
    CGPoint vectorVelocity = [sender velocityInView:self.mainView];
    if (vectorVelocity.y > 0) {
        [self.view endEditing:YES];
    }
}
        
- (void) updateKeyboardHeight:(float) newHeight {
    self.keyboardHeight.constant = newHeight;
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Table View Data Load

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return comments.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    HSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    NSString *comment = comments[indexPath.row];

    cell.content.text = comment;
    
    // NEXT TIME change this so that when you access cell it goes into the cell
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

#pragma mark - Gesture recognizer delegate

- (void) tapImageHandler: (UITapGestureRecognizer *) gesture {
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    PPBoxView* touchedBox = [self getTouchedBox:gesture];
    if (touchedBox == nil) {
        touchedBox = [PPBoxView centeredAtPoint:touchPoint];
        [self.imageScrollView.panGestureRecognizer requireGestureRecognizerToFail:touchedBox.moveButtonPanGestureRecognizer];
        [self.imageScrollView.panGestureRecognizer requireGestureRecognizerToFail:touchedBox.resizeButtonPanGestureRecognizer];
        [gesture.view addSubview:touchedBox];
    }

    [self selectBox:touchedBox];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *) gestureRecognizer shouldReceiveTouch:(UITouch *) touch {
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
    [self showComments:NO];
}

- (void) select: (PPBoxView*) box {
    [box marchingAnts:TRUE];
    [box showControls:TRUE];
    selectedBox = box;
    [self showComments:YES];
}

- (void) selectBox: (PPBoxView*) box {
    [self deselect:selectedBox];
    [self select:box];
}

- (PPBoxView*) getTouchedBox:(UIGestureRecognizer*) gesture {
    UIView *hitView = [self getHitView:gesture];
    if ([hitView isKindOfClass:[PPBoxView class]]) {
        return (PPBoxView*)hitView;
    }
    return nil;
}

- (void) showComments:(BOOL) shouldShow {
    if (shouldShow) {
        [self setOpenedState:CLOSED animated:ANIMATE];
        self.textView.text = @"";
        self.tableContainer.hidden = NO;
        self.postCommentContainer.hidden = NO;
    } else {
        self.tableContainer.hidden = YES;
        self.postCommentContainer.hidden = YES;
    }
}

#pragma mark - Scroll view delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


#pragma mark - Post Comment Methods
- (IBAction)tapPostComment:(id)sender {
    [comments addObject:self.textView.text];
    [self.tableView reloadData];
    
    [self didPostComment];
}

- (void) didPostComment {
    self.textView.text = @"";
    [self.view endEditing:YES];
}

@end
