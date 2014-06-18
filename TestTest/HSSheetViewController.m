//
//  HSSheetViewController.m
//  improvisio-v4.2
//
//  Created by lux on 6/11/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSSheetViewController.h"
#import "HSConversationViewController.h"
#import "HSConversation.h"
#import "HSCommentCell.h"
#import "HSComment.h"

#import "DateTools.h"
#import "UIImage+ImageEffects.h"
#import "UIView+GradientMask.h"

#import <Parse/Parse.h>

@interface HSSheetViewController () {

    CGPoint closedCenter;
    CGPoint halfCenter;
    CGPoint fullCenter;
    CommentState commentState;
}

@end

#define xCenter 160.0f
#define animate 1
#define animationDuration 0.2f
const CGFloat imgMinHeight = 25.0f;
const CGFloat addCommentHeight = 50.0f;
const CGFloat commentsHandleHeight = 25.0f;
const CGFloat commentsContainerHalfHeight = 202.0f;


/* Current issues: the half-way view of the comments still has the last one cutoff
 */


//mainscrollview delegate and imageScrollVIEW
@implementation HSSheetViewController {
    UIImage *img;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    if ([self getConversationViewController].conversation.image != nil) {
        PFFile* imageFile = [self getConversationViewController].conversation.image;
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        img = [UIImage imageWithData:imageData];
    }
    self.imageView.image = img;
    self.imageScrollView.contentSize = self.imageView.frame.size;
    
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.fadeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.blurImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mainView.layer.borderWidth = 5.0f;
    self.mainView.layer.borderColor = [UIColor redColor].CGColor;
//    self.commentsViewContainer.layer.borderWidth = 5.0f;
//    self.commentsViewContainer.layer.borderColor = [UIColor redColor].CGColor;
//    self.commentsTableView.layer.borderWidth = 5.0f;
//    self.commentsTableView.layer.borderColor = [UIColor redColor].CGColor;
}


#pragma mark - Comments Scrolling and Resizing

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
//    NSLog(@"scrolling");
//    
//    CGFloat delta = fabs(self.commentsTableView.contentOffset.y);
//    // PULLING DOWN + FIX STYLE
//    if (scrollView.contentOffset.y < 0.0f) {
//        NSLog(@"scrollView.contentOffset.y < 0.0f");
//        float imgHeight = MIN(self.imageScrollView.frame.size.height + delta, self.view.frame.size.height - commentsHandleHeight);
//        float commentsHeight = MAX(self.commentsViewContainer.frame.size.height - delta, commentsHandleHeight);
//        self.imageScrollView.frame = CGRectMake(0, 0, self.commentsTableView.frame.size.width, imgHeight);
//        self.commentsViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(self.imageScrollView.frame) + CGRectGetHeight(self.imageScrollView.frame)}, .size = {self.commentsViewContainer.frame.size.width, commentsHeight}};
//        [self.commentsTableView setContentOffset:(CGPoint){0,0} animated:NO];
//        [self.imageScrollView setContentOffset:(CGPoint){0,0}animated:NO];
//    } else {
//        NSLog(@"} else {");
//        CGFloat backgroundScrollViewLimit = self.imageScrollView.frame.size.height - commentsHandleHeight;
//        if (delta <= backgroundScrollViewLimit) {
//            NSLog(@"(delta <= backgroundScrollViewLimit)");
//            float imgHeight = MAX(self.imageScrollView.frame.size.height - delta, imgMinHeight);
//            float commentsHeight = MIN(self.commentsViewContainer.frame.size.height + delta, self.view.frame.size.height - imgMinHeight);
//            self.imageScrollView.frame = CGRectMake(0, 0, self.commentsTableView.frame.size.width, imgHeight);
//            
//            self.commentsViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(self.imageScrollView.frame) + CGRectGetHeight(self.imageScrollView.frame)}, .size = {self.commentsViewContainer.frame.size.width, commentsHeight}};
//            [self.commentsTableView setContentOffset:(CGPoint){0,0} animated:NO];
//            [self.imageScrollView setContentOffset:(CGPoint){0,0}animated:NO];
//        }
//    }
}

#pragma mark - Handle Drag

- (IBAction)dragCommentsHandle:(UIPanGestureRecognizer *)sender {
//    if ([sender state] == UIGestureRecognizerStateBegan) {
//        
//        startPos = self.center;
//        
//        // Determines if the view can be pulled in the x or y axis
//        verticalAxis = closedCenter.x == openedCenter.x;
//        
//        // Finds the minimum and maximum points in the axis
//        if (verticalAxis) {
//            minPos = closedCenter.y < openedCenter.y ? closedCenter : openedCenter;
//            maxPos = closedCenter.y > openedCenter.y ? closedCenter : openedCenter;
//        } else {
//            minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter;
//            maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter;
//        }
//        
//    } else if ([sender state] == UIGestureRecognizerStateChanged) {
//        
//        CGPoint translate = [sender translationInView:self.superview];
//        
//        CGPoint newPos;
//        
//        // Moves the view, keeping it constrained between openedCenter and closedCenter
//        if (verticalAxis) {
//            
//            newPos = CGPointMake(startPos.x, startPos.y + translate.y);
//            
//            if (newPos.y < minPos.y) {
//                newPos.y = minPos.y;
//                translate = CGPointMake(0, newPos.y - startPos.y);
//            }
//            
//            if (newPos.y > maxPos.y) {
//                newPos.y = maxPos.y;
//                translate = CGPointMake(0, newPos.y - startPos.y);
//            }
//        } else {
//            
//            newPos = CGPointMake(startPos.x + translate.x, startPos.y);
//            
//            if (newPos.x < minPos.x) {
//                newPos.x = minPos.x;
//                translate = CGPointMake(newPos.x - startPos.x, 0);
//            }
//            
//            if (newPos.x > maxPos.x) {
//                newPos.x = maxPos.x;
//                translate = CGPointMake(newPos.x - startPos.x, 0);
//            }
//        }
//        
//        [sender setTranslation:translate inView:self.superview];
//        
//        self.center = newPos;
//        
//    } else if ([sender state] == UIGestureRecognizerStateEnded) {
//        
//        // Gets the velocity of the gesture in the axis, so it can be
//        // determined to which endpoint the state should be set.
//        
//        CGPoint vectorVelocity = [sender velocityInView:self.superview];
//        CGFloat axisVelocity = verticalAxis ? vectorVelocity.y : vectorVelocity.x;
//        
//        CGPoint target = axisVelocity < 0 ? minPos : maxPos;
//        BOOL op = CGPointEqualToPoint(target, openedCenter);
//        
//        [self setOpened:op animated:animate];
//    }
}

