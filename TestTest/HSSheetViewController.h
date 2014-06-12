//
//  HSSheetViewController.h
//  improvisio-v4.2
//
//  Created by lux on 6/11/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSheetViewController : UIViewController <UIScrollViewDelegate>

- (void) commentAdded;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
