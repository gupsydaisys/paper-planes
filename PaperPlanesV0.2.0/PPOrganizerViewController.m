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
@property (nonatomic, strong) NSMutableArray* images;

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
    [self addHeaderButtons];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];

}

- (void) populateFeedbackItems {
    PFQuery *userFilter = [PFUser query];
    [userFilter whereKey:@"role" notEqualTo:@"admin"];

    PFQuery *query = [PFQuery queryWithClassName:@"FeedbackItem"];
    [query orderByDescending:@"lastCommentAt"];
    [query includeKey:@"imageObject"];
    [query includeKey:@"boxes"];
    [query includeKey:@"creator"];
    [query includeKey:@"boxes.comments"];
    [query includeKey:@"boxes.comments.creator"];
    [query whereKey:@"creator" matchesQuery:userFilter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSInteger length = [objects count];
        self.feedbackItems = [NSMutableArray new];
        self.images = [NSMutableArray new];
        for (int i = 0 ; i != length ; [self.feedbackItems addObject:[NSNull null]], i++);
        for (int i = 0 ; i != length ; [self.images addObject:[NSNull null]], i++);

        NSInteger count = 0;
        for (PPFeedbackItem* feedbackItem in objects) {
            [self.feedbackItems replaceObjectAtIndex:count withObject:feedbackItem];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [self.images replaceObjectAtIndex:count withObject:[PPUtilities getImageFromObject:feedbackItem.imageObject]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            });
            
            count++;
        }
        
    }];

}

- (void) addFeedbackItem:(PPFeedbackItem *) feedbackItem {
    [self.feedbackItems insertObject:feedbackItem atIndex:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.images insertObject:[PPUtilities getImageFromObject:feedbackItem.imageObject] atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
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
    
    PPFeedbackItem* feedbackItem = [self.feedbackItems objectAtIndex:indexPath.item];
    
    if ([[self.images objectAtIndex:indexPath.item] isKindOfClass:[NSNull class]]) {
        cell.image = nil;
    } else {
        cell.image = [self.images objectAtIndex:indexPath.item];
    }
    
    cell.feedbackItem = feedbackItem;
    
    //set offset accordingly
    CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    cell.creator.text = feedbackItem.creator.username;
    cell.creator.layer.zPosition = 1.0f;
    
    /* Setting the number of new comments for feedback item */
    int newCommentCount = [self getCommentCountForCell:cell fromFeedbackItem:feedbackItem];
    if (newCommentCount > 0) {
        cell.readComment.hidden = false;
        [self addCommentReadTo:cell withNumber:newCommentCount];
        cell.readComment.layer.zPosition = 1.0f;
    } else {
        cell.readComment.hidden = true;
    }
    
    /* Setting the whether or not feedback item has new information */
    if (![feedbackItem.haveViewed containsObject:[PFUser currentUser].objectId] || newCommentCount > 0) {
        cell.readItem.hidden = false;
        [self addItemReadTo:cell];
        cell.readItem.layer.zPosition = 1.0f;
//        cell.header.backgroundColor = cell.header.tintColor;
//        cell.header.alpha = 0.45f;
        
    } else {
        cell.readItem.hidden = true;
//        cell.header.backgroundColor = [UIColor blackColor];
//        cell.header.alpha = 0.35f;
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
    CGRect r = CGRectMake(0, 0, cell.readItem.frame.size.width, cell.readItem.frame.size.height);
    UILabel *whiteCircle = [[UILabel alloc] initWithFrame:r];
    whiteCircle.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    whiteCircle.text = [NSString fontAwesomeIconStringForEnum:FACircle];
    whiteCircle.textColor = [UIColor whiteColor];
    whiteCircle.textAlignment = NSTextAlignmentCenter;

    r = CGRectOffset(r, -.15, .5);
    UILabel *blueCircle = [[UILabel alloc] initWithFrame:r];
    blueCircle.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
    blueCircle.text = [NSString fontAwesomeIconStringForEnum:FACircle];
    blueCircle.textColor = cell.readItem.tintColor;
    blueCircle.textAlignment = NSTextAlignmentCenter;

    [cell.readItem addSubview:whiteCircle];
    [cell.readItem addSubview:blueCircle];

// TODO: make circle more obvious
//    cell.readItem.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
//    cell.readItem.text = [NSString fontAwesomeIconStringForEnum:FACircle];
//    cell.readItem.textColor = [UIColor colorWithRed:0.0f / 255.0f green:128.0f / 255.0f blue:255.0f / 255.0f alpha:1];
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
    cell.readComment.text = [NSString stringWithFormat:@" %d ", count];
    cell.readComment.textAlignment = NSTextAlignmentCenter;
    cell.readComment.layer.borderWidth = 1.0f;
    cell.readComment.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(PPFeedbackItemCell *cell in self.collectionView.visibleCells) {
        CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        cell.imageOffset = CGPointMake(0.0f, yOffset);
    }
}


@end