#pragma mark - Handle Tap

- (IBAction) tapCommentsHandle:(UITapGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        CommentState next = (commentState + 1) % 4;
        [self setOpenedState:next animated:animate];
    }
}

- (void) setOpenedState:(CommentState)curr animated:(BOOL)anim {
    commentState = curr;
    
    if (anim) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }

    [self adjustHeightofCommentsContainer];
    [self adjustHeightOfTableview];
    // WHEN COMBINING shrink the image Scroll as well here


    if (anim) {
        
        // For the duration of the animation, no further interaction with the view is permitted
        self.dragRecognizer.enabled = NO;
        self.tapRecognizer.enabled = NO;
        
        [UIView commitAnimations];
        
    } else {
        NSLog(@"Changing");
    }
}

- (void) adjustHeightofCommentsContainer {
    if ([self isKeyboardShown]) {
        [self adjustHeightofCommentsContainerKeyboardShown];
    } else {
        [self adjustHeightofCommentsContainerKeyboardHidden];
    }
    
}

- (void) adjustHeightofCommentsContainerKeyboardHidden {
    switch (commentState) {
        case CLOSED:
            self.commentsViewContainer.frame = (CGRect){.origin = {0, self.mainView.frame.size.height - commentsHandleHeight}, .size = {self.mainView.frame.size.width, commentsHandleHeight}};
            break;
        case FULL:
            self.commentsViewContainer.frame = (CGRect){.origin = {0, imgMinHeight}, .size = {self.mainView.frame.size.width, self.mainView.frame.size.height - imgMinHeight}};
            break;
        default:
            self.commentsViewContainer.frame = (CGRect){.origin = {0, self.mainView.frame.size.height - commentsContainerHalfHeight}, .size = {self.mainView.frame.size.width, commentsContainerHalfHeight}};
            break;
    }
    
}

- (void) adjustHeightofCommentsContainerKeyboardShown {
    switch (commentState) {
        case CLOSED:
            self.commentsViewContainer.frame = (CGRect){.origin = {0, self.mainView.frame.size.height - commentsHandleHeight}, .size = {self.mainView.frame.size.width, commentsHandleHeight}};
            break;
        case FULL:
            self.commentsViewContainer.frame = (CGRect){.origin = {0, self.mainView.frame.size.height - commentsHandleHeight}, .size = {self.mainView.frame.size.width, commentsHandleHeight}};
            break;
        default:
            self.commentsViewContainer.frame = (CGRect){.origin = {0, imgMinHeight}, .size = {self.mainView.frame.size.width, self.mainView.frame.size.height - imgMinHeight}};
            break;
    }
    
}

- (void) adjustHeightOfTableview {
    self.commentsTableView.frame = (CGRect){.origin = {0, commentsHandleHeight}, .size = {self.commentsViewContainer.frame.size.width, self.commentsViewContainer.frame.size.height}};
    self.commentsTableViewHeightConstraint.constant = MIN(self.commentsTableView.contentSize.height, self.commentsViewContainer.frame.size.height - addCommentHeight / 2);;
    [self.commentsTableView updateConstraints];
    
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        self.dragRecognizer.enabled = YES;
        self.tapRecognizer.enabled = YES;
        NSLog(@"Finished");
    }
}

#pragma mark - Table View Data Load

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getComments] == nil ? 0 : [self getComments].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    HSComment *comment = [self getComments][indexPath.row];
    
    
    cell.content.text = comment.content;
    cell.timestamp.text = comment.updatedAt.timeAgoSinceNow;
    cell.creator.text = comment.creator.username;
    return cell;
}

#pragma mark - Conversation Parent Data Load

- (HSConversationViewController*) getConversationViewController {
    return (HSConversationViewController*)self.parentViewController;
}

- (NSArray*) getComments {
//    NSLog(@" conversation controller %@", [self getConversationViewController]);
//
//    NSLog(@" conversation %@", [self getConversationViewController].conversation);
//    NSLog(@" comments %@", [self getConversationViewController].conversation.comments);
    return [self getConversationViewController].conversation.comments;
}

- (void)commentAdded {
    // FIX ME
}

#pragma mark - Keyboard Showing / Hiding

- (BOOL) isKeyboardShown {
    return [self getConversationViewController].keyboardHeight.constant != 0;
}

- (void) keyboardWillShow {
    commentState = commentState == FULL ? HALFDOWN : commentState;
    [self adjustHeightofCommentsContainerKeyboardShown];
    [self adjustHeightOfTableview];
}

- (void) keyboardWillBeHidden {
    commentState == (commentState == FULL || commentState == CLOSED)? CLOSED : HALFUP;
    [self adjustHeightofCommentsContainerKeyboardHidden];
    [self adjustHeightOfTableview];
}

@end
