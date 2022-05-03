//
//  SettingsTableViewController.h
//  TwitterFon
//
//  Created by kaz on 7/14/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GurgleAppDelegate.h"
#import "ASIHTTPRequestDelegate.h"
#import "WeiboApi.h"
#import "QQWeiboApi.h"
#import "SinaWeiboApi.h"
#import "NSURL+QAdditions.h"
#import "QVerifyWebViewController.h"
#import "UIApplication+Compatible.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, 
		UITableViewDataSource, 
		UIActionSheetDelegate,
		ASIHTTPRequestDelegate>
{
	IBOutlet UITableView* settingTableView;
	BOOL needShowPostView;
	UISwitch *selectedSwitch;
	NSInteger selectedApiTag;
	UITableViewCell *selectedCell;
}
-(void) close;
-(void) cancelAccountBinding:(id)sender;
-(void) setNeedShowPostView:(BOOL) need;
-(void) verifySuccessed:(NSDictionary *)params;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end
