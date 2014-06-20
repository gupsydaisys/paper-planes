//
//  PPDotBoxView.m
//  PaperPlanesV0.1.0
//
//  Created by lux on 6/12/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "PPDotBoxView.h"
#import "HSComment.h"
#import "NSString+FontAwesome.h"

@interface PPDotBoxView () {
    UIColor* color;
    BOOL selected;
    CAShapeLayer *boxLayer;
}

@end

@implementation PPDotBoxView

#define kDotBoxDefaultWidth 34.0f
#define kDefaultColor [UIColor colorWithRed:57/255.0f green:150/255.0f blue:219/255.0f alpha:1.0]
#define kSelectedColor [UIColor colorWithRed:24/255.0f green:64/255.0f blue:93/255.0f alpha:1.0]

- (id)initWithModel:(PPDotBox*) model {
    self.model = model;
//    selected = model.selected;
    return [self initWithFrame:CGRectMake(model.originX, model.originY, model.width, model.height)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.model) {
            self.model = [PPDotBox object];
        }
        self.opaque = NO;
        self.minWidth = kDotBoxDefaultWidth;
        [self setSelectionColor:false];
        [self addBoxLayer];
        [self addDeleteButton];
        [self addDotLayer];
    }
    return self;
}

- (void) addBoxLayer {
    boxLayer = [CAShapeLayer layer];
    [boxLayer setFillColor:[UIColor clearColor].CGColor];
    [boxLayer setStrokeColor:kDefaultColor.CGColor];
    [boxLayer setLineWidth:2.0f];
    [boxLayer setLineJoin:kCALineCapSquare];
    [boxLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:5], nil]];
    
    [self.layer addSublayer:boxLayer];
}

- (void) addDotLayer {
    self.dotLayer = [CAShapeLayer layer];
    [self.dotLayer setFillColor:kDefaultColor.CGColor];
    [self.layer addSublayer:self.dotLayer];
}

- (void) addDeleteButton {
    float deleteButtonWidth = 30.0f;
    CGRect deleteButtonRect = CGRectMake(2.0f, 0, deleteButtonWidth, deleteButtonWidth);
    UIFont* deleteIconFont = [UIFont fontWithName:kFontAwesomeFamilyName size:deleteButtonWidth];

    self.deleteButton = [[UIView alloc] initWithFrame:deleteButtonRect];
    UILabel* circle = [[UILabel alloc] initWithFrame:deleteButtonRect];
    UILabel* xShape = [[UILabel alloc] initWithFrame:deleteButtonRect];
    
    circle.font = deleteIconFont;
    xShape.font = deleteIconFont;
    
    circle.text = [NSString fontAwesomeIconStringForEnum:FACircle];
    xShape.text = [NSString fontAwesomeIconStringForEnum:FATimesCircleO];
    
    [circle setTextColor:[UIColor whiteColor]];
//    [xShape setTextColor:[UIColor blackColor]];
    [xShape setTextColor:kSelectedColor];
    
    [self.deleteButton addSubview:circle];
    [self.deleteButton addSubview:xShape];
    
    [self addSubview:self.deleteButton];
}

- (CGRect) getDotFrame:(CGRect)frame {
    return CGRectMake(CGRectGetMaxX(frame) - kDotBoxDefaultWidth, CGRectGetMaxY(frame) - kDotBoxDefaultWidth, kDotBoxDefaultWidth, kDotBoxDefaultWidth);
}

- (CGRect) getBoxFrame:(CGRect)frame {
    return CGRectMake(frame.origin.x + kDotBoxDefaultWidth / 2, frame.origin.y + kDotBoxDefaultWidth / 2, frame.size.width - kDotBoxDefaultWidth, frame.size.height - kDotBoxDefaultWidth);
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath* rectPath = [UIBezierPath bezierPathWithRect:[self getBoxFrame:rect]];
    boxLayer.path = rectPath.CGPath;
    
    UIBezierPath* dotPath = [UIBezierPath bezierPathWithOvalInRect:[self getDotFrame:rect]];
    self.dotLayer.path = dotPath.CGPath;
    
    self.model.originX = self.frame.origin.x;
    self.model.originY = self.frame.origin.y;
    self.model.width  = self.frame.size.width;
    self.model.height = self.frame.size.height;
}

- (BOOL) isSelected {
    return selected;
}

- (BOOL) toggleSelected {
    selected = !selected;
    [self setSelectionColor:selected];
    return  selected;
}

- (void) setSelected:(BOOL) isSelected {
    selected = isSelected;
    [self setSelectionColor:isSelected];
}

- (void) setSelectionColor:(BOOL) isSelected {
    if (isSelected) {
        [self.dotLayer setFillColor:kSelectedColor.CGColor];
        [boxLayer setStrokeColor:kSelectedColor.CGColor];
    } else {
        [self.dotLayer setFillColor:kDefaultColor.CGColor];
        [boxLayer setStrokeColor:kDefaultColor.CGColor];
    }
    
    [self setNeedsDisplay];
}

- (void) blink {
    [self blinkOn];
}

- (void) blinkOn {
    
    CAKeyframeAnimation *fillAnimation = [CAKeyframeAnimation animation];
    fillAnimation.keyPath = @"fillColor";
    fillAnimation.duration = .35;
    fillAnimation.values = @[(__bridge id)kDefaultColor.CGColor,
                         (__bridge id)kSelectedColor.CGColor,
                         (__bridge id)kDefaultColor.CGColor,
                         (__bridge id)kSelectedColor.CGColor];
    
    
    CAKeyframeAnimation *strokeAnimation = [CAKeyframeAnimation animation];
    strokeAnimation.keyPath = @"strokeColor";
    strokeAnimation.duration = .35;
    strokeAnimation.values = @[(__bridge id)kDefaultColor.CGColor,
                         (__bridge id)kSelectedColor.CGColor,
                         (__bridge id)kDefaultColor.CGColor,
                         (__bridge id)kSelectedColor.CGColor];
    
    [self.dotLayer addAnimation:fillAnimation forKey:nil];
    [boxLayer addAnimation:strokeAnimation forKey:nil];
}

- (void) logComments {
    for(HSComment* comment in self.model.comments) {
        NSLog(@"comment %@", comment);
    }
//    NSLog(@"logging comments");
//    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
//    NSLog(@"dotbox model %@", self.model);
//    [query whereKey:@"dotBox" equalTo:self.model];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSLog(@"comments %@", objects);
//    }];
}

+ (PPDotBoxView *) dotBoxAtPoint: (CGPoint) point {
    PPDotBoxView* dotBox = [[self alloc] initWithFrame:CGRectMake(point.x - kDotBoxDefaultWidth / 2, point.y - kDotBoxDefaultWidth / 2, kDotBoxDefaultWidth, kDotBoxDefaultWidth)];
    return dotBox;
}



@end
