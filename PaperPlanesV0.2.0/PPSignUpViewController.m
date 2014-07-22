//
//  PPSignUpViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/22/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPSignUpViewController.h"
#import <Parse/Parse.h>
#import "PPUtilities.h"

@interface PPSignUpViewController ()

@property (nonatomic, strong) PFUser *user;
@end

@implementation PPSignUpViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"LogInToRequestFeedbackSegue" sender:self];
    } else {
        self.user = [PFUser user];
    }
}

- (IBAction)logIn:(id)sender {
    if ([self populateUserProperties]) {
        [PFUser logInWithUsernameInBackground:self.user.username
                                     password:self.user.password
                                       target:self
                                     selector:@selector(handleLogIn:error:)];
    }
}

- (IBAction)signUp:(id)sender {
    if ([self populateUserProperties]) {
        [self.user signUpInBackgroundWithTarget:self
                                       selector:@selector(handleSignUp:error:)];
    }
}

- (void) handleSignUp:(NSNumber *)result error:(NSError *) error {
    [self handleLogIn:result error:error];
}

- (void) handleLogIn:(id)result error:(NSError *) error {
    if (error) {
        self.user = [PFUser user]; // Reset user so they can try again
        [PPUtilities showError:error];
    } else {
        [self performSegueWithIdentifier:@"LogInToRequestFeedbackSegue" sender:self];
    }
}

- (BOOL) populateUserProperties {
    if ([self checkUserProperties]) {
        self.user.email = [PPUtilities trim:self.emailField.text];
        self.user.password = self.passwordField.text;
        self.user.username = [PPUtilities getEmailUsername:self.emailField.text];
        return true;
    } else {
        return false;
    }
}

- (BOOL) checkUserProperties {
    NSString *errorMessage;
    
    // Note: Order matters here. Error cases go in order of increasing priority.
    
    if (self.emailField.text.length <= 0) {
        errorMessage = @"Email cannot be empty";
    }

    
    if (self.passwordField.text.length <= 0) {
        errorMessage = @"Password cannot be empty";
    }
    
    if (self.emailField.text.length <= 0) {
        errorMessage = @"Email cannot be empty";
    }

    if (errorMessage) {
        [PPUtilities showError:[PPUtilities newError:errorMessage]];
        return false;
    }
    
    return true;
}


@end
