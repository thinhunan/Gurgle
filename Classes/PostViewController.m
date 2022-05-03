//
//  PostViewController.m
//  TwitterFon
//
//  Created by kaz on 7/16/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "RootViewController.h"
#import "PostView.h"
#import "REString.h"
#import "GurgleAppDelegate.h"
#import "UILoadingView.h"

#ifndef kShowAnimationkey
#define kShowAnimationkey   @"showAnimation"
#define kHideAnimationKey   @"hideAnimation"
#endif


@implementation PostViewController
@synthesize navigation;
@synthesize sinaPostCell;
@synthesize qqPostCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
		sinaApi = [[SinaWeiboApi alloc] init];
		qqApi = [[QQWeiboApi alloc] init];
		text.font           = [UIFont systemFontOfSize:18];
		self.view.hidden    = true;
		textRange.location  = [text.text length];
		textRange.length    = 0;
    }
    return self;
}

- (void) setSelectedPhoto:(UIImage *) image{
	if (selectedPhoto != nil) {
		[selectedPhoto release];
	}
	selectedPhoto = image;
	[selectedPhoto retain];
	
	CGRect frame = CGRectMake(0, 0, 64, 64);
	UIGraphicsBeginImageContext(frame.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextConcatCTM(ctx, CGAffineTransformMake(1, 0, 0, -1, 0, 64));
	CGFloat x,y,width,height,ratio;
	if(selectedPhoto.size.width > selectedPhoto.size.height){
		width = 64;
		x = 0;
		ratio = 64 / selectedPhoto.size.width;
		height = selectedPhoto.size.height * ratio;
		y = (64-height)/2;
	}
	else {
		height = 64;
		y = 0;
		ratio = 64 / selectedPhoto.size.height;
		width = selectedPhoto.size.width * ratio;
		x = (64-width)/2;
	}

	CGContextDrawImage(ctx, CGRectMake(x, y, width, height), selectedPhoto.CGImage);
	CGContextDrawImage(ctx, CGRectMake(8, 48, 16, 16), [UIImage imageNamed:@"pin.png"].CGImage);
	
	UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
	pinButton.frame = CGRectMake(0, 0, 32, 32);
	[pinButton setBackgroundImage:thumbImage forState:UIControlStateNormal];
	[pinButton setBackgroundImage:thumbImage forState:UIControlStateDisabled];
	[pinButton setEnabled:NO];	
	UIColor *backgroundColor = [UIColor whiteColor];
	[pinButton.layer setBackgroundColor:[backgroundColor CGColor]];
	UIColor *borderColor = [[UIColor alloc] initWithRed:88.0/255.0 green:105.0/255.0 blue:127.0/255.0 alpha:1.0];
    [pinButton.layer setBorderColor:[borderColor CGColor]];
	[borderColor release];
	[pinButton.layer setBorderWidth:1.0];
	[pinButton.layer setCornerRadius:5.0];
	[pinButton.layer setMasksToBounds:YES];
    pinButton.clipsToBounds = YES;
	
	//pinButton.transform = CGAffineTransformMakeRotation(0.25 * M_PI);
	
	UIBarButtonItem *pinBarItem = [[UIBarButtonItem alloc] initWithCustomView:pinButton];
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithArray:toolbar.items];

	
	if ([buttons count] == 2) {
		[buttons addObject:pinBarItem];
	}
	else {
		[buttons replaceObjectAtIndex:2 withObject:pinBarItem];
	}

	[toolbar setItems:buttons];
	[buttons release];
	[pinBarItem release];
}

-(void) viewDidLoad{
	[progressWindow setHidden:YES];
}
-(void) viewDidUnload{
	sinaPostCell =nil;
	qqPostCell =nil;
	
	qqPostRequest = nil;
	sinaPostRequest = nil;
}
- (void)dealloc 
{
	if (selectedPhoto) {
		[selectedPhoto release];
	}
	selectedPhoto = nil;
	if (sinaPostRequest){
		[sinaPostRequest clearDelegatesAndCancel];
		[sinaPostRequest release];
	}
	if (qqPostRequest){
		[qqPostRequest clearDelegatesAndCancel];
		[qqPostRequest release];
	}
	
	[sinaPostCell release];
	[qqPostCell release];
	
	[sinaApi release];
	[qqApi release];
	[super dealloc];
}

-(ASIHTTPRequest *) _getSinaRequest{
	ASIHTTPRequest *request = [sinaApi uploadWithImage:selectedPhoto status:text.text];
	request.delegate = self;
	[request retain];
	return request;
}

-(ASIHTTPRequest *) _getQQRequest{
	ASIHTTPRequest *request = [qqApi uploadWithImage:selectedPhoto status:text.text];
	request.delegate = self;
	[request retain];
	return request;
}

