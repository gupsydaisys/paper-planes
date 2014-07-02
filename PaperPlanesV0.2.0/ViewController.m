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
#import "NSString+FontAwesome.h"
#import "PPBoxViewController.h"

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
#define TABLE_HANDLE_WIDTH 480.0f
#define TABLE_CONTAINER_HALF_HEIGHT 202.0f
#define TABLE_ROW_HEIGHT 146.0f

/* Other Constants */
#define HEADING_HEIGHT 25.0f
#define ANIMATE 1
#define ANIMATION_DURATION 0.2f

@interface ViewController () {
    PPBoxViewController* selectedBox;

    CommentState tableHandleState;
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    
    BOOL isKeyboardUp;

    BOOL scrollViewDidLayoutOnce;
}

@end

@implementation ViewController

#pragma mark - Initialization of Views
- (void) viewDidLoad {
    [super viewDidLoad];
    [self initTextView];
    [self initCommentDrawer];
    [self addObservers];
    [self addGestureRecognizers];
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
- (void) initCommentDrawer {
    tableHandleState = CLOSED;
    isKeyboardUp = NO;
    [self showComments:NO state:-1];
    
    
    // NEXT TIME do calculations instead of magic numbers

    UILabel *barRight = [[UILabel alloc] initWithFrame:(CGRect){0, 0, 20.0f, 20.0f}];
    barRight.center = CGPointMake(TABLE_HANDLE_WIDTH / 2 - 70.0f, TABLE_HANDLE_HEIGHT / 2);
    barRight.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18.0f];
    barRight.text = [NSString fontAwesomeIconStringForEnum:FABars];
    barRight.textColor = [UIColor whiteColor];
    [self.tableHandle addSubview:barRight];
    
    UILabel *barLeft = [[UILabel alloc] initWithFrame:(CGRect){0, 0, 20.0f, 20.0f}];
    barLeft.center = CGPointMake(TABLE_HANDLE_WIDTH / 2 - 84.0f, TABLE_HANDLE_HEIGHT / 2);
    barLeft.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18.0f];
    barLeft.text = [NSString fontAwesomeIconStringForEnum:FABars];
    barLeft.textColor = [UIColor whiteColor];
    [self.tableHandle addSubview:barLeft];

}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction) dragTableHandle:(UIPanGestureRecognizer *) sender {
    if ([sender state] == UIGestureRecognizerStateBegan) {
        startPos = self.tableContainer.frame.origin;

    } else if ([sender state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translate = [sender translationInView:self.mainView];
        CGPoint newPos = CGPointMake(startPos.x, startPos.y + translate.y);

        
        float maxHeight = self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - HEADING_HEIGHT;
        float minHeight = TABLE_HANDLE_HEIGHT;

        float newHeight = self.postCommentContainer.frame.origin.y - newPos.y;

        if (newHeight > maxHeight) {
            newHeight = maxHeight;
        }
        
        if (newHeight < minHeight) {
            newHeight = minHeight;
        }

        self.tableContainerHeight.constant = newHeight;
        [self.view setNeedsUpdateConstraints];

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

    if (anim) {
        self.dragTableHandleRecognizer.enabled = NO;
        [UIView commitAnimations];
    }
}

- (void) animationForTableHandleDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
    if (finished) {
        self.dragTableHandleRecognizer.enabled = YES;
    }
}

- (CommentState) getNextTableHandleState:(CGPoint) vectorVelocity {
    // NEXT STEP call to procure correct values / calculated ones

    float halfY = 320.0f;
    float delta = 100.0f;
    BOOL isSlow = fabsf(vectorVelocity.y) < 1050.0f;
    float yTranslation = self.tableContainer.center.y;

    if (vectorVelocity.y > 0) {
        if (FULL == tableHandleState && yTranslation <= halfY + delta && yTranslation >= halfY - delta && !isKeyboardUp && isSlow) return HALF;
        else return CLOSED;
    } else {
        if (CLOSED == tableHandleState && yTranslation <= halfY + delta && yTranslation >= halfY - delta && !isKeyboardUp && isSlow) return HALF;
        else return FULL;
    }
}

#pragma mark - Table Resize/Update Methods
- (void) updateTableContainerFrame:(CommentState) curr {
    float cumulativeCommentHeight = (float) selectedBox.comments.count * TABLE_ROW_HEIGHT + TABLE_HANDLE_HEIGHT;
    float fullHeight = self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - HEADING_HEIGHT;
    
    switch (curr) {
        case CLOSED:
            [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                       :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - TABLE_HANDLE_HEIGHT
                                       :self.tableContainer.frame.size.width
                                       :TABLE_HANDLE_HEIGHT];
            break;

        case ONE:
            [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                           :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - TABLE_HANDLE_HEIGHT - TABLE_ROW_HEIGHT
                                           :self.tableContainer.frame.size.width
                                           :TABLE_HANDLE_HEIGHT + TABLE_ROW_HEIGHT];
            break;

        case FULL:
            if (cumulativeCommentHeight < fullHeight) {
                [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                               :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - cumulativeCommentHeight
                                               :self.tableContainer.frame.size.width
                                               :cumulativeCommentHeight];
            } else {
                [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                               :HEADING_HEIGHT
                                               :self.tableContainer.frame.size.width
                                               :fullHeight];
            }
        break;

        /* HALF */
        default:
            if (cumulativeCommentHeight < TABLE_CONTAINER_HALF_HEIGHT) {
                [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                               :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - cumulativeCommentHeight
                                               :self.tableContainer.frame.size.width
                                               :cumulativeCommentHeight];
            } else {
                [self updateTableContainerFrame:self.tableContainer.frame.origin.x
                                               :self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - TABLE_CONTAINER_HALF_HEIGHT
                                               :self.tableContainer.frame.size.width
                                               :TABLE_CONTAINER_HALF_HEIGHT];
            }
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
    if (self.tableContainer.frame.size.height > TABLE_CONTAINER_HALF_HEIGHT) {
        tableHandleState = FULL;
    } else if (self.tableContainer.frame.size.height == TABLE_HANDLE_HEIGHT) {
        tableHandleState = CLOSED;
    } else if (self.tableContainer.frame.size.height == TABLE_HANDLE_HEIGHT + TABLE_ROW_HEIGHT) {
        tableHandleState = ONE;
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
        
        if (tableHandleState == FULL) {
            float maxHeight = self.mainView.frame.size.height - self.postCommentHeight.constant - self.keyboardHeight.constant - HEADING_HEIGHT;
            self.tableContainerHeight.constant = maxHeight;
            [self.view setNeedsUpdateConstraints];
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (selectedBox) {
            [self.imageScrollView zoomToRect:selectedBox.view.frame animated:YES];
        }
        if (finished) {
            if (tableHandleState == HALF || tableHandleState == ONE) {
                [self updateTableContainerFrame:FULL];
            }
        }
    }];
    isKeyboardUp = YES;
}


- (void) keyboardWillBeHidden:(NSNotification *) aNotification {
    [self updateKeyboardHeight:0];

    //if half and full -> half
    //if one -> one
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
    return selectedBox.comments.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    HSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    NSString *comment = selectedBox.comments[indexPath.row];

    cell.content.text = comment;
    
    // NEXT TIME change this so that when you access cell it goes into the cell

    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NEXT TIME change this to grow with content
        return self.tableView.rowHeight;
}

#pragma mark - Gesture recognizer delegate

- (void) tapImageHandler: (UITapGestureRecognizer *) gesture {
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    
    PPBoxViewController* box = [[PPBoxViewController alloc] init];
    [self addChildViewController:box];
    
    box.view = [PPBoxView centeredAtPoint:touchPoint];
    [self.imageScrollView.panGestureRecognizer requireGestureRecognizerToFail:box.view.moveButtonPanGestureRecognizer];
    [self.imageScrollView.panGestureRecognizer requireGestureRecognizerToFail:box.view.resizeButtonPanGestureRecognizer];
    box.delegate = self;
    [box makeSelection:true];
    [gesture.view addSubview:box.view];
    
    [box didMoveToParentViewController:self];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *) gestureRecognizer shouldReceiveTouch:(UITouch *) touch {
    if (touch.view == self.imageView) {
        return YES;
    }
    return NO;
}

- (void) showComments:(BOOL) shouldShow state:(CommentState) curr {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        if (shouldShow) {
            self.textView.text = @"";
            self.postCommentContainer.hidden = NO;
            
            if (selectedBox.comments.count != 0) {
                self.tableContainer.hidden = NO;
                [self setOpenedState:curr animated:NO];
            } else {
                self.tableContainer.hidden = YES;
            }
            
        } else {
            self.tableContainer.hidden = YES;
            self.postCommentContainer.hidden = YES;
        }
    }];
}

#pragma mark - Scroll view delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView {
    return self.imageView;
}


#pragma mark - Post Comment Methods
- (IBAction) tapPostComment:(id) sender {
    [selectedBox.comments addObject:self.textView.text];
    [self didPostComment];
}

- (void) didPostComment {
    [self.tableView reloadData];
    [self showComments:TRUE state:ONE];
    [self.view endEditing:YES];
    NSIndexPath *index = [NSIndexPath indexPathForItem:(selectedBox.comments.count - 1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void) boxWasDeleted:(PPBoxViewController *)box {
    if (selectedBox == box) {
        [self boxSelectionChanged:box toState:NO];
    }
}

- (void) boxSelectionChanged:(PPBoxViewController *)box toState:(BOOL)selectionState {
    if (selectionState) {
        [selectedBox makeSelection:false];
        selectedBox = box;
        [self.tableView reloadData];
        if (tableHandleState) {
            [self showComments:YES state:tableHandleState];
        } else {
            [self showComments:YES state:CLOSED];
        }
    } else if (selectionState == false && selectedBox == box) {
        selectedBox = nil;
        [self showComments:NO state:-1];
        if (isKeyboardUp) {
            [self.view endEditing:YES];
        }
    }
}

@end
