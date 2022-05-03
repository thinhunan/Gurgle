//
//  CalloutLabel.m
//  Gurgle
//
//  Created by Think on 11-3-27.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "CalloutLabel.h"
#import "CalloutView.h"
#import "GurgleAppDelegate.h"
#import "RootViewController.h"


@implementation CalloutLabel
-(void) autoAdjustFontSize{
	static int size[] = { 200, 144, 96, 72, 64, 48, 36, 24, 18, 14, 13, 12, 11, 10 }; 
	static int array_length = 14;	
	UIFont *font = [UIFont fontWithName:self.font.fontName size:size[0]];
	NSString *text = self.text;
	CGFloat maxWidth = self.frame.size.width;
	CGFloat maxHeight = self.frame.size.height;
	CGSize constraintSize =  CGSizeMake(maxWidth,MAXFLOAT);
	for (int i = 1; i < array_length; i ++) {
		CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize	lineBreakMode:UILineBreakModeWordWrap];
		if (labelSize.width <= maxWidth && labelSize.height <= maxHeight) {
			break;
		}
		font = [font fontWithSize:size[i]];
	}
	self.font = font;
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.textAlignment = UITextAlignmentCenter;
		self.textColor = [UIColor blackColor];
		self.lineBreakMode = UILineBreakModeWordWrap;
		self.numberOfLines = 0;
		self.userInteractionEnabled = NO;
		[self autoAdjustFontSize];
    }
    return self;
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
