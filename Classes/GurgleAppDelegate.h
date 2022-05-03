//
//  GurgleAppDelegate.h
//  Gurgle
//
//  Created by Think on 11-3-26.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "UIApplication+Compatible.h"
@class RootViewController;

@interface GurgleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
	RootViewController *rootViewController;
	
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
+ (GurgleAppDelegate*)getAppDelegate;
- (void)alert:(NSString*)title message:(NSString*)detail;
@end

