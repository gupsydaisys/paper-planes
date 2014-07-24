//
//  PPOrganizerViewController.m
//  PaperPlanesV0.2.0
//
//  Created by Serena Gupta on 7/15/14.
//  Copyright (c) 2014 Learning Public. All rights reserved.
//

#import "PPOrganizerViewController.h"
#import "PPAddFeedbackViewController.h"
#import "PPFeedbackItemCell.h"
#import "PPCameraButton.h"

@interface PPOrganizerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (nonatomic, strong) NSMutableArray* images;

@property (nonatomic, strong) PPButton* cameraButton;
@property (nonatomic, strong) PPFeedbackItemCell* selectedCell;

@end

@implementation PPOrganizerViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self populateImages];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

/* Mock data */
//    NSUInteger index;
//    for (index = 0; index < 7; ++index) {
//        // Setup image name
//        NSString *name = [NSString stringWithFormat:@"img%03ld.jpg", (unsigned long)index];
//        if(!self.images)
//            self.images = [NSMutableArray arrayWithCapacity:0];
//        [self.images addObject:[UIImage imageNamed:name]];
//    }
/* End Mock Data */
    
    [self addHeaderButtons];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void) populateImages {
    PFQuery *query = [PFQuery queryWithClassName:@"ImageObject"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.images = [NSMutableArray arrayWithCapacity:0];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            for (PFObject* object in objects) {
                UIImage* image = [self getImageFromObject:object];
                if (image) {
                    [self.images addObject:image];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }
            
        });
    }];

}

- (UIImage*) getImageFromObject:(PFObject*) imageObject {
    PFFile* imageFile = imageObject[@"image"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    UIImage* image = [UIImage imageWithData:imageData];
    return image;
}

- (void) addImageObject:(PFObject *)imageObject {
    UIImage* image = [self getImageFromObject:imageObject];
    if (image) {
        [self.images insertObject:image atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

- (void) addHeaderButtons {
    [self addCameraButton];
    
}

- (void) addCameraButton {
    float buttonSize = 36;
    self.cameraButton = [[PPCameraButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
    self.cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.header addSubview:self.cameraButton];
    
    
    [self.header addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cameraButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:buttonSize]];
    [self.header addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cameraButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:buttonSize]];
    
    NSNumber *marginX = [NSNumber numberWithInt:5];
    NSNumber *marginY = [NSNumber numberWithInt:7];
    
    [self.header addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:[_cameraButton]-marginX-|"
                                   options:0
                                   metrics:NSDictionaryOfVariableBindings(marginX)
                                   views:NSDictionaryOfVariableBindings(_cameraButton)]];
    
    [self.header addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-marginY-[_cameraButton]"
                                   options:0
                                   metrics:NSDictionaryOfVariableBindings(marginY)
                                   views:NSDictionaryOfVariableBindings(_cameraButton)]];
    
    [self.cameraButton addTarget:self action:@selector(touchDownCameraButton) forControlEvents:UIControlEventTouchDown];
    [self.cameraButton addTarget:self action:@selector(touchUpInsideCameraButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton addTarget:self action:@selector(deselectCameraButton) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void) touchDownCameraButton {
    self.cameraButton.selected = true;
}

- (void) touchUpInsideCameraButton {
    [self.pageViewController transitionToRequestViewController];
}

- (void) deselectCameraButton {
    self.cameraButton.selected = false;
}

#pragma mark - Page View delegate/helper methods

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    UIViewController* nextController = [pendingViewControllers objectAtIndex:0];
    if ([nextController isKindOfClass:[PPAddFeedbackViewController class]]) {
        PPAddFeedbackViewController* addFeedbackViewController = (PPAddFeedbackViewController*)nextController;
        addFeedbackViewController.image = self.selectedCell.image;
    }
}


- (UIViewController*) controllerForPaging {
    return self;
}


#pragma mark - Collection View Data Source Methods
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPFeedbackItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedbackItemCell" forIndexPath:indexPath];
    cell.image = [self.images objectAtIndex:indexPath.item];
    
    //set offset accordingly
    CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    cell.creator.text = @"serenagupta";
    cell.creator.layer.zPosition = 1.0f;
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    return cell;
}

- (void) cellTapped: (UITapGestureRecognizer *) gesture {
    self.selectedCell = (PPFeedbackItemCell*) gesture.view;
    [self.pageViewController transitionToFeedbackViewController];
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(PPFeedbackItemCell *cell in self.collectionView.visibleCells) {
        CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        cell.imageOffset = CGPointMake(0.0f, yOffset);
    }
}


@end
