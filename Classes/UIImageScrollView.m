//
//  UIImageScrollView.m
//  Gurgle
//
//  Created by Think on 11-3-30.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "UIImageScrollView.h"


@implementation UIImageScrollView
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(BOOL) touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
	if (view.tag == 108) {
		[imageView removeFromSuperview];
		[self addSubview:imageView];
		return NO;
	}
	[imageView removeFromSuperview];
	[self.superview addSubview:imageView];
	return YES;
}

-(BOOL) touchesShouldCancelInContentView:(UIView *)view{
	if (view.tag == 108) {
		
		return YES;
	}
	return NO;
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
	[imageView release];
	imageView = nil;
}


@end
