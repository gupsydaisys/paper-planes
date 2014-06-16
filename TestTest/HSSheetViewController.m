//
//  HSSheetViewController.m
//  improvisio-v4.2
//
//  Created by lux on 6/11/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "HSSheetViewController.h"
#import "HSConversationViewController.h"
#import "HSConversation.h"
#import "PPDotBoxView.h"
#import <Parse/Parse.h>

@interface HSSheetViewController () {
    PPDotBoxView* currentlySelectedDotBox;
    PPDotBoxView* currentlyPanningDotBox;
    PPDotBoxView* currentlyResizingDotBox;
    CGPoint initialLongPressPoint;
}

@end

@implementation HSSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if ([self getConversationViewController].conversation.image != nil) {

        PFFile* imageFile = [self getConversationViewController].conversation.image;
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        self.scrollView.contentSize = self.imageView.frame.size;
        self.scrollView.delegate = self;
        
        self.imageView.image = [UIImage imageWithData:imageData];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.imageView addGestureRecognizer:tapRecognizer];
        
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.imageView addGestureRecognizer:panRecognizer];
        
        UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self.imageView addGestureRecognizer:longPressRecognizer];
    }
}

- (void) handleTap: (UITapGestureRecognizer *) tapGesture {
    PPDotBoxView* touchedDotBox = [self getTouchedDotBox:tapGesture];

    if (touchedDotBox) {
        [self toggleSelectDotBox:touchedDotBox];
    } else {
        // Add a new dotbox at this location
        CGPoint tapPoint = [tapGesture locationInView:tapGesture.view];
        PPDotBoxView* newDotBox = [PPDotBoxView dotBoxAtPoint:tapPoint];
        [self selectDotBox:newDotBox];
        [tapGesture.view addSubview:newDotBox];
    }
}

- (void) handlePan: (UIPanGestureRecognizer *) panGesture {
    UIGestureRecognizerState state = [panGesture state];
    
    if (state == UIGestureRecognizerStateBegan) {
        PPDotBoxView* touchedDotBox = [self getTouchedDotBox:panGesture];
        if (touchedDotBox) {
            [self selectDotBox:touchedDotBox];
            [self setPanningDotBox:touchedDotBox];
        } else {
            [self setPanningDotBox:nil];
        }
    } else if (state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:panGesture.view];
        currentlyPanningDotBox.frame = CGRectOffset(currentlyPanningDotBox.frame, translation.x, translation.y);
    }
    
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
}

- (void) handleLongPress: (UILongPressGestureRecognizer *) longPressGesture {
    PPDotBoxView* touchedDotBox = [self getTouchedDotBox:longPressGesture];
    UIGestureRecognizerState state = [longPressGesture state];
    
    if (state == UIGestureRecognizerStateBegan) {
        initialLongPressPoint = [longPressGesture locationInView:longPressGesture.view];
        if (touchedDotBox) {
            [self selectDotBox:touchedDotBox];
            [touchedDotBox blink];
            [self setResizingDotBox:touchedDotBox];
        } else {
            [self setResizingDotBox:nil];
        }
    } else if (state == UIGestureRecognizerStateChanged) {
        CGPoint longPressPoint = [longPressGesture locationInView:longPressGesture.view];
        CGPoint translation = CGPointMake(longPressPoint.x - initialLongPressPoint.x, longPressPoint.y - initialLongPressPoint.y);

        CGRect resizedDotBoxFrame = currentlyResizingDotBox.frame;
        resizedDotBoxFrame = CGRectOffset(resizedDotBoxFrame, translation.x / 2, translation.y / 2);
        resizedDotBoxFrame = CGRectInset(resizedDotBoxFrame, -translation.x / 2, -translation.y /2);
        
        CGRect translatedDotBoxFrame = currentlyResizingDotBox.frame;
        translatedDotBoxFrame = CGRectOffset(translatedDotBoxFrame, translation.x, translation.y);
        
        if (resizedDotBoxFrame.size.width >= currentlyResizingDotBox.minWidth && resizedDotBoxFrame.size.height >= currentlyResizingDotBox.minWidth) {
            [currentlyResizingDotBox setFrame:resizedDotBoxFrame];
            [currentlyResizingDotBox setNeedsDisplay];
        } else {
            [currentlyResizingDotBox setFrame:translatedDotBoxFrame];
            [currentlyResizingDotBox setNeedsDisplay];
        }
        
        initialLongPressPoint = longPressPoint; // Equivalent of setTranslation:CGPointZero
    }
    
}

- (PPDotBoxView*) getTouchedDotBox: (UIGestureRecognizer *) gesture {
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    UIView *hitView = [gesture.view hitTest:touchPoint withEvent:nil];
    if ([hitView isKindOfClass:[PPDotBoxView class]]) {
        return (PPDotBoxView*)hitView;
    } else {
        return nil;
    }
}

- (void) selectDotBox: (PPDotBoxView*) dotBox {
    [currentlySelectedDotBox setSelected:false];
    [dotBox setSelected:true];
    currentlySelectedDotBox = dotBox;
}

- (void) toggleSelectDotBox: (PPDotBoxView*) dotBox {
    BOOL didSelect = [dotBox toggleSelected];

    if (didSelect) {
        if (currentlySelectedDotBox != nil) {
            [currentlySelectedDotBox toggleSelected];
        }
        currentlySelectedDotBox = dotBox;
    } else {
        currentlySelectedDotBox = nil;
    }
}

- (void) setPanningDotBox: (PPDotBoxView*) dotBox {
    currentlyPanningDotBox = dotBox;
}

- (void) setResizingDotBox: (PPDotBoxView*) dotBox {
    currentlyResizingDotBox = dotBox;
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (HSConversationViewController*) getConversationViewController {
    return (HSConversationViewController*)self.parentViewController;
}

- (void)commentAdded {
}


@end
