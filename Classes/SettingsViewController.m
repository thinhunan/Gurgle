//
//  SettingsTableViewController.m
//  TwitterFon
//
//  Created by kaz on 7/14/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "SettingsViewController.h"
#import "RootViewController.h"
#import "GurgleAppDelegate.h"

#define QQRowIndex 1
#define SinaRowIndex 0
#define QQRowTag 200
#define SinaRowTag 100

@implementation SettingsViewController

-(void) _requestToken{
	WeiboApi *api;
	if (selectedApiTag == SinaRowTag) {
		api = [[SinaWeiboApi alloc] init];
	}
	else {
		api = [[QQWeiboApi alloc] init];
	}
	if (![api isAuthorized]) {
		ASIHTTPRequest *requestToken = [api getRequestToken];
		[requestToken setDelegate:self];
		[requestToken startAsynchronous];
	}
	[api release];
}

- (void) setNeedShowPostView:(BOOL) need{
	needShowPostView = need;
}

-(void) close{
	[[UIApplication sharedApplication] setStatusBarHiddenCompatibility:YES];
	[self dismissModalViewControllerAnimated:!needShowPostView];
	[[[GurgleAppDelegate getAppDelegate] rootViewController] closeSettingView];
}

-(void) cancelAccountBinding:(id)sender{
	selectedCell = nil;
	selectedSwitch = (UISwitch *)sender;
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil 
														delegate:self 
											   cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") 
										  destructiveButtonTitle:NSLocalizedString(@"Unbind",@"Unbind") 
											   otherButtonTitles:nil];
	[action setTag:selectedSwitch.tag];
	[action showInView:self.view];
	[action release];
}

