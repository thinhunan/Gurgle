//
//  QQWeiboApi.m
//  Gurgle
//
//  Created by Think on 11-4-24.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "QQWeiboApi.h"
#define QQTokenKey @"qq_token_key"
#define QQTokenSecret @"qq_token_secret"
#define QQRequestKey @"qq_request_key"
#define QQRequestSecret @"qq_request_secret"

@implementation QQWeiboApi

-(NSString *) getIpAddress{
	
	if (!ipAddress) {
		InitAddresses();
		GetIPAddresses();
		GetHWAddresses();
		ipAddress = [[NSString stringWithFormat:@"%s", ip_names[1]] retain];
		FreeAddresses();
	}
	return ipAddress;
}

-(void) dealloc{
	if (ipAddress) {
		[ipAddress release];
	}
	[super dealloc];
}

-(NSMutableDictionary*) uploadParametersWithStatus:(NSString *)status{
	NSMutableDictionary *aParameters = [NSMutableDictionary dictionary];
	[aParameters setObject:status forKey:@"content"];
	[aParameters setObject:@"json" forKey:@"format"];
	[aParameters setObject:[self getIpAddress] forKey:@"clientip"];
	return aParameters;
}

+(NSString *) getRequestTokenURL{
	return @"https://open.t.qq.com/cgi-bin/request_token";
}

+(NSString *) getAccessTokenURL{
	return @"https://open.t.qq.com/cgi-bin/access_token";
}

+(NSString *) getUploadUrl{
	return @"http://open.t.qq.com/api/t/add_pic";
}

+(NSString *) getVerifyUrl{
	return @"https://open.t.qq.com/cgi-bin/authorize?oauth_token=";
}


+(NSString *) getConsumerKey{
	return @"add088d86c8d4bcd8b3e78409a0464ea";
}

+(NSString *) getConsumerSecret{
	return @"493778d52b8e044d59aa03a82edb7e50";
}

+(NSString *) getTokenKey{
	return [[NSUserDefaults standardUserDefaults] valueForKey:QQTokenKey];
}

+(void) setTokenKey:(NSString *) tokenKey{
	[[NSUserDefaults standardUserDefaults] setValue:tokenKey forKey:QQTokenKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getTokenSecret{
	return [[NSUserDefaults standardUserDefaults] valueForKey:QQTokenSecret];
}

+(void) setTokenSecret:(NSString *) tokenSecret{
	[[NSUserDefaults standardUserDefaults] setValue:tokenSecret forKey:QQTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getRequestTokenKey{
	return [[NSUserDefaults standardUserDefaults] valueForKey:QQRequestKey];
}

+(void) setRequestTokenKey:(NSString *) tokenKey{
	[[NSUserDefaults standardUserDefaults] setValue:tokenKey forKey:QQRequestKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getRequestTokenSecret{
	return [[NSUserDefaults standardUserDefaults] valueForKey:QQRequestSecret];
}

+(void) setRequestTokenSecret:(NSString *) tokenSecret{
	[[NSUserDefaults standardUserDefaults] setValue:tokenSecret forKey:QQRequestSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
@end
