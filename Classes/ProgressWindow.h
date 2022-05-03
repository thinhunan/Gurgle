//
//  SendingWindow.h
//  TwitterFon
//
//  Created by kaz on 7/22/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgressWindow : UIWindow {
    //IBOutlet UIActivityIndicatorView*   indicator;
	IBOutlet UINavigationBar* navigationBar;
	IBOutlet UILabel* title;
}
- (void) show;
- (void) hideImmediately;
- (void) hideWithTitle:(NSString *) text;

@end