-(void) verifySuccessed:(NSDictionary *)params{
	NSString *accessTokenKey = [params objectForKey:@"oauth_token"];
	NSString *accessTokenSecret = [params objectForKey:@"oauth_token_secret"];
	if (selectedApiTag == SinaRowTag) {
		[SinaWeiboApi setTokenKey:accessTokenKey];
		[SinaWeiboApi setTokenSecret:accessTokenSecret];
	}
	else {
		[QQWeiboApi setTokenKey:accessTokenKey];
		[QQWeiboApi setTokenSecret:accessTokenSecret];
	}
	[[self navigationController] popViewControllerAnimated:YES];
	[settingTableView reloadData];
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

-(void) actionSheet:(UIActionSheet *)actionSheet 
didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex){
		if (selectedCell) {
			[self _requestToken];
		}
		else {
			if(actionSheet.tag == SinaRowTag ) {
				[SinaWeiboApi setTokenKey:nil];
				[SinaWeiboApi setTokenSecret:nil];
				[settingTableView reloadData];
			}
			else{
				[QQWeiboApi setTokenKey:nil];
				[QQWeiboApi setTokenSecret:nil];
				[settingTableView reloadData];
			}
		}
	}
	else {
		if (selectedSwitch) {
			[selectedSwitch setOn:YES animated:YES];
		}
		if(selectedCell)
		{
			[selectedCell setSelected:NO animated:YES];
		}
	}
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    return NSLocalizedString(@"Account binding",@"account");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (UISwitch *) _getCancelBindingSwithWithTag:(NSInteger) tag{
	CGRect switchFrame = CGRectMake(206, 8, 94, 27);	
	UISwitch *switchOn = [[[UISwitch alloc] initWithFrame:switchFrame] autorelease];
	switchOn.on = YES;
	switchOn.tag = tag;
	[switchOn addTarget:self action:@selector(cancelAccountBinding:) forControlEvents:UIControlEventValueChanged];
	return switchOn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = @"TableCellIdentifier";
	
	UITableViewCell *cell =  nil;//[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
								reuseIdentifier:cellIdentifier] autorelease];
	}
						
	if (indexPath.row == SinaRowIndex) {
		UIImage *icon = [UIImage imageNamed:@"sina_icon_24.png"];
		cell.imageView.image = icon;
		cell.textLabel.text = @"Sina";
		NSString *sinaTokenKey = [SinaWeiboApi getTokenKey];
		if (sinaTokenKey && ![sinaTokenKey isEqualToString:@""]) {
			UISwitch *switchOn = [self _getCancelBindingSwithWithTag:SinaRowTag];
			[cell addSubview:switchOn];
			cell.detailTextLabel.text = NSLocalizedString(@"Bound",@"Bound");
		}
		else {
			cell.detailTextLabel.text = NSLocalizedString(@"Unbound",@"Unbound");
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}

	}
	else {
		cell.imageView.image = [UIImage imageNamed:@"qq_icon_24.png"];
		cell.textLabel.text = @"QQ";
		NSString *qqTokenKey = [QQWeiboApi getTokenKey];
		if (qqTokenKey && ![qqTokenKey isEqualToString:@""]) {
			UISwitch *switchOn = [self _getCancelBindingSwithWithTag:QQRowTag];
			[cell addSubview:switchOn];
			cell.detailTextLabel.text = NSLocalizedString(@"Bound",@"Bound");
		}
		else {
			cell.detailTextLabel.text = NSLocalizedString(@"Unbound",@"Unbound");
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == SinaRowIndex) {
		selectedApiTag = SinaRowTag;
		SinaWeiboApi *sinaApi = [[SinaWeiboApi alloc] init];
		if (![sinaApi isAuthorized]) {
			[self _requestToken];
			selectedCell.detailTextLabel.text = NSLocalizedString(@"Loading",@"Loading");
		}
		else {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		[sinaApi release];
	}
	else {
		selectedApiTag = QQRowTag;
		QQWeiboApi *qqApi = [[QQWeiboApi alloc] init];
		if (![qqApi isAuthorized]) {
			[self _requestToken];
			selectedCell.detailTextLabel.text = NSLocalizedString(@"Loading",@"Loading");
		}
		else {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		[qqApi release];
	}

}
#pragma mark -
#pragma mark ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request{
	NSString *retString = [request responseString];
	NSDictionary *params = [NSURL parseURLQueryString:retString];
	NSString *requestTokenKey = [params objectForKey:@"oauth_token"];
	NSString *requestTokenSecret = [params objectForKey:@"oauth_token_secret"];
	WeiboApi *api;
	if (selectedApiTag == SinaRowTag) {
		[SinaWeiboApi setRequestTokenKey:requestTokenKey];
		[SinaWeiboApi setRequestTokenSecret:requestTokenSecret];
		api = [[SinaWeiboApi alloc] init];
	}
	else {
		[QQWeiboApi setRequestTokenKey:requestTokenKey];
		[QQWeiboApi setRequestTokenSecret:requestTokenSecret];
		api = [[QQWeiboApi alloc] init];
	}

	selectedCell.detailTextLabel.text = @"unbound";
	[selectedCell setSelected:NO];
	selectedCell = nil;
	QVerifyWebViewController *verifyWebController = [[QVerifyWebViewController alloc] initWithApi:api delegate:self];
	[verifyWebController setVerifySuccessedSelector:@selector(verifySuccessed:)];
	[[self navigationController] pushViewController:verifyWebController animated:YES];
	[verifyWebController release];
	[api release];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
	selectedSwitch = nil;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Connect timeout",@"Connect timeout")
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") 
											   destructiveButtonTitle:nil 
													otherButtonTitles:NSLocalizedString(@"Retry",@"Retry"),nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
	
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad{
	[super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarHiddenCompatibility:NO];
	[[[self navigationController] navigationBar] setFrame:CGRectMake(0, 20, 320, 44)];
	
	self.view.frame = CGRectMake(0, 20, 320,460);
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back",@"Back") 
																 style:UIBarButtonItemStyleBordered 
																target:self 
																action:@selector(close)];
	
	self.navigationItem.leftBarButtonItem = backItem;
	[backItem release];
	
    self.navigationItem.title = NSLocalizedString(@"Settings",@"Settings");
}

-(void) viewDidUnload{
}

- (void)dealloc {
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end


