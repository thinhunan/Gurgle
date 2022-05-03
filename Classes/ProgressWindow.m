//
//  SendingWindow.m
//  TwitterFon
//
//  Created by kaz on 7/22/08.
//  Copyright 2008 naan studio. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "GurgleAppDelegate.h"
#import "ProgressWindow.h"
#define kShowAnimationkey @"showAnimation"
#define kHideAnimationKey @"hideAnimation"
#define kHideAfterDelay 1

@implementation ProgressWindow

- (void) show
{
    self.windowLevel = UIWindowLevelAlert;
    //[indicator startAnimating];
    self.hidden = false;
	title.hidden = YES;
    [self makeKeyAndVisible];
}

- (void) _hide{
    self.hidden = true;
	
	CATransition *animation = [CATransition animation];
 	[animation setDelegate:nil];
    [animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromTop];
	[animation setDuration:0.1];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[navigationBar layer] addAnimation:animation forKey:kHideAnimationKey];
	title.hidden = true;
    [self resignKeyWindow];
}

- (void) hideWithTitle:(NSString *) text{
	title.text = text;
    //[indicator stopAnimating];
	
	[self performSelector:@selector(_hide) withObject:nil afterDelay:0.5];
}

-(void) hideImmediately{
    self.hidden = true;
    [self resignKeyWindow];
    //[indicator stopAnimating];
}

@end
