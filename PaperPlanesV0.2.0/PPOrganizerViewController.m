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
#import "PPUtilities.h"
#import "UIOutlineLabel.h"

@interface PPOrganizerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (nonatomic, strong) NSMutableArray* feedbackItems;

@property (nonatomic, strong) PPButton* cameraButton;
@property (nonatomic, strong) PPFeedbackItemCell* selectedCell;

@end

@implementation PPOrganizerViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self populateFeedbackItems];
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
    [self.collectionView reloadData];

}

- (void) populateFeedbackItems {
    PFQuery *query = [PFQuery queryWithClassName:@"FeedbackItem"];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"imageObject"];
    [query includeKey:@"boxes"];
    [query includeKey:@"creator"];
    [query includeKey:@"boxes.comments"];
    [query includeKey:@"boxes.comments.creator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.feedbackItems = [NSMutableArray arrayWithCapacity:0];
        for (PPFeedbackItem* feedbackItem in objects) {
            [self.feedbackItems addObject:feedbackItem];
            [self.collectionView reloadData];
        }
        
    }];

}

- (void) addFeedbackItem:(PPFeedbackItem *) feedbackItem {
    [self.feedbackItems insertObject:feedbackItem atIndex:0];
    [self.collectionView reloadData];
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
    NSNumber *marginY = [NSNumber numberWithInt:11];
    
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
        addFeedbackViewController.feedbackItem = self.selectedCell.feedbackItem;
    }
}


- (UIViewController*) controllerForPaging {
    return self;
}


#pragma mark - Collection View Data Source Methods
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feedbackItems.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPFeedbackItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedbackItemCell" forIndexPath:indexPath];
    
    cell.image = nil;

    PPFeedbackItem* feedbackItem = [self.feedbackItems objectAtIndex:indexPath.item];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        UIImage* image = [ PPUtilities getImageFromObject:feedbackItem.imageObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.image = image;
        });
    });
    
    cell.feedbackItem = feedbackItem;
    
    //set offset accordingly
    CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    cell.creator.text = feedbackItem.creator.username;
    cell.creator.layer.zPosition = 1.0f;
    
    /* Setting the whether or not feedback item is viewed */
    if (![feedbackItem.haveViewed containsObject:[PFUser currentUser].objectId]) {
        cell.readItem.hidden = false;
        [self addItemReadTo:cell];
        cell.readItem.layer.zPosition = 1.0f;
    } else {
        cell.readItem.hidden = true;
    }
    
    /* Setting the number of new comments for feedback item */
    int newCommentCount = [self getCommentCountForCell:cell fromFeedbackItem:feedbackItem];
    if (newCommentCount > 0) {
        cell.readComment.hidden = false;
        [self addCommentReadTo:cell withNumber:newCommentCount];
        cell.readComment.layer.zPosition = 1.0f;
    } else {
        cell.readComment.hidden = true;
    }
    
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    return cell;
}

- (void) cellTapped: (UITapGestureRecognizer *) gesture {
    self.selectedCell = (PPFeedbackItemCell*) gesture.view;
    [self.pageViewController transitionToFeedbackViewController];
}

#pragma mark - Notificaiton Configuration Method
- (void) addItemReadTo: (PPFeedbackItemCell*) cell {
    // TODO: make circle more obvious
    cell.readItem.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
    cell.readItem.text = [NSString fontAwesomeIconStringForEnum:FACircle];
    cell.readItem.textColor = [UIColor colorWithRed:0.0f / 255.0f green:128.0f / 255.0f blue:255.0f / 255.0f alpha:1];
}

- (int) getCommentCountForCell: (PPFeedbackItemCell*) cell fromFeedbackItem:(PPFeedbackItem*) feedbackItem {
    int count = 0;
    for (PPBox* box in feedbackItem.boxes) {
        for (PPBoxComment *comment in box.comments) {
            if (![comment.haveViewed containsObject:[PFUser currentUser].objectId])
                count++;
        }
    }
    return count;
}
- (void) addCommentReadTo: (PPFeedbackItemCell*) cell withNumber:(int) count {
    // TODO: make it nicer
    cell.readComment.text = [NSString stringWithFormat:@"%d", count];
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(PPFeedbackItemCell *cell in self.collectionView.visibleCells) {
        CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        cell.imageOffset = CGPointMake(0.0f, yOffset);
    }
}


@end
