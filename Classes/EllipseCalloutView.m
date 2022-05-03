//
//  EllipseCalloutView.m
//  Gurgle
//
//  Created by Think on 11-3-27.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "EllipseCalloutView.h"
@implementation EllipseCalloutView

-(id) initWithFrame:(CGRect)frame text:(NSString *) text{
	UIImage *sharp = [UIImage imageNamed:@"ellipse_mask.png"];
	UIImage *mask = [UIImage imageNamed:@"mask_for_ellipse.png"];
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
	CGRect textFrame = CGRectMake(35.0/190.0 * width, 
								  30.0/144.0 * height, 
								  122.0/190.0 *width, 
								  80.0/144.0 *height);
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
