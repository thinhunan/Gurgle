//
//  PostView.m
//  TwitterFon
//
//  Created by kaz on 10/25/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "PostView.h"
#import "QuartzUtils.h"

#define kDeleteAnimationKey @"deleteAnimation"
#define kUndoAnimationKey   @"undoAnimation"

#define DELETE_BUTTON_INDEX 0

@implementation PostView


- (void)awakeFromNib
{
    charCount.font = [UIFont boldSystemFontOfSize:16];
	
	[textViewBackground.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [textViewBackground.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [textViewBackground.layer setBorderWidth:1.0];
	[textViewBackground.layer setCornerRadius:8.0];
	[textViewBackground.layer setMasksToBounds:YES];
    textViewBackground.clipsToBounds = YES;
}

- (void)createTransform:(BOOL)isDelete
{
    if (isDelete) {
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        CGAffineTransform transform2 = CGAffineTransformMakeTranslation(-80.0, 140.0);
        CGAffineTransform transform3 = CGAffineTransformMakeRotation (0.5);
        
        transform = CGAffineTransformConcat(transform,transform2);
        transform = CGAffineTransformConcat(transform,transform3);
        text.transform = transform;
    }
    else {
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
        CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, 0);
        CGAffineTransform transform3 = CGAffineTransformMakeRotation (0);
        
        transform = CGAffineTransformConcat(transform,transform2);
        transform = CGAffineTransformConcat(transform,transform3);
        text.transform = transform;
    }
}

- (IBAction) clear:(id) sender
{
    [UIView beginAnimations:kDeleteAnimationKey context:self]; 

    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    item.enabled = false;
    
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [self createTransform:true];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    
}

- (IBAction) undo:(id) sender
{
    text.text = undoBuffer;
    [undoBuffer release];
    undoBuffer = nil;
    [self createTransform:true];
    [self setNeedsDisplay];
    
    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    item.enabled = false;
    
    [UIView beginAnimations:kUndoAnimationKey context:self]; 
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [self createTransform:false];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

- (void)replaceButton:(UIBarButtonItem*)item index:(int)index
{
    NSMutableArray *items = [toolbar.items mutableCopy];
    [items replaceObjectAtIndex:index withObject:item];
    [toolbar setItems:items animated:false];
    [items release];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:kDeleteAnimationKey]) {
        [self createTransform:false];
        
        undoBuffer = [text.text retain];
        text.text = @"";
        charCount.textColor = [UIColor whiteColor];
        [self setNeedsDisplay];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Undo",@"Undo") style:UIBarButtonItemStyleBordered target:self action:@selector(undo:)];
        [self replaceButton:item index:DELETE_BUTTON_INDEX];
    }
    else if ([animationID isEqualToString:kUndoAnimationKey]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clear:)];
        item.style = UIBarButtonItemStyleBordered;
        [self replaceButton:item index:DELETE_BUTTON_INDEX];
    }
}

- (void)setCharCount
{
    int length = [text.text length];
    
    if (undoBuffer && length > 0) {
        [undoBuffer release];
        undoBuffer = nil;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clear:)];
        item.style = UIBarButtonItemStyleBordered;
        [self replaceButton:item index:DELETE_BUTTON_INDEX];
    }
    
    length = 140 - length;
    if (length == 140) {
        sendButton.enabled = false;
    }
    else if (length < 0) {
        sendButton.enabled = false;
        charCount.textColor = [UIColor redColor];
    }
    else {
        sendButton.enabled = true;
        charCount.textColor = [UIColor whiteColor];
    }
    
    charCount.text = [NSString stringWithFormat:@"%d", length];
}

- (void)dealloc {
    [super dealloc];
}


@end
