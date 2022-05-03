//
//  RectangleCalloutView.m
//  Gurgle
//
//  Created by Think on 11-3-27.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "RectangleCalloutView.h"


@implementation RectangleCalloutView


-(id) initWithFrame:(CGRect)frame text:(NSString *) text{
	UIImage *sharp = [UIImage imageNamed:@"rectangle_mask.png"];
	UIImage *mask = [UIImage imageNamed:@"mask_for_rectangle.png"];
    self = [super initWithFrame:frame sharp:sharp mask:mask];
    if (self) {
        [super setText:text];
		[self _adjustTextFrameWhenFliped];
    }
    return self;
}
-(BOOL) _isNoDirection{
	return YES;
}

- (void) _adjustTextFrameWhenFliped{
	
	CGFloat width = originalSize.width;
	CGFloat height = originalSize.height;
	CGRect textFrame = CGRectMake(23.0/190.0 * width, 
								  19.0/144.0 * height, 
								  146.0/190.0 *width, 
								  99.0/144.0 *height);
	[self setTextFrame:textFrame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
