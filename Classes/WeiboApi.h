//
//  WeiboApi.h
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "QOauthKey.h"

#define CallBackUrl @"http://think.cnblogs.com/"

@interface WeiboApi : NSObject {
}
//Get request token
-(ASIHTTPRequest *)getRequestToken;

//Get access token
-(ASIHTTPRequest *)getAccessTokenWithVerify:(NSString *)aVerify;

-(void) saveAccessTokenAndSecret:(NSDictionary *) params;

-(ASIFormDataRequest *) uploadWithImage:(UIImage *)image 
					 status:(NSString *)status;

-(NSMutableDictionary *) uploadParametersWithStatus:(NSString *) status;

+(NSString *) getRequestTokenURL;

+(NSString *) getAccessTokenURL;

+(NSString *) getUploadUrl;

+(NSString *) getVerifyUrl;

+(NSString *) getConsumerKey;

+(NSString *) getConsumerSecret;

+(NSString *) getRequestTokenKey;

+(NSString *) getRequestTokenSecret;

+(NSString *) getTokenKey;

+(NSString *) getTokenSecret;

-(BOOL) isAuthorized;

+(void) setRequestTokenKey:(NSString *) tokenKey;

+(void) setRequestTokenSecret:(NSString *) tokenSecret;

+(void) setTokenKey:(NSString *) tokenKey;

+(void) setTokenSecret:(NSString *) tokenSecret;

@end
