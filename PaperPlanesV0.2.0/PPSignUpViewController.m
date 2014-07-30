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
#import "NSString+FontAwesome.h"

@interface PPSignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *logo;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *switchEntryPageButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logInBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logInLeadingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpTrailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logInSignUpEqualWidthConstraint;

- (IBAction) logIn;
- (IBAction) signUp;
- (IBAction) switchEntryPage;

enum entryPages
{
    LANDING_PAGE = 0,
    SIGN_UP = 1,
    LOG_IN = 2,
} typedef EntryPage;

@property (nonatomic, strong) PFUser *user;
@property EntryPage currentPage;
@property (nonatomic, strong) NSLayoutConstraint *signUpWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *logInWidthConstraint;
@property BOOL inAnimation;
@end

@implementation PPSignUpViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self addObservers];
    _currentPage = LANDING_PAGE;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    self.logo.font = [UIFont fontWithName:kFontAwesomeFamilyName size:50];
    self.logo.text = [NSString fontAwesomeIconStringForEnum:FApaperPlaneO];
    self.logo.textColor = [UIColor whiteColor];

    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"LogInToRequestFeedbackSegue" sender:self];
    } else {
        _user = [PFUser user];
    }

}
- (IBAction) logIn {
    if (!_inAnimation) {
        if (_currentPage == LANDING_PAGE) {
            [self performTransitionTo:LOG_IN];
        } else {
            if (_emailField.text.length <= 0) {
                [_emailField becomeFirstResponder];
            } else if (_passwordField.text.length <= 0) {
                [_passwordField becomeFirstResponder];
            } else if ([self populateUserProperties]) {
                [PFUser logInWithUsernameInBackground:_user.username
                                             password:_user.password
                                               target:self
                                             selector:@selector(handleLogIn:error:)];
            }
        }
    }
}

// You can log in on the sign up page if you want to (bug...who knowzzz)
- (IBAction) signUp {
    if (!_inAnimation) {
        if (_currentPage == LANDING_PAGE) {
            [self performTransitionTo:SIGN_UP];
        } else {
            if (_emailField.text.length <= 0) {
                [_emailField becomeFirstResponder];
            } else if (_passwordField.text.length <= 0) {
                [_passwordField becomeFirstResponder];
            } else if ([self populateUserProperties]) {
                [_user signUpInBackgroundWithTarget:self
                                           selector:@selector(handleSignUp:error:)];
            }
        }
    }
}

- (IBAction) switchEntryPage {
    /* from sign up go to log in and vice versa */
    _currentPage == SIGN_UP ? [self performTransitionTo:LOG_IN] : [self performTransitionTo:SIGN_UP];
}

- (void) performTransitionTo:(EntryPage) entryPage {
    _inAnimation = true;
    
    [UIView animateWithDuration:.7f animations:^{
        _logoTopConstraint.constant = 10;
        _emailField.text = @"";
        _passwordField.text = @"";
        _emailField.hidden = false;
        _passwordField.hidden = false;
        _switchEntryPageButton.hidden = false;
        if (_currentPage == LANDING_PAGE) {
            _signUpWidthConstraint = [NSLayoutConstraint constraintWithItem:_signUpButton
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:self.view.frame.size.width];
            _logInWidthConstraint = [NSLayoutConstraint constraintWithItem:_logInButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:self.view.frame.size.width];
            [self.view addConstraint:_signUpWidthConstraint];
            [self.view addConstraint:_logInWidthConstraint];
        }
        
        _currentPage = entryPage;
        
        if (_currentPage == SIGN_UP) {
            _logInWidthConstraint.constant = 0;
            _signUpWidthConstraint.constant = self.view.frame.size.width;
            [_switchEntryPageButton setTitle:@"Log In" forState:UIControlStateNormal];
        } else {
            _logInWidthConstraint.constant = self.view.frame.size.width;
            _signUpWidthConstraint.constant = 0;
            [_switchEntryPageButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        }
        
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
        
        } completion:^(BOOL finished) {
        if (finished) {
            
            _inAnimation = false;

        }
    }];
}

#pragma mark - Methods that handle input into Text fields

- (void) handleSignUp:(NSNumber *)result error:(NSError *) error {
    [self handleLogIn:result error:error];
}

- (void) handleLogIn:(id)result error:(NSError *) error {
    if (error) {
        _user = [PFUser user]; // Reset user so they can try again
        [PPUtilities showError:error];
        [_emailField becomeFirstResponder];
    } else {
        [self performSegueWithIdentifier:@"LogInToRequestFeedbackSegue" sender:self];
    }
}

- (BOOL) populateUserProperties {
    if ([self checkUserProperties]) {
        _user.email = [PPUtilities trim:_emailField.text];
        _user.password = _passwordField.text;
        _user.username = [PPUtilities getEmailUsername:_emailField.text];
        return true;
    } else {
        return false;
    }
}

- (BOOL) checkUserProperties {
    NSString *errorMessage;
    
    // Note: Order matters here. Error cases go in order of increasing priority.
    
    if (_emailField.text.length <= 0) {
        errorMessage = @"Email cannot be empty";
    }

    
    if (_passwordField.text.length <= 0) {
        errorMessage = @"Password cannot be empty";
    }
    
    if (_emailField.text.length <= 0) {
        errorMessage = @"Email cannot be empty";
    }

    if (errorMessage) {
        [PPUtilities showError:[PPUtilities newError:errorMessage]];
        return false;
    }
    
    return true;
}

#pragma mark - Keyboard Shit
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification *) aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize KbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self updateKeyboardHeight:KbSize.height];
    
    // Matching the keyboard animation curve in ios 7.
    // see: http://stackoverflow.com/questions/18957476/ios-7-keyboard-animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationCurve:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
    
}

- (void) keyboardWillBeHidden:(NSNotification *) aNotification {
    [self updateKeyboardHeight:0];

    // Matching the keyboard animation curve in ios 7.
    // see: http://stackoverflow.com/questions/18957476/ios-7-keyboard-animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationCurve:[[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];

}

- (void) updateKeyboardHeight:(float) newHeight {
    _logInBottomConstraint.constant = newHeight;
    _signUpBottomConstraint.constant = newHeight;
    [self.view setNeedsUpdateConstraints];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _emailField) {
        [self.view endEditing:true];
        [_passwordField becomeFirstResponder];
        NSLog(@"email field");
    } else {
        [self.view endEditing:true];
        _currentPage == SIGN_UP ? [self signUp] : [self logIn];
        NSLog(@"password field");
    }
    return false;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

@end
