//
//  PPDotBoxView.m
//  PaperPlanesV0.1.0
//
//  Created by lux on 6/12/14.
//  Copyright (c) 2014 Learning Apps. All rights reserved.
//

#import "PPDotBoxView.h"

@interface PPDotBoxView () {
    UIColor* color;
    BOOL selected;
    CAShapeLayer *boxLayer;
    CAShapeLayer *dotLayer;
}

@end

@implementation PPDotBoxView

#define kDotBoxDefaultWidth 34.0f
#define kDefaultColor [UIColor colorWithRed:57/255.0f green:150/255.0f blue:219/255.0f alpha:1.0]
#define kSelectedColor [UIColor colorWithRed:24/255.0f green:64/255.0f blue:93/255.0f alpha:1.0]


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = [PPDotBox object];
        self.opaque = NO;
        self.minWidth = kDotBoxDefaultWidth;
        [self setSelectionColor:false];
        [self addBoxLayer];
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
    dotLayer = [CAShapeLayer layer];
    [dotLayer setFillColor:kDefaultColor.CGColor];
    
    [self.layer addSublayer:dotLayer];
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
    dotLayer.path = dotPath.CGPath;
    
    self.model.originX = self.frame.origin.x;
    self.model.originY = self.frame.origin.y;
    self.model.width  = self.frame.size.width;
    self.model.height = self.frame.size.height;
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
        [dotLayer setFillColor:kSelectedColor.CGColor];
        [boxLayer setStrokeColor:kSelectedColor.CGColor];
    } else {
        [dotLayer setFillColor:kDefaultColor.CGColor];
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
    
    [dotLayer addAnimation:fillAnimation forKey:nil];
    [boxLayer addAnimation:strokeAnimation forKey:nil];
}

+ (PPDotBoxView *) dotBoxAtPoint: (CGPoint) point {
    PPDotBoxView* dotBox = [[self alloc] initWithFrame:CGRectMake(point.x - kDotBoxDefaultWidth / 2, point.y - kDotBoxDefaultWidth / 2, kDotBoxDefaultWidth, kDotBoxDefaultWidth)];
    return dotBox;
}



@end
