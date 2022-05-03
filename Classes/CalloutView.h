//
//  Callout.h
//  Gurgle
//
//  Created by Think on 11-3-26.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class GurgleAppDelegate;
@class RootViewController;
@class CalloutTextView;
@class CalloutLabel;
#define MAXZOOM 3.0f
#define MINZOOM 0.5f

@interface UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id)obj;
@end

@implementation UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id) obj 
{
    if ((void *) self < (void *) obj) return NSOrderedAscending;
    else if ((void *) self == (void *) obj) return NSOrderedSame;
	else return NSOrderedDescending;
}
@end

@interface CalloutView:UIView <UITextViewDelegate>{
    CFMutableDictionaryRef touchBeginPoints;
	CGSize originalSize;
	CGAffineTransform originalTransform;
	
	CalloutLabel *label;
	UIImageView *backgroundView;
	UIColor *backgroundColor;
	UIImage *sharpImage;
	UIImage *maskImage;
	BOOL horizontalFliped;
	BOOL verticalFliped;
}
@property(nonatomic,assign) CalloutLabel *label;
- (id)initWithFrame:(CGRect)frame sharp:(UIImage *) sharp mask:(UIImage *) mask;
- (id) initWithFrame:(CGRect)frame text:(NSString *) text;
- (void)setText:(NSString *) text;
- (NSString *) text;
- (void) setTextFrame:(CGRect)frame;
- (void) setTextColor:(UIColor *) color;
- (void) flipHorizontal;
- (void) flipVertical;
- (void) setOnlyFlipTransform;
- (void) _adjustTextFrameWhenFliped;
- (void) showAndMoveControllingButtonToSide;
@end
