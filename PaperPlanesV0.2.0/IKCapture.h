//
//  IKCapture.h
//  Pixter
//
//  Created by Andres on 6/26/14.
//  Copyright (c) 2014 Inaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKCapture : UIView

@property (nonatomic,readonly,getter=isFlashOn) BOOL flashON;
@property (nonatomic,strong) UIView *overlay;

/* Added in sessionQueue in order to have another thread for camera to be running on asynchronously from UI */
@property (nonatomic) dispatch_queue_t sessionQueue;

+(BOOL)isCameraAvailable;
-(void)takeSnapshotWithCompletionHandler:(void (^)(UIImage *image))completion;
-(void)changeCamera;
-(void)toggleFlash;
-(void)startRunning;
-(void)stopRunning;
-(void)setOverlay:(UIView*)overlay;
-(BOOL)currentCameraHasFlash;
@end
