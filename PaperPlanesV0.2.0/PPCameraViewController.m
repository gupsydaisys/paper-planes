//
//  PPCameraViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/8/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPCameraViewController.h"
#import "NSString+FontAwesome.h"


@interface PPCameraViewController ()

@end

@implementation PPCameraViewController

-(void)viewDidLoad {
    UILabel *logo = [UILabel new];
    CGFloat logoSize = 200;
    logo.font = [UIFont fontWithName:kFontAwesomeFamilyName size:logoSize];
    logo.text = [NSString fontAwesomeIconStringForEnum:FApaperPlane];
    logo.layer.contentsScale = [[UIScreen mainScreen] scale];

    logo.translatesAutoresizingMaskIntoConstraints = NO;
    

    [self.view addSubview:logo];
    
    [self.view addConstraint:
        [NSLayoutConstraint constraintWithItem:logo
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                      constant:logoSize]];
    
    UIView *vSpacerTop = [UIView new];
    UIView *vSpacerBottom = [UIView new];
    UIView *hSpacerLeft = [UIView new];
    UIView *hSpacerRight = [UIView new];
    
    vSpacerTop.translatesAutoresizingMaskIntoConstraints = NO;
    vSpacerBottom.translatesAutoresizingMaskIntoConstraints = NO;
    hSpacerLeft.translatesAutoresizingMaskIntoConstraints = NO;
    hSpacerRight.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:vSpacerTop];
    [self.view addSubview:vSpacerBottom];
    [self.view addSubview:hSpacerLeft];
    [self.view addSubview:hSpacerRight];
    
    [self.view addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|[hSpacerLeft][logo][hSpacerRight(==hSpacerLeft)]|"
                              options:0
                              metrics:nil
                              views:NSDictionaryOfVariableBindings(logo, hSpacerLeft, hSpacerRight)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[vSpacerTop][logo][vSpacerBottom(==vSpacerTop)]|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(logo, vSpacerTop, vSpacerBottom)]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:NO completion:nil];
}

@end
