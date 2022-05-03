//
//  QVerifyWebViewController.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import "QVerifyWebViewController.h"
#import "NSURL+QAdditions.h"

@implementation QVerifyWebViewController
@synthesize verifySuccessedSelector;
@synthesize mWeiboApi;

-(id)initWithApi:(WeiboApi *) api 
		delegate:(id)delegate{
	self = [super init];
	if (self) {
		mWeiboApi = api;
		[mWeiboApi retain];
		mVerifyDelegate = delegate;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
	mWebView.delegate = self;
	[self.view addSubview:mWebView];
	
	NSString *url = [NSString stringWithFormat:@"%@%@", [[mWeiboApi class] getVerifyUrl	], [[mWeiboApi class] getRequestTokenKey]];
	//NSLog(@"authorize url:%@",url);
	
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
	[mWebView loadRequest:request];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	mWeiboApi = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	if (mWeiboApi) {
		[mWeiboApi release];
	}
}

#pragma mark -
#pragma mark private methods

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate

-(void) parseAccessTokenWithResponse:(NSString *) retString{
	
	NSDictionary *params = [NSURL parseURLQueryString:retString];
	if (mVerifyDelegate 
		&& verifySuccessedSelector) {
		[mVerifyDelegate performSelector:verifySuccessedSelector withObject:params];
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	
	if (verifier && ![verifier isEqualToString:@""]) {
		ASIHTTPRequest *request = [mWeiboApi getAccessTokenWithVerify:verifier];
		
		[request startSynchronous];
		NSError *error = [request error];
		if (error) {
			NSLog(@"%@",[request responseString]);
			return YES;
		}
		else {
			NSString *retString = [request responseString];
			[self parseAccessTokenWithResponse:retString];
		}
		return NO;
	}
	
	return YES;
}


@end
