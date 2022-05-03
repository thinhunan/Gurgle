//
//  QWeiboSyncApi.m
//  QWeiboSDK4iOSDemo
//
//  Created on 11-1-13.
//   
//

#import "WeiboApi.h"
#import "QOauth.h"
#import "NSURL+QAdditions.h"

#define SinaTokenKey @"sina_token_key"
#define SinaTokenSecret @"sina_token_secret"
#define SinaRequestKey @"sina_request_key"
#define SinaRequestSecret @"sina_request_secret"

@implementation WeiboApi
#pragma mark -
#pragma mark instance methods

-(ASIHTTPRequest *)getRequestToken{
	QOauth *oauth = [[QOauth alloc] init];
	NSString *queryString = nil;
	NSString *oauthUrl = [oauth	getOauthUrl:[[self class] getRequestTokenURL] 
								 httpMethod:@"GET" 
								consumerKey:[[self class] getConsumerKey] 
							 consumerSecret:[[self class] getConsumerSecret] 
								   tokenKey:nil 
								tokenSecret:nil 
									 verify:nil 
								callbackUrl:CallBackUrl 
								 parameters:nil 
								queryString:&queryString];
	[oauth release];
	NSMutableString *urlString = [[NSMutableString alloc] initWithString:oauthUrl];
	if (queryString) {
		[urlString appendFormat:@"?%@", queryString];
	}
	//NSLog(@"request token:%@",urlString);
	NSURL *url = [NSURL smartURLForString:urlString];
	[urlString release];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	return request;
}

-(ASIHTTPRequest *)getAccessTokenWithVerify:(NSString *)aVerify{
	QOauth *oauth = [[QOauth alloc] init];
	NSString *queryString = nil;
	NSString *oauthUrl = [oauth	getOauthUrl:[[self class] getAccessTokenURL] 
								 httpMethod:@"GET" 
								consumerKey:[[self class] getConsumerKey] 
							 consumerSecret:[[self class] getConsumerSecret] 
								   tokenKey:[[self class] getRequestTokenKey] 
								tokenSecret:[[self class] getRequestTokenSecret] 
									 verify:aVerify 
								callbackUrl:nil 
								 parameters:nil 
								queryString:&queryString];
	[oauth release];
	NSMutableString *urlString = [[NSMutableString alloc] initWithString:oauthUrl];
	if (queryString) {
		[urlString appendFormat:@"?%@", queryString];
	}
	//NSLog(@"access token:%@",urlString);
	NSURL *url = [NSURL smartURLForString:urlString];
	[urlString release];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	return request;
}

-(void) saveAccessTokenAndSecret:(NSDictionary *)params{
	NSString *accessTokenKey = [params objectForKey:@"oauth_token"];
	NSString *accessTokenSecret = [params objectForKey:@"oauth_token_secret"];
	[[self class] setTokenKey:accessTokenKey];
	[[self class] setTokenSecret:accessTokenSecret];
}

- (NSMutableDictionary*) uploadParametersWithStatus:(NSString *) status{
	NSMutableDictionary *aParameters = [NSMutableDictionary dictionary];
	[aParameters setObject:status forKey:@"status"];
	return aParameters;
}

- (ASIFormDataRequest *) uploadWithImage:(UIImage *)image 
					 status:(NSString *)status{
	NSString *aUrl =[[self class] getUploadUrl];
	NSString *aHttpMethod = @"POST";
	NSString *queryString = nil;
	NSMutableDictionary *aParameters = [self uploadParametersWithStatus:status];
	QOauth *oauth = [[QOauth alloc] init];
	[oauth	getOauthUrl:aUrl 
			 httpMethod:aHttpMethod 
			consumerKey:[[self class] getConsumerKey]
		 consumerSecret:[[self class] getConsumerSecret]
			   tokenKey:[[self class] getTokenKey]
			tokenSecret:[[self class] getTokenSecret]
				 verify:nil 
			callbackUrl:nil 
			 parameters:aParameters 
			queryString:&queryString];
	[oauth release];
	NSURL *url = [NSURL smartURLForString:aUrl];
	NSDictionary *listParams = [NSURL parseURLQueryString:queryString];
	//NSLog(@"%@?%@",aUrl,queryString);
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	for (NSString *key in listParams) {
		NSString *value = [listParams valueForKey:key];
		[request setPostValue:value forKey:key];
	}
	if (image) {
		NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
		[request setData:imageData withFileName:@"gurgle.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
	}
	return request;
}


+(NSString *) getRequestTokenURL{
	return @"http://api.t.sina.com.cn/oauth/request_token";
}

+(NSString *) getAccessTokenURL{
	return @"http://api.t.sina.com.cn/oauth/access_token";
}

+(NSString *) getUploadUrl{
	return @"http://api.t.sina.com.cn/statuses/upload.json";
}

+(NSString *) getVerifyUrl{
	return @"http://api.t.sina.com.cn/oauth/authorize?oauth_token=";
}


+(NSString *) getConsumerKey{
	return @"590070810";
}

+(NSString *) getConsumerSecret{
	return @"b9deec94340d1b42b2173f786cb2cab8";
}

+(NSString *) getTokenKey{
	return [[NSUserDefaults standardUserDefaults] valueForKey:SinaTokenKey];
}

+(NSString *) getTokenSecret{
	return [[NSUserDefaults standardUserDefaults] valueForKey:SinaTokenSecret];
}

+(NSString *) getRequestTokenKey{
	return [[NSUserDefaults standardUserDefaults] valueForKey:SinaRequestKey];
}

+(NSString *) getRequestTokenSecret{
	return [[NSUserDefaults standardUserDefaults] valueForKey:SinaRequestSecret];
}


-(BOOL) isAuthorized{
	NSString *token = [[self class] getTokenKey];
	if (token && 
		![token isEqualToString:@""]) {
		return YES;
	}
	return NO;
}

+(void) setTokenKey:(NSString *) tokenKey{
	[[NSUserDefaults standardUserDefaults] setValue:tokenKey forKey:SinaTokenKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) setTokenSecret:(NSString *) tokenSecret{
	[[NSUserDefaults standardUserDefaults] setValue:tokenSecret forKey:SinaTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) setRequestTokenKey:(NSString *) tokenKey{
	[[NSUserDefaults standardUserDefaults] setValue:tokenKey forKey:SinaRequestKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) setRequestTokenSecret:(NSString *) tokenSecret{
	[[NSUserDefaults standardUserDefaults] setValue:tokenSecret forKey:SinaRequestSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
@end
