//
//  PPCameraViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/8/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPCameraViewController.h"
#import "IKCapture.h"
#import "NSString+FontAwesome.h"


@interface PPCameraViewController ()

@end

@implementation PPCameraViewController

-(void)viewDidLoad {
    [super viewDidLoad];
//    [self addLogo];
    UIView* cameraOverlay = [self cameraOverlay];
    
    if ([IKCapture isCameraAvailable]) {
        IKCapture* captureView = [[IKCapture alloc] initWithFrame:self.view.frame];
        [captureView startRunning];
        captureView.overlay = cameraOverlay;
        [self.view addSubview:captureView];
    }
}

-(UIView*)cameraOverlay {
    UIView* cameraOverlay = [[UIView alloc] initWithFrame:self.view.frame];
    UILabel *cameraButton = [UILabel new];
    CGFloat buttonSize = 80;
    cameraButton.font = [UIFont fontWithName:kFontAwesomeFamilyName size:buttonSize];
    cameraButton.text = [NSString fontAwesomeIconStringForEnum:FAcircleThin];
    cameraButton.textColor = [UIColor whiteColor];
    cameraButton.layer.contentsScale = [[UIScreen mainScreen] scale];
    
    
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [cameraOverlay addSubview:cameraButton];
    
    [cameraOverlay addConstraint:
     [NSLayoutConstraint constraintWithItem:cameraButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:buttonSize]];
    
    UIView *hSpacerLeft = [UIView new];
    UIView *hSpacerRight = [UIView new];
    
    hSpacerLeft.translatesAutoresizingMaskIntoConstraints = NO;
    hSpacerRight.translatesAutoresizingMaskIntoConstraints = NO;
    
    [cameraOverlay addSubview:hSpacerLeft];
    [cameraOverlay addSubview:hSpacerRight];
    
    [cameraOverlay addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|[hSpacerLeft][cameraButton][hSpacerRight(==hSpacerLeft)]|"
                                   options:0
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(cameraButton, hSpacerLeft, hSpacerRight)]];
    
    [cameraOverlay addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:[cameraButton]-20-|"
                                   options:0
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(cameraButton)]];
    
    return cameraOverlay;
}

-(void)addLogo {
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

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if ([IKCapture isCameraAvailable]) {
//        IKCapture* captureView = [[IKCapture alloc] initWithFrame:self.view.frame];
//        [captureView startRunning];
//        [self.view addSubview:captureView];
//    }
////    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
////    
////    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
////        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
////    } else {
////        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
////    }
////
////    picker.showsCameraControls = NO;
////    NSLog(@"present view controller");
////    [self.view addSubview:picker.view];
////    [picker viewWillAppear:YES];
////    [picker viewDidAppear:YES];
////    [self.view bringSubviewToFront:picker.view];
////    [self presentViewController:picker animated:NO completion:nil];
//}

@end
