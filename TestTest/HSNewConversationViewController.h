//
//  HSNewConversationViewController.h
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNewConversationViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;
@property (weak, nonatomic) IBOutlet UISwitch *quickQuestionSwitch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

- (IBAction)addConversation:(id)sender;
- (IBAction)addPhotos:(id)sender;

@end
