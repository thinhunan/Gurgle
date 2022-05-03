//
//  UIApplication+Compatible.m
//  Gurgle
//
//  Created by Think on 11-4-30.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "UIApplication+Compatible.h"


@implementation UIApplication(Compatible)
-(void) setStatusBarHiddenCompatibility:(BOOL) hidden{
	if ([self respondsToSelector:@selector(setStatusBarOrientation:animated:)]) {
		[self setStatusBarHidden:hidden animated:YES];
	}
	else {
		[self setStatusBarHidden:hidden];
	}
	
}
@end
