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
#import <Parse/Parse.h>

@interface HSSheetViewController ()

@end

@implementation HSSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([self getConversationViewController].conversation.image != nil) {
        PFFile* imageFile = [self getConversationViewController].conversation.image;
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        self.imageView.image = [UIImage imageWithData:imageData];
    }
    
    self.scrollView.contentSize = self.imageView.frame.size;

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