-(IBAction) sinaPostRetryButtonPressed:(id)sender{
	sinaPosted = NO;
	if (sinaPostRequest){
		if(![sinaPostRequest isFinished]) {
			[sinaPostRequest clearDelegatesAndCancel];
		}
		[sinaPostRequest release];
	}
	sinaPostRequest = [self _getSinaRequest];
	[sinaPostRequest startAsynchronous];
	
	//[sinaPostRequest retryUsingNewConnection];
	[sinaPostRetryButton setHidden:YES];
	sinaHasErrorImageView.hidden = YES;
	sinaPostStatusLabel.text = @"";
	sinaPostStatusLabel.textColor = [UIColor darkGrayColor];
	sinaPostActivity.hidden = NO;
	[sinaPostActivity startAnimating];
}

-(IBAction) qqPostRetryButtonPressed:(id)sender{
	qqPosted = NO;
	
	if (qqPostRequest){
		if(![qqPostRequest isFinished]) {
			[qqPostRequest clearDelegatesAndCancel];
		}
		[qqPostRequest release];
	}
	qqPostRequest = [self _getQQRequest];
	[qqPostRequest startAsynchronous];
	
	//[qqPostRequest retryUsingNewConnection];
	[qqPostRetryButton setHidden:YES];
	qqHasErrorImageView.hidden = YES;
	qqPostStatusLabel.text = @"";
	qqPostStatusLabel.textColor = [UIColor darkGrayColor];
	qqPostActivity.hidden = NO;
	[qqPostActivity startAnimating];
}

- (void)edit
{
	[navigation setNavigationBarHidden:YES];
    [navigation.view addSubview:self.view];
    [postView setCharCount];
    
    [postView setNeedsLayout];
    [postView setNeedsDisplay];
	
    
    self.view.hidden = false;
    didPost = false;
	[text becomeFirstResponder];
    text.selectedRange = textRange;
    
    CATransition *animation = [CATransition animation];
 	[animation setDelegate:self];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.3];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:kShowAnimationkey];
	
	[[UIApplication sharedApplication] setStatusBarHiddenCompatibility:NO];
	CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
	CGAffineTransform statusBarTransform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
	[self.view setTransform:statusBarTransform];

}

- (void)post
{
    [self edit];
}


- (IBAction) close: (id) sender{
    [text resignFirstResponder];
	[[UIApplication sharedApplication] setStatusBarHiddenCompatibility:YES];
    self.view.hidden = true;
    
	CATransition *animation = [CATransition animation];
 	[animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
	[animation setDuration:0.3];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[self.view layer] addAnimation:animation forKey:kHideAnimationKey];
	text.text = NSLocalizedString(@"Share pic #Gurgle# ",@"share picture #Gurgle# ");
}

- (void)cancel: (id)sender{
	if(qqPostRequest){
		if(![qqPostRequest isFinished]){
			[qqPostRequest clearDelegatesAndCancel];
		}
		[qqPostRequest release];
	}
	if(sinaPostRequest){
		if(![sinaPostRequest isFinished]){
			[sinaPostRequest clearDelegatesAndCancel];
		}
		[sinaPostRequest release];
	}
	qqPostRequest = nil;
	sinaPostRequest = nil;
	sinaPostRetryButton.hidden = YES;
	sinaHasErrorImageView.hidden = YES;
	sinaPostStatusLabel.text = @"";
	sinaPostStatusLabel.textColor = [UIColor darkGrayColor];
	sinaPostActivity.hidden = YES;
	
	qqPostRetryButton.hidden = YES;
	qqHasErrorImageView.hidden = YES;
	qqPostStatusLabel.text = @"";
	qqPostStatusLabel.textColor = [UIColor darkGrayColor];
	qqPostActivity.hidden = YES;
	
    [progressWindow hideImmediately];
}

- (void)uploadPhoto
{
	if ([sinaApi isAuthorized]) {
		sinaPosted = NO;
		sinaPostRequest = [self _getSinaRequest];
		[sinaPostRequest startAsynchronous];
		
		sinaPostStatusLabel.text = NSLocalizedString(@"Uploading...",@"Uploading...");
		sinaPostStatusLabel.textColor = [UIColor darkGrayColor];
		sinaPostActivity.hidden = NO;
		[sinaPostActivity startAnimating];
	}
	else {
		sinaPosted = YES;
	}

	if ([qqApi isAuthorized]) {
		qqPosted = NO;
		qqPostRequest = [self _getQQRequest];
		[qqPostRequest startAsynchronous];	
		
		qqPostStatusLabel.text = NSLocalizedString(@"Uploading...",@"Uploading...");
		qqPostStatusLabel.textColor = [UIColor darkGrayColor];
		qqPostActivity.hidden = NO;
		[qqPostActivity startAnimating];	
	}
	else {
		qqPosted = YES;
	}

}

