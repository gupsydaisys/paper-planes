//
//  HSSignInViewController.m
//  improvisio-v4.2
//
//  Created by Serena Gupta on 6/7/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSSignInViewController.h"
#import "NSString+FontAwesome.h"

@interface HSSignInViewController () {
    PFUser *user;
}

@end

@implementation HSSignInViewController

- (void) viewDidLoad {
    [super viewDidLoad];
//    if ([PFUser currentUser] != nil) {
//        [self performSegueWithIdentifier:@"SignInToFeedSegue" sender:self];
//    } else {
        user = [PFUser user];
//    }
}

- (IBAction) signUp: (id)sender {
    if([self populateUserProperties]) {
        [user signUpInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
    }
}

- (IBAction)logIn:(id)sender {
    if([self populateUserProperties]) {
        [PFUser logInWithUsernameInBackground:user.username password:user.password target:self selector:@selector(handleLogIn:error:)];
    }
}


- (void)handleSignUp:(NSNumber *)result error:(NSError *)error {
    [self handleLogIn:result error:error];
}

- (void)handleLogIn:(id)result error:(NSError *)error {
//    NSLog(@"login");
    if (!error) {
//        NSLog(@"Success: %@", [PFUser currentUser]);
        [self performSegueWithIdentifier:@"SignInToFeedSegue" sender:self];
    } else {
        user = [PFUser user];  // Reset the user variable so they can try again
        [HSUtilities showError:error];
    }
}

//- (NSError*) newError: (NSString*) message {
//    NSMutableDictionary* details = [NSMutableDictionary dictionary];
//    [details setValue:message forKey:@"error"];
//    NSError *error = [NSError errorWithDomain:@"SH" code:418 userInfo:details];
//    return error;
//}
//
//- (void) showError:(NSError *) error {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
//                                                        message:[error.userInfo objectForKey:@"error"]
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
//}

- (BOOL) populateUserProperties {
    if (![self checkUserProperties]) {
        return false;
    }
    user.email = [HSUtilities trim:self.emailField.text];
    user.password = self.passwordField.text;
    user.username = [HSUtilities getEmailUsername:self.emailField.text];
    return true;
}

- (BOOL) checkUserProperties {
    NSString *errorMessage;
    if (self.passwordField.text.length <= 0) {
        errorMessage = @"Password cannot be empty";
        [HSUtilities showError:[HSUtilities newError:errorMessage]];
        return false;
    }
    
    return true;
}

@end
