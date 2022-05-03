//
//  CalloutTextView.m
//  Gurgle
//
//  Created by Think on 11-3-27.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "CalloutTextView.h"
#import "GurgleAppDelegate.h"
#import "RootViewController.h"
#import "CalloutLabel.h"

@implementation CalloutTextView
- (void) _initView{
	self.backgroundColor = [UIColor clearColor];
	self.textAlignment = UITextAlignmentCenter;
	self.returnKeyType = UIReturnKeyDefault;
	self.enablesReturnKeyAutomatically = YES;
	self.contentMode = UIViewContentModeCenter;
	self.scrollEnabled = YES;
	self.autocorrectionType = UITextAutocorrectionTypeNo;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.pagingEnabled = NO;
	self.font = [UIFont fontWithName:@"Helvetica" size:17];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initView];
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
/*  ios 3.1 dont support this
- (void) _clear{
	self.text = @"";
}

- (void) _close{
	NSRange textRange = NSMakeRange(0, 0);
	self.selectedRange = textRange;
	[self resignFirstResponder];
	CalloutView *selectedCallout = [[[GurgleAppDelegate getAppDelegate] 
									 rootViewController]selectedCallout];
	[selectedCallout setUserInteractionEnabled:YES];
	self.hidden = YES;
	selectedCallout.label.hidden = NO;
	[selectedCallout showAndMoveControllingButtonToSide];
}

- (UIView *)inputAccessoryView {
	CGRect accessFrame = CGRectMake(0.0, 0.0, 320.0, 44.0);
	UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:accessFrame] autorelease];
	
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] 
									initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered
									//initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
									target:self action:@selector(_clear)];
	UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]
									initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
									target:nil action:nil];
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
									target:self action:@selector(_close)];
	
	[toolbar setItems:[NSArray arrayWithObjects:clearButton,spaceButton,closeButton,nil]];
	
	[clearButton release];
	[spaceButton release];
	[closeButton release];
	
    return toolbar;
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