- (IBAction) send: (id) sender
{
	int length = [text.text length];
    if (length == 0) {
        sendButton.enabled = false;
        return;
    }
	[self uploadPhoto];
    [progressWindow show];
    //[self performSelector:@selector(uploadPhoto) withObject:nil afterDelay:0.1];
}

//
// UITextViewDelegate
//
- (void)textViewDidChangeSelection:(UITextView *)textView{
    textRange = text.selectedRange;
}

- (void)textViewDidChange:(UITextView *)textView{
    textRange = text.selectedRange;
    [postView setCharCount];
}

//
// CAAnimationDelegate
//
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished 
{
    CATransition *t = (CATransition*)animation;
    if (t.type == kCATransitionMoveIn) {
		[postView performSelector:@selector(setCharCount) withObject:nil afterDelay:0.5];
    }
    else {
        //[self.view removeFromSuperview];
		[self dismissModalViewControllerAnimated:NO];
		[[[GurgleAppDelegate getAppDelegate] rootViewController] closePostView];
		[[[GurgleAppDelegate getAppDelegate] window] makeKeyWindow];
    }
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate methods

-(void) requestFinished:(ASIHTTPRequest *)request{
	
	NSData *responseData = [request responseData];
	//NSLog(@"%@",[request responseString]);
	NSDictionary *responseObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
	
	if (request == sinaPostRequest) {
		NSString *error = [responseObject valueForKey:@"error_code"];
		if (error && [error length] > 0) {
			[self requestFailed:request];
			return;
		}
		sinaPosted = YES;
		sinaPostHasError = NO;
		sinaPostRetryButton.hidden = YES;
		sinaPostDoneImageView.hidden = NO;
		sinaHasErrorImageView.hidden = YES;
		sinaPostActivity.hidden = YES;
		sinaPostStatusLabel.textColor = [UIColor darkGrayColor];
		sinaPostStatusLabel.text = NSLocalizedString(@"Post successed",@"Post successed");
	}
	else {
		NSString *errorCode = [responseObject valueForKey:@"errcode"];
		if (errorCode && ![errorCode isEqualToString:@"0"] ) {
			[self requestFailed:request];
			return;
		}
		qqPosted = YES;
		qqPostHasError = NO;
		qqPostRetryButton.hidden = YES;
		qqPostDoneImageView.hidden = NO;
		qqHasErrorImageView.hidden = YES;
		qqPostActivity.hidden = YES;
		qqPostStatusLabel.textColor = [UIColor darkGrayColor];
		qqPostStatusLabel.text = NSLocalizedString(@"Post successed",@"Post successed");
	}
	
	if (sinaPosted && qqPosted) {
		if (selectedPhoto) {
			[selectedPhoto release];
			selectedPhoto = nil;
		}
		
		[progressWindow hideWithTitle:NSLocalizedString(@"Post successed",@"Post successed")];
		[self performSelector:@selector(close:) withObject:nil afterDelay:0.7];
	}
}

-(void) requestFailed:(ASIHTTPRequest *)request{
	if (request == sinaPostRequest) {
		sinaPosted = NO;
		sinaPostHasError = YES;
		sinaPostRetryButton.hidden = NO;
		sinaPostDoneImageView.hidden = YES;
		sinaHasErrorImageView.hidden = NO;
		sinaPostActivity.hidden = YES;
		sinaPostStatusLabel.textColor = [UIColor redColor];
		NSString *errMsg;
		if ([request error]) {
			errMsg = NSLocalizedString(@"Service unavailable",@"Service unavailable");
		}
		else {
			NSData *responseData = [request responseData];
			NSDictionary *responseObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
			errMsg = [responseObject valueForKey:@"error"];			
		}
		sinaPostStatusLabel.text = errMsg;
	}
	else {
		qqPosted = NO;
		qqPostHasError = YES;
		qqPostRetryButton.hidden = NO;
		qqPostDoneImageView.hidden = YES;
		qqHasErrorImageView.hidden = NO;
		qqPostActivity.hidden = YES;
		qqPostStatusLabel.textColor = [UIColor redColor];
		NSString *errMsg;
		if ([request error]) {
			errMsg = NSLocalizedString(@"Service unavailable",@"Service unavailable");
		}
		else {
			NSData *responseData = [request responseData];
			NSDictionary *responseObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
			errMsg = [responseObject valueForKey:@"msg"];			
		}
		qqPostStatusLabel.text = errMsg;
	}
}

#pragma mark -
#pragma mark UITableViewDelegate & datasource methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (![qqApi isAuthorized] || ![sinaApi isAuthorized]) {
		return 1;
	}
	return 2;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (![sinaApi isAuthorized] || indexPath.row == 1) {
		return qqPostCell;
	}
	else {
		return sinaPostCell;
	}
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
