//
//  Callout.m
//  Gurgle
//
//  Created by Think on 11-3-26.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "CalloutView.h"
#import "GurgleAppDelegate.h"
#import "RootViewController.h"
#import "CalloutTextView.h"
#import "CalloutLabel.h"
#import "ImageSet.h"

@implementation CalloutView

@synthesize label;

-(void) _logFrame:(CGRect) frame{
	NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

-(BOOL) _isNoDirection{
	return NO;
}

-(void) setAllControlViewHide:(BOOL)hidden{
	GurgleAppDelegate *delegate = [GurgleAppDelegate getAppDelegate];
	RootViewController *rootViewController = delegate.rootViewController;
	rootViewController.flipVerticalButton.hidden 
	= rootViewController.flipHorizontalButton.hidden 
	= rootViewController.deleteButton.hidden 
	= rootViewController.editButton.hidden = hidden;
}

-(void) showAndMoveControllingButtonToSide{
	GurgleAppDelegate *delegate = [GurgleAppDelegate getAppDelegate];
	RootViewController *rootViewController = delegate.rootViewController;
	CGFloat x = self.frame.origin.x,
	y = self.frame.origin.y,
	w = self.frame.size.width,
	h = self.frame.size.height,
	margin = 8;
	CGPoint center = CGPointMake(x - margin, y -margin);
	rootViewController.deleteButton.center = center;
	center = CGPointMake(x + w + margin, y -margin);
	rootViewController.editButton.center = center;
	rootViewController.deleteButton.hidden 
	= rootViewController.editButton.hidden = NO;
	[rootViewController.deleteButton.superview bringSubviewToFront:rootViewController.deleteButton];
	[rootViewController.editButton.superview bringSubviewToFront:rootViewController.editButton];
	if (![self _isNoDirection]) {
		center = CGPointMake(x -margin, y + h + margin);
		[[rootViewController flipVerticalButton] setCenter:center];
		center = CGPointMake(x + w + margin, y + h + margin);
		rootViewController.flipHorizontalButton.center = center;	
		rootViewController.flipVerticalButton.hidden 
		= rootViewController.flipHorizontalButton.hidden = NO;
		[rootViewController.flipVerticalButton.superview bringSubviewToFront:rootViewController.flipVerticalButton];
		[rootViewController.flipHorizontalButton.superview bringSubviewToFront:rootViewController.flipHorizontalButton];
	}
	else {
		rootViewController.flipVerticalButton.hidden 
		= rootViewController.flipHorizontalButton.hidden = YES;
	}


}

-(UIImage *)_getBackgroundImage{
	UIImage *sharp = [ImageSet colorizeImage:sharpImage withColor:backgroundColor];
	return sharp;
}

#pragma mark -
- (id)initWithFrame:(CGRect)frame sharp:(UIImage *) sharp mask:(UIImage *) mask {
    
    self = [super initWithFrame:frame];
    if (self) {
		sharpImage = sharp;
		maskImage = mask;
		
		// touch properties
        self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		self.exclusiveTouch = NO;
		touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
		originalTransform = CGAffineTransformIdentity;
		originalSize = self.bounds.size;
		
		//sharp & mask
		backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
		backgroundView.backgroundColor = [UIColor clearColor];
		backgroundColor = [UIColor lightGrayColor];
		backgroundView.image = [self _getBackgroundImage];
		UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		maskView.image = maskImage;
		[backgroundView addSubview:maskView];
		[maskView release];
		[self addSubview:backgroundView];
		self.backgroundColor = [UIColor clearColor];
		
		
		label = [[CalloutLabel alloc] initWithFrame:self.bounds];
		label.textAlignment = UITextAlignmentCenter;
		label.opaque = YES;
		[self addSubview:label];
		[self bringSubviewToFront:label];
		horizontalFliped = verticalFliped = NO;
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame text:(NSString *) text{
	UIImage *sharp = [UIImage imageNamed:@"chat_ellipse_mask.png"];
	UIImage *mask = [UIImage imageNamed:@"mask_for_ellipse.png"];
    self = [self initWithFrame:frame sharp:sharp mask:mask];
    if (self) {
        [self setText:text];
		[self _adjustTextFrameWhenFliped];
    }
    return self;
}

-(void) setBackgroundColor:(UIColor *) color{
	backgroundColor = color;
	backgroundView.image = [self _getBackgroundImage];
}
-(UIColor *) backgroundColor{
	return backgroundColor;
}
-(void) setText:(NSString *) text{
	label.text = text;
	[label autoAdjustFontSize];
}

-(NSString *)text{
	return label.text;
}

-(void) setTextFrame:(CGRect)frame{
	label.frame = frame;
	[label autoAdjustFontSize];
}

-(void) setTextColor:(UIColor *)color{
	[label setTextColor:color];
}

-(void) _flip:(UIView *) view a:(CGFloat) a d:(CGFloat) d{
	CGPoint originalCenter = view.center;
	view.center = CGPointZero;
	view.transform = CGAffineTransformConcat(view.transform, 
											  CGAffineTransformMake(a, 0, 0, d, 0, 0));
	view.center = originalCenter;
}

- (void) setOnlyFlipTransform{
	CGFloat a = horizontalFliped?-1:1;
	CGFloat d = verticalFliped? -1:1;
	self.transform = CGAffineTransformIdentity;
	CGPoint originalCenter = self.center;
	self.center = CGPointZero;
	self.transform = CGAffineTransformMake(a, 0, 0, d, 0, 0);
	self.center = originalCenter;
	originalTransform = self.transform;
	[self showAndMoveControllingButtonToSide];
}
- (void) flipHorizontal{
	horizontalFliped = !horizontalFliped;
	
	CGPoint originalCenter = self.center;
	self.center = CGPointZero;
	self.transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
	self.transform = CGAffineTransformConcat(self.transform,originalTransform);
	originalTransform = self.transform;
	self.center = originalCenter;
	
	[self _flip:label a:-1 d:1];
	[self _adjustTextFrameWhenFliped];
}

- (void) flipVertical{
	verticalFliped = !verticalFliped;
	
	CGPoint originalCenter = self.center;
	self.center = CGPointMake(0,0);
	self.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	self.transform = CGAffineTransformConcat(self.transform,originalTransform);
	originalTransform = self.transform;
	self.center = originalCenter;
	
	[self _flip:label a:1 d:-1];
	[self _adjustTextFrameWhenFliped];
}
- (void) _adjustTextFrameWhenFliped{}


#pragma mark -
#pragma mark Rotation & pinch

// Create an incremental transform matching the current touch set
- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches 
{
	// Sort the touches by their memory addresses
    NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSInteger numTouches = [sortedTouches count];
    
	// If there are no touches, simply return identify transform.
	if (numTouches == 0) return CGAffineTransformIdentity;
	
	// Handle single touch as a translation
	if (numTouches == 1) {
        UITouch *touch = [sortedTouches objectAtIndex:0];
        CGPoint beginPoint = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
        CGPoint currentPoint = [touch locationInView:self.superview];
		return CGAffineTransformMakeTranslation(currentPoint.x - beginPoint.x, currentPoint.y - beginPoint.y);
	}
	
	// If two or more touches, go with the first two (sorted by address)
	UITouch *touch1 = [sortedTouches objectAtIndex:0];
	UITouch *touch2 = [sortedTouches objectAtIndex:1];
	
    CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch1);
    CGPoint currentPoint1 = [touch1 locationInView:self.superview];
    CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch2);
    CGPoint currentPoint2 = [touch2 locationInView:self.superview];
	
	double layerX = self.center.x;
	double layerY = self.center.y;
	
	double x1 = beginPoint1.x - layerX;
	double y1 = beginPoint1.y - layerY;
	double x2 = beginPoint2.x - layerX;
	double y2 = beginPoint2.y - layerY;
	double x3 = currentPoint1.x - layerX;
	double y3 = currentPoint1.y - layerY;
	double x4 = currentPoint2.x - layerX;
	double y4 = currentPoint2.y - layerY;
	
	// Solve the system:
	//   [a b t1, -b a t2, 0 0 1] * [x1, y1, 1] = [x3, y3, 1]
	//   [a b t1, -b a t2, 0 0 1] * [x2, y2, 1] = [x4, y4, 1]
	
	double D = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
	if (D < 0.1) {
        return CGAffineTransformMakeTranslation(x3-x1, y3-y1);
    }
	
	double a = (y1-y2)*(y3-y4) + (x1-x2)*(x3-x4);
	double b = (y1-y2)*(x3-x4) - (x1-x2)*(y3-y4);
	double tx = (y1*x2 - x1*y2)*(y4-y3) - (x1*x2 + y1*y2)*(x3+x4) + x3*(y2*y2 + x2*x2) + x4*(y1*y1 + x1*x1);
	double ty = (x1*x2 + y1*y2)*(-y4-y3) + (y1*x2 - x1*y2)*(x3-x4) + y3*(y2*y2 + x2*x2) + y4*(y1*y1 + x1*x1);
	
    return CGAffineTransformMake(a/D, -b/D, b/D, a/D, tx/D, ty/D);
}

// Cache where each touch started
- (void)cacheBeginPointForTouches:(NSSet *)touches 
{
	for (UITouch *touch in touches) {
		CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
		if (point == NULL) {
			point = (CGPoint *)malloc(sizeof(CGPoint));
			CFDictionarySetValue(touchBeginPoints, touch, point);
		}
		*point = [touch locationInView:self.superview];
	}
}

// Clear out touches from the cache
- (void)removeTouchesFromCache:(NSSet *)touches 
{
    for (UITouch *touch in touches) {
        CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
        if (point != NULL) {
            free((void *)CFDictionaryGetValue(touchBeginPoints, touch));
            CFDictionaryRemoveValue(touchBeginPoints, touch);
        }
    }
}

// Limit zoom to a max and min value
- (void) setConstrainedTransform: (CGAffineTransform) aTransform
{
	self.transform = aTransform;
	CGAffineTransform concat;
	CGSize asize = self.frame.size;
	
	if (asize.width > MAXZOOM * originalSize.width)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale((MAXZOOM * originalSize.width / asize.width), 1.0f));
		self.transform = concat;
	}
	else if (asize.width < MINZOOM * originalSize.width)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale((MINZOOM * originalSize.width / asize.width), 1.0f));
		self.transform = concat;
	}
	if (asize.height > MAXZOOM * originalSize.height)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1.0f, (MAXZOOM * originalSize.height / asize.height)));
		self.transform = concat;
	}
	else if (asize.height < MINZOOM * originalSize.height)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1.0f, (MINZOOM * originalSize.height / asize.height)));
		self.transform = concat;
	}
	
	// force boundary checks
	
	/*
	 if (self.frame.origin.x < 0)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-self.frame.origin.x, 0.0f));
	 self.transform = concat;
	 }
	 
	 if (self.frame.origin.y < 0)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(0.0f, -self.frame.origin.y));
	 self.transform = concat;
	 }
	 
	 float dx = (self.frame.origin.x + self.frame.size.width) - self.superview.frame.size.width;
	 if (dx > 0.0f)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-dx, 0.0f));
	 self.transform = concat;
	 }
	 
	 float dy = (self.frame.origin.y + self.frame.size.height) - self.superview.frame.size.height;
	 if (dy > 0.0f)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(0.0f, -dy));
	 self.transform = concat;
	 }
	 */
}

