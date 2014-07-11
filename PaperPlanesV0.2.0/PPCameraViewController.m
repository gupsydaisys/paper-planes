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
#import "PPTakePhotoButton.h"
#import "PPFeedbackViewController.h"

@interface PPCameraViewController () {
    PPTakePhotoButton* takePhotoButton;
    PPFeedbackViewController *next;
    IKCapture* captureView;
    UIImage* currentImage;
}

@end

@implementation PPCameraViewController

-(void)viewDidLoad {
    [super viewDidLoad];
////    [self addLogo];
//    UIView* cameraOverlay = [self cameraOverlay];
//    
//    if ([IKCapture isCameraAvailable]) {
//        captureView = [[IKCapture alloc] initWithFrame:self.view.frame];
//        [captureView startRunning];
//        captureView.overlay = cameraOverlay;
//        [self.view addSubview:captureView];
//    }
    
}

//- (BOOL) prefersStatusBarHidden {
//    return TRUE;
//}

//-(UIView*)cameraOverlay {
//    UIView* cameraOverlay = [[UIView alloc] initWithFrame:self.view.frame];
//    CGFloat buttonSize = 80;
//    takePhotoButton = [PPTakePhotoButton new];
//    takePhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [cameraOverlay addSubview:takePhotoButton];
//    
//    [cameraOverlay addConstraint:
//     [NSLayoutConstraint constraintWithItem:takePhotoButton
//                                  attribute:NSLayoutAttributeHeight
//                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                     toItem:nil
//                                  attribute:NSLayoutAttributeNotAnAttribute
//                                 multiplier:1
//                                   constant:buttonSize]];
//    [cameraOverlay addConstraint:
//     [NSLayoutConstraint constraintWithItem:takePhotoButton
//                                  attribute:NSLayoutAttributeWidth
//                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                     toItem:nil
//                                  attribute:NSLayoutAttributeNotAnAttribute
//                                 multiplier:1
//                                   constant:buttonSize]];
//    
//    UIView *hSpacerLeft = [UIView new];
//    UIView *hSpacerRight = [UIView new];
//    
//    hSpacerLeft.translatesAutoresizingMaskIntoConstraints = NO;
//    hSpacerRight.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [cameraOverlay addSubview:hSpacerLeft];
//    [cameraOverlay addSubview:hSpacerRight];
//    
//    [cameraOverlay addConstraints:[NSLayoutConstraint
//                                   constraintsWithVisualFormat:@"H:|[hSpacerLeft][takePhotoButton][hSpacerRight(==hSpacerLeft)]|"
//                                   options:0
//                                   metrics:nil
//                                   views:NSDictionaryOfVariableBindings(takePhotoButton, hSpacerLeft, hSpacerRight)]];
//    
//    [cameraOverlay addConstraints:[NSLayoutConstraint
//                                   constraintsWithVisualFormat:@"V:[takePhotoButton]-20-|"
//                                   options:0
//                                   metrics:nil
//                                   views:NSDictionaryOfVariableBindings(takePhotoButton)]];
//    
//    [takePhotoButton addTarget:self action:@selector(touchDownTakePhotoButton) forControlEvents:UIControlEventTouchDown];
//    [takePhotoButton addTarget:self action:@selector(touchUpInsideTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
//    
//    return cameraOverlay;
//}


- (void) touchDownTakePhotoButton {
    takePhotoButton.selected = TRUE;
}

- (void) touchUpInsideTakePhotoButton {
    takePhotoButton.selected = FALSE;
    takePhotoButton.hidden = YES;
    NSLog(@"Before");
    [captureView takeSnapshotWithCompletionHandler:^(UIImage *image) {
        NSLog(@"After");
        currentImage = image;
        [self performSegueWithIdentifier:@"FeedbackViewControllerSegue" sender:self];
    }];
    
}

- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == next) {
        takePhotoButton.hidden = NO;
        [captureView startRunning];
    }
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
