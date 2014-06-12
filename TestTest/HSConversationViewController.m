//
//  HSConversationViewController.m
//  improvisio-v4.2
//
//  Created by lux on 6/10/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSConversationViewController.h"
#import "HSComment.h"
#import "HSUtilities.h"

@interface HSConversationViewController ()

@end

@implementation HSConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObservers];;
    NSLog(@"%@ img", self.conversation.image);
    if (self.conversation.image == nil) {
        self.flipButton.enabled = false;
    }
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) switchViews {
    [self.threadView setHidden:!self.threadView.hidden];
    [self.sheetView setHidden:!self.sheetView.hidden];
}

- (IBAction)tapFlip:(id)sender :(NSString*)viewControllerID {
    // We want the back button to return to the FeedViewController, so we remove ourselves from the stack after pushing the next controller
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:viewControllerID] animated:YES];
    
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [viewControllers removeObject:self];
    [self.navigationController setViewControllers:[NSArray arrayWithArray:viewControllers]];
    
}

- (IBAction)tapFlip:(id)sender {
    [self switchViews];
}

- (void) addComment:(NSString*) commentText {
    HSComment *comment = [HSComment object];
    comment.content = commentText;
    comment.creator = [PFUser currentUser];
    
    [self.conversation addObject:comment forKey:@"comments"];
    [self.conversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.childViewControllers makeObjectsPerformSelector:@selector(commentAdded)];
        } else {
            [HSUtilities showError:error];
        }
    }];
}

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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"ConversationEmbedThreadSegue"]) {
//        UITableViewController* threadViewController = (UITableViewController*)segue.destinationViewController;
//    }
//}

@end
