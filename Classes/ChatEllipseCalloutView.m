//
//  ChatEllipseCalloutView.m
//  Gurgle
//
//  Created by Think on 11-3-26.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "ChatEllipseCalloutView.h"
#import "CalloutView.h"

@implementation ChatEllipseCalloutView


-(id) initWithFrame:(CGRect)frame text:(NSString *) text{
	UIImage *sharp = [UIImage imageNamed:@"chat_ellipse_mask.png"];
	UIImage *mask = [UIImage imageNamed:@"mask_for_ellipse.png"];
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
	CGRect textFrame = CGRectMake(30.0/190.0 * width, 
					  19.0/144.0 * height, 
					  127.0/190.0 *width, 
					  86.0/144.0 *height);
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
