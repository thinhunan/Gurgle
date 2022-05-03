//
//  QVerifyWebViewController.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import <UIKit/UIKit.h>
#import "QOauthKey.h"
#import "WeiboApi.h"
#import "ASIHTTPRequest.h"

@interface QVerifyWebViewController : UIViewController<UIWebViewDelegate> {
	UIWebView *mWebView;
	WeiboApi *mWeiboApi;
	id mVerifyDelegate;
	SEL verifySuccessedSelector;
}
@property(assign) SEL verifySuccessedSelector;
@property(nonatomic,retain) WeiboApi *mWeiboApi;
-(id) initWithApi:(WeiboApi *) api delegate:(id) delegate;
@end
