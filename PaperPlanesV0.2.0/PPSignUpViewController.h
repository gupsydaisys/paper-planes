//
//  PPSignUpViewController.h
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/22/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)logIn:(id)sender;
- (IBAction)signUp:(id)sender;
@end