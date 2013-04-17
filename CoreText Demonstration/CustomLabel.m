//
//  CustomLabel.m
//  CoreText Demonstration
//
//  Created by Robert Ryan on 4/17/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "CustomLabel.h"
#import <CoreText/CoreText.h>

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 48.0;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        
        [self addGestureRecognizers];
    }
    return self;
}

- (void)addGestureRecognizers
{
    UIGestureRecognizer *gesture;
    
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:gesture];
    
    gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self addGestureRecognizer:gesture];
    
    gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:gesture];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!self.text)
        return;
    
	// create a font
    
	CTFontRef sysUIFont = CTFontCreateUIFontForLanguage(kCTFontSystemFontType, self.fontSize, NULL);
    
	// create attributes dictionary
    
	NSDictionary *attributes = @{
                              (__bridge id)kCTFontAttributeName            : (__bridge id)sysUIFont,
                              (__bridge id)kCTForegroundColorAttributeName : (__bridge id)[self.fillColor CGColor],
                              (__bridge id)kCTStrokeColorAttributeName     : (__bridge id)[self.borderColor CGColor],
                              (__bridge id)kCTStrokeWidthAttributeName     : @(-3)
                              };
    
	// make the attributed string

	NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:self.text
                                                                       attributes:attributes];
    
    // begin drawing
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	// flip the coordinate system
	
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
	// create CTLineRef
    
	CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)stringToDraw);
    
    // figure out the size (which we'll use to center it)
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
    CGFloat height = ascent + descent;
    CGSize stringSize = CGSizeMake(width, height);

    // draw it
    
	CGContextSetTextPosition(context,
                             (self.bounds.size.width  - stringSize.width)  / 2.0,
                             (self.bounds.size.height - stringSize.height + descent) / 2.0);
	CTLineDraw(line, context);
    
	// clean up
    
	CFRelease(line);
	CFRelease(sysUIFont);
}

#pragma mark - custom setters

- (void)setAngle:(CGFloat)angle
{
    [self willChangeValueForKey:@"angle"];
    _angle = angle;
    [self didChangeValueForKey:@"angle"];
    
    [self setTransformUsingScale:1.0 angle:angle translate:CGPointZero];
}

- (void)setFillColor:(UIColor *)fillColor
{
    [self willChangeValueForKey:@"fillColor"];
    _fillColor = fillColor;
    [self didChangeValueForKey:@"fillColor"];
    
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [self willChangeValueForKey:@"borderColor"];
    _borderColor = borderColor;
    [self didChangeValueForKey:@"borderColor"];
    
    [self setNeedsDisplay];
}

- (void)setFontSize:(CGFloat)fontSize
{
    [self willChangeValueForKey:@"fontSize"];
    _fontSize = fontSize;
    [self didChangeValueForKey:@"fontSize"];
    
    [self setNeedsDisplay];
}

#pragma mark - Adjust view based upon transformations

- (void)adjustScale:(CGFloat)scale
{
    [self setTransformUsingScale:1.0 angle:_angle translate:CGPointZero];
    
    CGPoint center = self.center;
    CGRect bounds = self.bounds;
    bounds.size.width *= scale;
    bounds.size.height *= scale;
    self.bounds = bounds;
    self.center = center;
    _fontSize *= scale;
    
    [self setTransformUsingScale:1.0 angle:_angle translate:CGPointZero];
    
    [self setNeedsDisplay];
}

- (void)setTransformUsingScale:(CGFloat)scale angle:(CGFloat)angle translate:(CGPoint)translate
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    transform = CGAffineTransformScale(transform, scale, scale);
    transform = CGAffineTransformTranslate(transform, translate.x, translate.y);
    
    self.transform = transform;
}

#pragma mark - Gesture Recognizers

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [gesture translationInView:gesture.view];
        [self setTransformUsingScale:1.0 angle:self.angle translate:translate];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateFailed ||
             gesture.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint translate = [gesture translationInView:[gesture.view superview]];
        self.center = CGPointMake(self.center.x + translate.x, self.center.y + translate.y);
        [self setTransformUsingScale:1.0 angle:self.angle translate:CGPointZero];
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    CGFloat scale = [gesture scale];

    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self setTransformUsingScale:scale angle:self.angle translate:CGPointZero];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateFailed ||
             gesture.state == UIGestureRecognizerStateCancelled)
    {
        [self adjustScale:scale];
    }
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gesture
{
    CGFloat angle = [gesture rotation];
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self setTransformUsingScale:1.0 angle:self.angle + angle translate:CGPointZero];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateFailed ||
             gesture.state == UIGestureRecognizerStateCancelled)
    {
        self.angle += angle;
    }
}

@end
