//
//  PostViewController.h
//  TwitterFon
//
//  Created by kaz on 7/16/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressWindow.h"
#import "PostView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIApplication+Compatible.h"
#import "QQWeiboApi.h"
#import "SinaWeiboApi.h"
#import "CJSONDeserializer.h"

@interface PostViewController : UIViewController 
<
	UINavigationControllerDelegate,
	UIAlertViewDelegate,
	UITableViewDelegate,
	UITableViewDataSource,
	ASIHTTPRequestDelegate
>
{
    IBOutlet UITextView*                text;
    IBOutlet UIToolbar*                 toolbar;
    IBOutlet PostView*                  postView;
   	IBOutlet ProgressWindow*            progressWindow;
    IBOutlet UIBarButtonItem*           sendButton;
    //IBOutlet UIActivityIndicatorView*   indicator;

	UIImage*					selectedPhoto;
    BOOL                        didPost;
    NSRange                     textRange;

    UINavigationController*     navigation;
	
	SinaWeiboApi *sinaApi;
	QQWeiboApi *qqApi;
	ASIHTTPRequest *sinaPostRequest;
	ASIHTTPRequest *qqPostRequest;
	BOOL sinaPosted;
	BOOL qqPosted;
	BOOL sinaPostHasError;
	BOOL qqPostHasError;
	
	UITableViewCell *sinaPostCell;
	UITableViewCell *qqPostCell;
	IBOutlet UIButton *sinaPostRetryButton;
	IBOutlet UIButton *qqPostRetryButton;
	IBOutlet UIActivityIndicatorView *sinaPostActivity;
	IBOutlet UIActivityIndicatorView *qqPostActivity;
	IBOutlet UIImageView *sinaHasErrorImageView;
	IBOutlet UIImageView *qqHasErrorImageView;
	IBOutlet UIImageView *qqPostDoneImageView;
	IBOutlet UIImageView *sinaPostDoneImageView;
	IBOutlet UILabel *qqPostStatusLabel;
	IBOutlet UILabel *sinaPostStatusLabel;
}

@property(nonatomic, assign) UINavigationController* navigation;
@property(nonatomic, retain) IBOutlet UITableViewCell *sinaPostCell;
@property(nonatomic, retain) IBOutlet UITableViewCell *qqPostCell;

- (void) post;
- (IBAction) close:   (id) sender;
- (IBAction) send:    (id) sender;
- (IBAction) cancel:  (id) sender;
- (void) setSelectedPhoto:(UIImage *) image;

-(void) requestFinished:(ASIHTTPRequest *)request;
-(void) requestFailed:(ASIHTTPRequest *)request;

-(IBAction) sinaPostRetryButtonPressed:(id)sender;
-(IBAction) qqPostRetryButtonPressed:(id)sender;

@end
