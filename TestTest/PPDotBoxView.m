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
    CATextLayer *resizeIconLayer;
    UIColor* kDefaultColor;
    UIColor* kSelectedColor;
}

@end

@implementation PPDotBoxView

#define kDotBoxDefaultWidth 34.0f
#define kDeleteButtonDefaultWidth 30.0f

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
        
        kDefaultColor = self.tintColor;
        
        CGFloat hue, saturation, brightness, alpha;
        [kDefaultColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        kSelectedColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness*.9  alpha:alpha];
        
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
    
    resizeIconLayer = [self resizeIconLayer];
    resizeIconLayer.zPosition = 5;
    [self.layer addSublayer:boxLayer];
    [boxLayer addSublayer:resizeIconLayer];
}

- (void) setMarchingAnts:(BOOL)marchingAntsOn {
    if (marchingAntsOn) {
        CABasicAnimation *marchingAntsAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [marchingAntsAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [marchingAntsAnimation setToValue:[NSNumber numberWithFloat:(10.0f)]];
        [marchingAntsAnimation setDuration:0.75f];
        [marchingAntsAnimation setRepeatCount:10000];
        marchingAntsAnimation.timeOffset = (boxLayer.lineDashPhase / 10.0f) * 0.75f;
        [boxLayer addAnimation:marchingAntsAnimation forKey:@"linePhase"];
    } else {
        [boxLayer setLineDashPhase:[boxLayer.presentationLayer lineDashPhase]];
        [boxLayer removeAnimationForKey:@"linePhase"];
    }
}

- (void) toggleMarchingAnts {
    if ([boxLayer animationForKey:@"linePhase"]) {
        [self setMarchingAnts:TRUE];
    } else {
        [self setMarchingAnts:FALSE];
    }
}

- (void) addDotLayer {
    CGRect dotBoxRect = CGRectMake(0, 0, kDotBoxDefaultWidth, kDotBoxDefaultWidth);
    UIBezierPath* dotPath = [UIBezierPath bezierPathWithOvalInRect:dotBoxRect];
    
    self.dotLayer = [CAShapeLayer layer];
    self.dotLayer.path = dotPath.CGPath;
    self.dotLayer.zPosition = -1;
    [self.dotLayer setFillColor:kDefaultColor.CGColor];
    
    [self.layer addSublayer:self.dotLayer];
}

- (CATextLayer*) resizeIconLayer {
    CATextLayer *resizeIcon = [[CATextLayer alloc] init];
    
    resizeIcon.font = (__bridge CFTypeRef)(kFontAwesomeFamilyName);
    resizeIcon.fontSize = (kDotBoxDefaultWidth * 2) / 3;
    resizeIcon.string = [NSString fontAwesomeIconStringForEnum:FAExpand];
    resizeIcon.foregroundColor = [UIColor whiteColor].CGColor;
    resizeIcon.contentsScale = [[UIScreen mainScreen] scale];
    resizeIcon.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
    
    return resizeIcon;
}
- (void) addDeleteButton {
    CGRect deleteButtonRect = [self getDeleteButtonFrame];
    UIFont* deleteIconFont = [UIFont fontWithName:kFontAwesomeFamilyName size:kDeleteButtonDefaultWidth];

    self.deleteButton = [[UIView alloc] initWithFrame:deleteButtonRect];
    UILabel* circle = [[UILabel alloc] initWithFrame:deleteButtonRect];
    UILabel* xShape = [[UILabel alloc] initWithFrame:deleteButtonRect];
    
    circle.font = deleteIconFont;
    xShape.font = deleteIconFont;
    
    circle.text = [NSString fontAwesomeIconStringForEnum:FACircle];
    xShape.text = [NSString fontAwesomeIconStringForEnum:FATimesCircle];

    [circle setTextColor:[UIColor whiteColor]];
    [xShape setTextColor:kSelectedColor];
    
    [self.deleteButton addSubview:circle];
    [self.deleteButton addSubview:xShape];
    
    [self addSubview:self.deleteButton];
}

- (CGRect) getDotFrame:(CGRect)frame {
    return CGRectMake(CGRectGetMaxX(frame) - kDotBoxDefaultWidth, CGRectGetMaxY(frame) - kDotBoxDefaultWidth, kDotBoxDefaultWidth, kDotBoxDefaultWidth);
}

- (CGRect) getBoxFrame:(CGRect)frame {
    return CGRectMake(frame.origin.x + kDeleteButtonDefaultWidth / 2, frame.origin.y + kDeleteButtonDefaultWidth / 2, frame.size.width - kDotBoxDefaultWidth / 2 - kDeleteButtonDefaultWidth / 2, frame.size.height - kDotBoxDefaultWidth / 2 - kDeleteButtonDefaultWidth / 2);
}

- (CGRect) getDeleteButtonFrame {
    return CGRectMake(1.0f, 0, kDeleteButtonDefaultWidth, kDeleteButtonDefaultWidth);
}

- (CGRect) getResizeIconFrame:(CGRect)frame {
    CGRect boxFrame = [self getBoxFrame:frame];
    return CGRectMake(CGRectGetMaxX(boxFrame) - kDotBoxDefaultWidth / 2 - 5.0f, CGRectGetMaxY(boxFrame) - kDotBoxDefaultWidth / 2 + 8.0f, kDotBoxDefaultWidth, kDotBoxDefaultWidth);
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath* rectPath = [UIBezierPath bezierPathWithRect:[self getBoxFrame:rect]];
    boxLayer.path = rectPath.CGPath;
    if ([self isBox]) {
        [boxLayer setHidden:FALSE];
    } else {
        [boxLayer setHidden:TRUE];
    }
    
    // Disables implicit animations
    [CATransaction begin];
    [CATransaction setDisableActions:TRUE];
    self.dotLayer.frame = [self getDotFrame:rect];
    resizeIconLayer.frame = [self getResizeIconFrame:rect];
    [CATransaction commit];
    
    self.model.originX = self.frame.origin.x;
    self.model.originY = self.frame.origin.y;
    self.model.width  = self.frame.size.width;
    self.model.height = self.frame.size.height;
}

- (BOOL) isSelected {
    return selected;
}

- (BOOL) toggleSelected {
    return [self setSelected:![self isSelected]];
}

- (BOOL) setSelected:(BOOL) isSelected {
    if (isSelected) {
        // Show delete button, dot and box
        [self.deleteButton setHidden:FALSE];
        
        if ([self isBox]) {
            [boxLayer setHidden:FALSE];
            [resizeIconLayer setHidden:FALSE];
        }
        
        // Always show the dot upon selection
        [self.dotLayer setHidden:FALSE];
        
        // Turn on marching ants
        [self setMarchingAnts:TRUE];
        selected = TRUE;
        [self setSelectionColor:TRUE];
    } else {
        [self.deleteButton setHidden:TRUE];
        [self setMarchingAnts:FALSE];
        
        if ([self isBox]) {
            [self.dotLayer setHidden:TRUE];
            [resizeIconLayer setHidden:TRUE];
        } else {
            // Otherwise hide the box
            [boxLayer setHidden:TRUE];
        }
        
        selected = FALSE;
        [self setSelectionColor:FALSE];
    }
    
    return selected;
}

- (BOOL) isBox {
    // Returns whether this dotBox is big enough to be considered to be in "box mode"
    return (self.frame.size.width > kDotBoxDefaultWidth + kDeleteButtonDefaultWidth) ||
            (self.frame.size.height > kDotBoxDefaultWidth + kDeleteButtonDefaultWidth);
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
}

+ (PPDotBoxView *) dotBoxAtPoint: (CGPoint) point {
    float distanceBetweenCircleCenters = kDotBoxDefaultWidth / 2 + kDeleteButtonDefaultWidth / 2;
    float widthOfSquareCircumscribingCircles = distanceBetweenCircleCenters / sqrtf(2) + distanceBetweenCircleCenters;
    
    PPDotBoxView* dotBox = [[self alloc] initWithFrame:CGRectMake(point.x - widthOfSquareCircumscribingCircles + kDotBoxDefaultWidth / 2, point.y - widthOfSquareCircumscribingCircles + kDotBoxDefaultWidth / 2, widthOfSquareCircumscribingCircles, widthOfSquareCircumscribingCircles)];
    return dotBox;
}

@end