// Apply touches to create transform
- (void)updateOriginalTransformForTouches:(NSSet *)touches 
{
    if ([touches count] > 0) {
        CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:touches];
        [self setConstrainedTransform:CGAffineTransformConcat(originalTransform, incrementalTransform)];
		originalTransform = self.transform;
    }
}

// At start, store the touch begin points and set an original transform
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[[self superview] bringSubviewToFront:self];
	[[[GurgleAppDelegate getAppDelegate] rootViewController] setSelectedCallout:self];
	//set this view to selectedBallonView
	//[[self superview] touchesBegan:touches withEvent:event];
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
	
	//move the 4 operating buttons close the current view
	[self showAndMoveControllingButtonToSide];
}


// During movement, update the transform to match the touches
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
	[self setConstrainedTransform:CGAffineTransformConcat(originalTransform, incrementalTransform)];
	
	//move the 4 operating buttons close the current view
	[self showAndMoveControllingButtonToSide];
	[self setAllControlViewHide:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

// Finish by removing touches, handling double-tap requests
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];
	
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            [self.superview bringSubviewToFront:self];
        }
    }
	
    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
	
	//move the 4 operating buttons close the current view
	[self showAndMoveControllingButtonToSide];
	
	//拖到边缘删除气泡
//	if([touches count] == 1){
//		CGFloat boundaryArea = 35;
//		if (self.frame.origin.x + self.frame.size.width < boundaryArea 
//			||self.superview.frame.size.width - self.frame.origin.x < boundaryArea
//			||self.frame.origin.y + self.frame.size.height < boundaryArea
//			||self.superview.frame.size.height - self.frame.origin.y < boundaryArea) {
//			[self performSelector:@selector(deleteView) withObject:nil afterDelay:.1];
//		}
//	}
	
}

// Redirect cancel to ended
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];
	
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            [self.superview bringSubviewToFront:self];
        }
    }
	
    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
	
	//move the 4 operating buttons close the current view
	[self showAndMoveControllingButtonToSide];
}

#pragma mark -

- (void)dealloc {
	if (touchBeginPoints) CFRelease(touchBeginPoints);
	[label release];
	[backgroundView release];
	[super dealloc];
}


@end
