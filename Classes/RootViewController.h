//
//  RootViewController.h
//  Gurgle
//
//  Created by Think on 11-3-26.
//  Copyright 2011 @Shanghai. All rights reserved.
//
#if defined(LITE_VERSION)
#import "GADBannerView.h"
#define MY_BANNER_UNIT_ID @"a14db52fb84c3ec"
#endif


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"
#import "PostViewController.h"
#import "GurgleAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class CalloutView;
@class CalloutTextView;
@interface RootViewController : UIViewController 
<UIImagePickerControllerDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
MFMailComposeViewControllerDelegate>{
	
#if defined(LITE_VERSION)
	GADBannerView *bannerView_;		
#endif
														
	CalloutView *selectedCallout;
	CalloutTextView *textView;
	UIButton *flipVerticalButton;
	UIButton *flipHorizontalButton;
	UIButton *deleteButton;
	UIButton *editButton;
	UIToolbar *toolbar;
	UIToolbar *inputAccessoryToolbar;
	UIImageView *imageView;
	UIView *maskWhenEditing;
	UIBarButtonItem *calloutButton;
	UIBarButtonItem *actionButton;
	UIBarButtonItem *newPageButton;
	UIInterfaceOrientation viewOrientation;
	
	//work table 
	UIView *workTableView;
	UIScrollView *workTableScrollView;
	UIButton *closeTableButton;
	
	//palette table
	UIView *paletteView;
	UIScrollView *paletteScrollView;
	UISegmentedControl *paletteSegmentedController;
	
	UIImagePickerController *imagePicker;
	UIToolbar *cameraBar;
	IBOutlet UIView *cameraOverlayView;
	
	//settings & post
	BOOL needShowPostView;
	SettingsViewController *settingsView;
	PostViewController *postView;
	
	//save image
	IBOutlet UIActivityIndicatorView *notifyIndicator;
	IBOutlet UILabel *notifyLabel;
	IBOutlet UIToolbar *notifyBar;
	
	//hold view
	UIImageView *artImage;
	UIView *holdView;
	IBOutlet UIImageView *backgroundImageView;
}
@property(nonatomic,assign) CalloutTextView* textView;
@property(nonatomic,retain) IBOutlet UIButton *flipVerticalButton;
@property(nonatomic,retain) IBOutlet UIButton *flipHorizontalButton;
@property(nonatomic,retain) IBOutlet UIButton *deleteButton;
@property(nonatomic,retain) IBOutlet UIButton *editButton;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic,retain) IBOutlet UIToolbar *inputAccessoryToolbar;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *calloutButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *newPageButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *actionButton;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) IBOutlet UIView *maskWhenEditing;
@property(nonatomic,assign) CalloutView *selectedCallout;
//work table 
@property(nonatomic,assign) IBOutlet UIView *workTableView;
@property(nonatomic,assign) IBOutlet UIScrollView *workTableScrollView;
@property(nonatomic,assign) IBOutlet UIButton *closeTableButton;
//palette table
@property(nonatomic,retain) IBOutlet UIView *paletteView;
@property(nonatomic,retain) IBOutlet UIScrollView *paletteScrollView;
@property(nonatomic,retain) IBOutlet UISegmentedControl *paletteSegmentedController;

@property(nonatomic,retain) IBOutlet UIImagePickerController *imagePicker;
@property(nonatomic,retain) IBOutlet UIToolbar *cameraBar;
//hold view
@property(nonatomic,retain) IBOutlet UIImageView *artImage;
@property(nonatomic,retain) IBOutlet UIView	*holdView;
//callout controller
-(IBAction) flipHorizontal:(id) sender;
-(IBAction) flipVertical:(id) sender;
-(IBAction) deleteCallout:(id)sender;
-(IBAction) editText:(id)sender;
-(IBAction) closeEditText:(id)sender;
//toolbar
-(IBAction) takePhotoButtonPressed:(id)sender;
-(IBAction) addCalloutButtonPressed:(id)sender;
-(IBAction) newPageButtonPressed:(id)sender;
-(IBAction) actionButtonPressed:(id)sender;
-(void) setControllingButtonHidde:(BOOL) hidden;
//work talbe
-(IBAction) closeTableButtonPressed:(id)sender;
//palette 
-(IBAction) colorApplyButtonPressed:(id)sender;
- (IBAction) onPaletteTapped:(id)sender;
//take photo
-(IBAction)takeShoot:(id)sender;
-(IBAction)cancelShoot:(id)sender;
//settings & post
-(IBAction)openSettingsView;
-(void)closeSettingView;
-(void)openPostView;
-(void)closePostView;
//mail composite
-(IBAction)contactMe:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(void)shareByMail;
@end
