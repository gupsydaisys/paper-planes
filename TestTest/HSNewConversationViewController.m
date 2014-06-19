//
//  HSNewConversationViewController.m
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/9/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSFeedViewController.h"
#import "HSNewConversationViewController.h"
#import "HSConversationViewController.h"
#import "HSConversation.h"
#import "HSComment.h"
#import "HSUtilities.h"
#import <Parse/Parse.h>

@interface HSNewConversationViewController () {
    HSConversation *conversation;
    UIImagePickerController *imagePicker;
    UIImage* image;
    NSData *imageData;
}

@end

@implementation HSNewConversationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObservers];
    conversation = [HSConversation object];
    
    self.selectedImage.contentMode = UIViewContentModeScaleAspectFit;
    self.scrollView.contentSize = self.contentView.frame.size;
}

- (IBAction)addConversation:(id)sender {
    if ([self populateConversationProperties]) {
        NSArray *arr = [self.navigationController viewControllers];
        HSFeedViewController *feedController = (HSFeedViewController*)arr[arr.count - 2];
        [feedController.conversations insertObject:conversation atIndex:0];
        [feedController.tableView reloadData];
//        NSLog(@"all the conversations %@", feedController.conversations);
        [conversation saveInBackgroundWithTarget:self selector:@selector(handleAddConversation:error:)];
        [self performSegueToConversationViewController];
    }
    
}

- (void) handleAddConversation:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        NSLog(@"Add conversation sucess");
    } else {
        [HSUtilities showError:error];
    }
}

- (BOOL) populateConversationProperties {
    if (![self checkConversationProperties]) {
        return false;
    }
    
    conversation.creator = [PFUser currentUser];
    conversation.title = [HSUtilities trim:self.titleField.text];
    conversation.isQuickQuestion = self.quickQuestionSwitch.isOn;
    
    HSComment* comment = [HSComment object];
    comment.content = [HSUtilities trim:self.contentField.text].length ? [HSUtilities trim:self.contentField.text] : @"See attached photo.";
    comment.creator = [PFUser currentUser];
    conversation.comments = [NSArray arrayWithObject:comment];
    
    if (image == nil) {
        imageData = nil;
        conversation.image = nil;
    }
    return true;
}

- (BOOL) checkConversationProperties {
    NSString* errorMessage;
    
    if ([HSUtilities trim:self.titleField.text].length <= 0) {
        errorMessage = @"Title cannot be empty";
        [HSUtilities showError:[HSUtilities newError:errorMessage]];
        return false;
    }
    
    if ([HSUtilities trim:self.contentField.text].length <= 0 && self.selectedImage.image == nil) {
        errorMessage = @"Please add a message or photo";
        [HSUtilities showError:[HSUtilities newError:errorMessage]];
        return false;
    }
    
    return true;
}

- (void) performSegueToConversationViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HSConversationViewController *next = [storyboard instantiateViewControllerWithIdentifier:@"HSConversationViewController"];
   
    [self.navigationController pushViewController:next animated:YES];
    next.conversation = conversation;
    next.image = image;
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [viewControllers removeObject:self];
    [self.navigationController setViewControllers:[NSArray arrayWithArray:viewControllers]];

}

- (IBAction)addPhotos:(id)sender {
    imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    

    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose existing",  nil];
        [actionSheet showInView:self.view];
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:NO completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
            
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            break;
    }
    [self presentViewController:imagePicker animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.selectedImage.image = image;
    imageData = UIImageJPEGRepresentation(image, 0.9f);
    conversation.image = [PFFile fileWithName:@"image.jpg" data:imageData contentType:@"image"];
    [conversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [HSUtilities showError:error];
        }
    }
     ];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    NSLog(@"Fell in a bush. Not picking blackberries.");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)presentImagePicker {
//    self.imagePicker = [[UIImagePickerController alloc] init];
//    self.imagePicker.delegate = self;
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    } else {
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    [self presentViewController:self.imagePicker animated:NO completion:nil];
//}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        // Save the image
//        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self reset];
//}

- (void) viewWillDisappear:(BOOL)animated {
    // Dismiss keyboard
    [self dismissKeyboard];
}


- (void) dismissKeyboard {
    [self.titleField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) aNotification {
    [self setScrollviewFrameFromHeight:[self getKeyboardHeightFromNotification:aNotification] * -1];
}

- (void) keyboardWillBeHidden:(NSNotification *) aNotification {
    [self setScrollviewFrameFromHeight:[self getKeyboardHeightFromNotification:aNotification]];
}

- (float) getKeyboardHeightFromNotification: (NSNotification *) aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize KbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    return KbSize.height;
}

- (void) setScrollviewFrameFromHeight: (float) keyboardHeight {
//    NSLog(@"Setting scrollview on keyboard shown or hidden: %f", keyboardHeight);
    float newScrollViewHeight = self.scrollView.frame.size.height + keyboardHeight;
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, newScrollViewHeight);
}

@end
