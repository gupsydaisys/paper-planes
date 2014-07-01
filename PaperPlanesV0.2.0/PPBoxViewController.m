//
//  PPBoxViewController.m
//  PaperPlanesV0.2.0
//
//  Created by lux on 7/1/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPBoxViewController.h"
#import "PPBoxView.h"

@interface PPBoxViewController () {
    BOOL selectionState;
    UITapGestureRecognizer* boxTapGestureRecognizer;
}


@end

@implementation PPBoxViewController

@dynamic view;
@synthesize delegate;

- (void) toggleSelection {
    selectionState = !selectionState;
    [self makeSelection:selectionState];
}

- (void) makeSelection:(BOOL) select {
    selectionState = select;
    [self.view showControls:selectionState];
    [self.view marchingAnts:selectionState];
    [delegate boxSelectionChanged:self toState:selectionState];
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    boxTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    boxTapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:boxTapGestureRecognizer];
    self.view.delegate = self;
    self.comments = [[NSMutableArray alloc] init];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *) gestureRecognizer shouldReceiveTouch:(UITouch *) touch {
    if (gestureRecognizer == boxTapGestureRecognizer) {
        if (touch.view == self.view) {
            // For some bizarre and unknown reason, although taps on boxLayer portion of PPBoxView will make it to this method,
            // they don't get sent to the action method as we would expect. So this is a hack that
            // manually sends the action method from here. I couldn't think of any other way to do it
            // that wouldn't overly complicate the code.
            [self boxTapped:(UITapGestureRecognizer*) gestureRecognizer];
        }
        // Since we are manually sending the action, we don't need to say YES for shouldReceiveTouch
        return NO;
    }
    
    return YES;
}

- (void) boxTapped: (UITapGestureRecognizer *) gesture {
    [self toggleSelection];
}

- (void) boxViewWasDeleted:(PPBoxView *)boxView {
    [delegate boxWasDeleted:self];
}


//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
