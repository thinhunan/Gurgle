//
//  ArrowCalloutView.m
//  Gurgle
//
//  Created by Think on 11-3-27.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "ArrowCalloutView.h"


@implementation ArrowCalloutView


-(id) initWithFrame:(CGRect)frame text:(NSString *) text{
	UIImage *sharp = [UIImage imageNamed:@"arrow_mask.png"];
	UIImage *mask = [UIImage imageNamed:@"mask_for_arrow.png"];
    self = [super initWithFrame:frame sharp:sharp mask:mask];
    if (self) {
        [super setText:text];
		[self _adjustTextFrameWhenFliped];
    }
    return self;
}


- (void) _adjustTextFrameWhenFliped{
	
	CGFloat width = originalSize.width;
	CGFloat height = originalSize.height;
	CGRect textFrame = CGRectMake(36.0/190.0 * width, 
								  43.0/144.0 * height, 
								  110.0/190.0 *width, 
								  63.0/144.0 *height);
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
