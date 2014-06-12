//
//  HSSignInViewController.h
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/7/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HSUtilities.h"

@interface HSSignInViewController : UIViewController

//@property (strong, nonatomic) PFUser *user;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signUp:(id)sender;
- (IBAction)logIn:(id)sender;

@end
