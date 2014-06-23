//
//  HSAddCommentViewController.m
//  improvisio-v4.2
//
//  Created by lux on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSAddCommentViewController.h"
#import "HSConversationViewController.h"
#import "HSComment.h"

#import "HSUtilities.h"
#import "NSString+FontAwesome.h"

#define TEXT_SIZE 15.0f
#define COMMENT_WIDTH 236.0f
#define COMMENT_MIN_HEIGHT 36.0f
#define COMMENT_MAX_HEIGHT 77.5f
#define X_COMMENT_OFFSET 39.0f
#define Y_COMMENT_OFFSET 7.0f

#define COMMENT_CONTAINER_HEIGHT 50.0f

#define animationDuration .1f


#define BOX_WIDTH 21.7f
#define BOX_HEIGHT 18.0f
#define ICON_SIZE 15.0f
#define X_ICON_OFFSET 8.0f
#define Y_ICON_OFFSET 17.0f
#define DOTBOX_FRAME CGRectMake(X_ICON_OFFSET, Y_ICON_OFFSET, BOX_WIDTH, BOX_HEIGHT)
#define PLACEHOLDER_TEXT @"Give Feedback here..."

@interface HSAddCommentViewController () {
    HSComment* comment;
    UIView* attachment;
}

@end

@implementation HSAddCommentViewController

- (void) viewDidLoad {
     [super viewDidLoad];

    comment = [HSComment object];

    [self initTextView];
    [self initAttachmentIcon];
    [self attachmentIconUnselected];

    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

}

# pragma mark - Resizing Text View Methods

- (void) initTextView {
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(X_COMMENT_OFFSET, Y_COMMENT_OFFSET, COMMENT_WIDTH, COMMENT_MIN_HEIGHT)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	self.textView.minNumberOfLines = 1;
//    self.textView.maxHeight = 71.0f;
	self.textView.maxNumberOfLines = 4;
	self.textView.returnKeyType = UIReturnKeyGo; //just as an example ???
	self.textView.font = [UIFont systemFontOfSize:TEXT_SIZE];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.placeholder = PLACEHOLDER_TEXT;
    [self.containerView addSubview:self.textView];
    
    
    self.textView.internalTextView.layer.borderWidth = 1.0f;
    self.textView.internalTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.internalTextView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.textView.internalTextView.clipsToBounds = YES;
    self.textView.internalTextView.layer.cornerRadius = 10.0f;
    
    // textView.animateHeightChange = NO; //turns off animation
}



- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    NSLog(@"height %F", growingTextView.frame.size.height);
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.containerView.frame = r;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
//- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
//    float containerHeight = growingTextView.internalTextView.frame.size.height + COMMENT_CONTAINER_HEIGHT - COMMENT_MIN_HEIGHT;
//    [self getConversationViewController].addCommentHeight.constant = containerHeight;
//    [[self getConversationViewController].addCommentView setNeedsUpdateConstraints];
//}



# pragma mark - Attachment Icon Methods

- (void) initAttachmentIcon {
    attachment = [[UIView alloc] initWithFrame: DOTBOX_FRAME];
    [self.containerView addSubview:attachment];
    
    UILabel *sideLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DOTBOX_FRAME.size.width, DOTBOX_FRAME.size.height)];
    sideLeft.font = [UIFont fontWithName:kFontAwesomeFamilyName size:ICON_SIZE];
    sideLeft.text = [NSString fontAwesomeIconStringForEnum:FAEllipsisV];
    [attachment addSubview:sideLeft];
    
    UILabel *sideTopLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, -9, DOTBOX_FRAME.size.width, DOTBOX_FRAME.size.height)];
    sideTopLeft.font = [UIFont fontWithName:kFontAwesomeFamilyName size:ICON_SIZE];
    sideTopLeft.text = [NSString fontAwesomeIconStringForEnum:FAEllipsisH];
    [attachment addSubview:sideTopLeft];
    
    UILabel *sideTopRight = [[UILabel alloc] initWithFrame:CGRectMake(13, -9, DOTBOX_FRAME.size.width, DOTBOX_FRAME.size.height)];
    sideTopRight.font = [UIFont fontWithName:kFontAwesomeFamilyName size:ICON_SIZE];
    sideTopRight.text = [NSString fontAwesomeIconStringForEnum:FAEllipsisH];
    [attachment addSubview:sideTopRight];
    
    UILabel *sideRight = [[UILabel alloc] initWithFrame:CGRectMake(BOX_WIDTH, 0, DOTBOX_FRAME.size.width, DOTBOX_FRAME.size.height)];
    sideRight.font = [UIFont fontWithName:kFontAwesomeFamilyName size:ICON_SIZE];
    sideRight.text = [NSString fontAwesomeIconStringForEnum:FAEllipsisV];
    [attachment addSubview:sideRight];
    
    UILabel *sideBottomRight = [[UILabel alloc] initWithFrame:CGRectMake(13, 9, DOTBOX_FRAME.size.width, DOTBOX_FRAME.size.height)];
    sideBottomRight.font = [UIFont fontWithName:kFontAwesomeFamilyName size:ICON_SIZE];
    sideBottomRight.text = [NSString fontAwesomeIconStringForEnum:FAEllipsisH];
    [attachment addSubview:sideBottomRight];
    
    UILabel *sideBottomLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, DOTBOX_FRAME.size.width, DOTBOX_FRAME.size.height)];
    sideBottomLeft.font = [UIFont fontWithName:kFontAwesomeFamilyName size:ICON_SIZE];
    sideBottomLeft.text = [NSString fontAwesomeIconStringForEnum:FAEllipsisH];
    [attachment addSubview:sideBottomLeft];
    
    UILabel *circle = [[UILabel alloc] initWithFrame:CGRectMake(BOX_WIDTH - 5, BOX_HEIGHT - 10, DOTBOX_FRAME.size.width, DOTBOX_FRAME.size.height)];
    circle.font = [UIFont fontWithName:kFontAwesomeFamilyName size:ICON_SIZE];
    circle.text = [NSString fontAwesomeIconStringForEnum:FACircle];
    [attachment addSubview:circle];
}

- (void) attachmentIconSelected {
    for(UIView *view in [attachment subviews]) {
        UILabel *label = (UILabel*) view;
        label.textColor = self.view.tintColor;
    }

}

- (void) attachmentIconUnselected {
    for(UIView *view in [attachment subviews]) {
        UILabel *label = (UILabel*) view;
        label.textColor = [UIColor grayColor];
    }
}

# pragma mark - Interactions with Conversation
- (HSConversationViewController*) getConversationViewController {
    return (HSConversationViewController*)self.parentViewController;
}

- (IBAction)postComment:(id)sender {
    [[self getConversationViewController] addComment:self.textView.internalTextView.text];
}

- (void) commentAdded {
    self.textView.internalTextView.text = @"";
    [self.textView resignFirstResponder];
}

- (void) keyboardWillShow {
    
}

- (void) keyboardWillBeHidden {
    
}

@end
