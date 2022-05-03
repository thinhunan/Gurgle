//
//  PostView.h
//  TwitterFon
//
//  Created by kaz on 10/25/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostView : UIView {
	IBOutlet UIView *textViewBackground;
    IBOutlet UITextView*        text;
    IBOutlet UIToolbar*         toolbar;
    IBOutlet UIBarButtonItem*   sendButton;
    IBOutlet UILabel*           charCount;
    
    NSString*                   undoBuffer;
    
}


- (IBAction) clear:(id)sender;

- (void)setCharCount;

@end
