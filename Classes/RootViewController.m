//
//  RootViewController.m
//  Gurgle
//
//  Created by Think on 11-3-26.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "RootViewController.h"
#import "GurgleAppDelegate.h"

#import "CalloutView.h"
#import "CalloutTextView.h"
#import "CalloutLabel.h"

#import "ChatEllipseCalloutView.h"
#import "ChatRoundedRectangleCalloutView.h"
#import "ChatRectangleCalloutView.h"
#import "ChatThinkingCloudCalloutView.h"
#import "ChatBillboardCalloutView.h"
#import "ChatBurstCalloutView.h"
#import "CloudCalloutView.h"
#import "RectangleCalloutView.h"
#import "RoundedRectangleCalloutView.h"
#import	"EllipseCalloutView.h"
#import "DogEaredRectangleCalloutView.h"
#import "ArrowCalloutView.h"
#import "HeartCalloutView.h"

#import "DeviceUtilities.h"

#define kDeleteAnimationKey @"deleteAnimation"
#define kNewPageAnimationKey @"newPageAnimation"
#define kStartButtonAnimationKey @"startButtonAnimation"
#define kShowAnimationkey @"showAnimation"
#define kHideAnimationKey @"hideAnimation"
#define kHideAfterDelay 1

#define kActionSheetTagImagePicker 0
#define kActionSheetTagDeleteBallon 1
#define kActionSheetTagNewPage 2
#define kActionSheetTagSelectAction 3
#define kActionSheetTagTips 4
#define kDeleteCallout 5



@implementation RootViewController



@synthesize flipVerticalButton,flipHorizontalButton,deleteButton,editButton;
@synthesize selectedCallout;
@synthesize toolbar;
@synthesize inputAccessoryToolbar,maskWhenEditing;

@synthesize imageView,textView;
@synthesize calloutButton,newPageButton,actionButton;	
//work table 
@synthesize workTableView,workTableScrollView,closeTableButton;
@synthesize paletteView,paletteScrollView,paletteSegmentedController;
@synthesize imagePicker;
@synthesize cameraBar;
//hold view
@synthesize artImage;
@synthesize holdView;

-(UIImage *) _getBackgroundImage{
	NSString *backgroundImages[2] = {@"background_1.png",@"background_2.png"};	
	srandom(time(NULL));
	unsigned rnd = random()%2;
	return [UIImage imageNamed: backgroundImages[rnd]];
}

-(CGAffineTransform) _getTransformToFitOritention:(UIInterfaceOrientation) orientation inSize:(CGSize) size{
	CGFloat originalWidth = size.width;
	CGFloat originalHeight = size.height;
	CGFloat horizontalCenter = originalWidth * 0.5;
	CGFloat verticalCenter = originalHeight * 0.5;	
	CGAffineTransform affineTransform = CGAffineTransformIdentity;	
	affineTransform = CGAffineTransformConcat(affineTransform,
											  CGAffineTransformMakeTranslation(-horizontalCenter,-verticalCenter));
	CGFloat angle = ((UIInterfaceOrientationLandscapeLeft == orientation)?0.5:-0.5) *M_PI;
	affineTransform = CGAffineTransformConcat(affineTransform,
											  CGAffineTransformMakeRotation(angle));
	affineTransform = CGAffineTransformConcat(affineTransform,
											  CGAffineTransformMakeTranslation(verticalCenter, horizontalCenter));
	return affineTransform;
}

-(CGAffineTransform)_getLandscapeTransform:(CGSize)size{
	return [self _getTransformToFitOritention:UIInterfaceOrientationLandscapeLeft inSize:size];
}

-(CGAffineTransform)_getPortraitTransform:(CGSize)size{
	return [self _getTransformToFitOritention:UIInterfaceOrientationPortrait inSize:size];
}

#pragma mark -
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if([animationID isEqualToString:kNewPageAnimationKey]){
		newPageButton.enabled 
		= actionButton.enabled 
		= calloutButton.enabled = NO;
	}
	
	viewOrientation = UIInterfaceOrientationPortrait;
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
	
	//为了马上旋转过来
	UINavigationController* nav = [[GurgleAppDelegate getAppDelegate] navigationController];
	UIViewController *controller = [[UIViewController alloc] init];
	UINavigationController *parentController = [[UINavigationController alloc] initWithRootViewController:controller];
	[nav presentModalViewController:parentController animated:NO];
	[controller dismissModalViewControllerAnimated:NO];
	[parentController release];
	[controller release];
	holdView.hidden = NO;
	imageView.hidden = YES;
}

#pragma mark -
-(void) _hideContrllingButtons{
	[self setControllingButtonHidde:YES];
}

-(void) _hideAllControlViews{
	workTableView.hidden = paletteView.hidden = YES;
	[self _hideContrllingButtons];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate method
-(IBAction)takeShoot:(id)sender{
	if(imagePicker){
		[imagePicker takePicture];
	}
}
-(IBAction)cancelShoot:(id)sender{
	if(imagePicker){
		[self imagePickerControllerDidCancel:imagePicker];
	}
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:NO];
	[cameraBar setHidden:YES];
	[cameraOverlayView setHidden:YES];
}

//获取一个缩小到View大小的照片，以节省内容
-(UIImage*) _getMiniature:(UIImage*) originalImage{
	CGFloat maxRelosution = 
						(imageView.frame.size.width>imageView.frame.size.height)?
						imageView.frame.size.width:imageView.frame.size.height;
    CGImageRef imgRef = originalImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > maxRelosution || height > maxRelosution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = maxRelosution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = maxRelosution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = originalImage.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
	//NSLog(@"%d",[image imageOrientation]);
	[cameraBar setHidden:YES];
	[cameraOverlayView setHidden:YES];
	selectedCallout = nil;
	for(UIView *subView in imageView.subviews){
		if ([subView isKindOfClass:[CalloutView class]]) {
			[subView removeFromSuperview];
		}
	}
	CGFloat originalWidth = image.size.width;
	CGFloat originalHeight = image.size.height;
	
	if (originalWidth > originalHeight) {//Rotate the image to fit portrait view
		
		if (image.imageOrientation == 1) {
			viewOrientation = UIInterfaceOrientationLandscapeLeft;
		}
		else {
			viewOrientation = UIInterfaceOrientationLandscapeRight;
		}

	}
	else {
		
		viewOrientation = UIInterfaceOrientationPortrait;
	}
	[[UIApplication sharedApplication] setStatusBarOrientation:viewOrientation];
	if(viewOrientation != UIInterfaceOrientationPortrait){
		imageView.frame = CGRectMake(0,0,480, 360);
		holdView.hidden = YES;
	}
	else {
		imageView.frame = CGRectMake(0,0,320, 436);
		holdView.hidden = NO;
	}
	imageView.image =  [self _getMiniature:image];
	imageView.hidden = NO;
	[picker dismissModalViewControllerAnimated:NO];

	[calloutButton setEnabled:YES];
	[actionButton setEnabled:YES];
	[newPageButton setEnabled:YES];
	inputAccessoryToolbar.hidden = YES;
	workTableView.hidden = NO;
}

#pragma mark -
#pragma mark Save Image
-(UIImage*)_getUIImageToSaveOrPost{
	CGSize size = imageView.bounds.size;
	/*
	if (size.width>size.height) {
		size.width = 426;
		size.height = 320;
	}
	else {
		size.height = 426;
		size.width = 320;
	}
	 */
	
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	[imageView.layer renderInContext:ctx];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
	/*
	UIImage *result = nil;
	int kBytesPerPixel = 8;
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	unsigned char *data = calloc(1,size.width*size.height*kBytesPerPixel);
	if (data != NULL) {
		CGContextRef context = CGBitmapContextCreate(data, size.width, size.height, 
													 8, size.width*kBytesPerPixel,
													 rgb, kCGImageAlphaPremultipliedLast);
		if (context != NULL) {
			UIGraphicsPushContext(context);
			
			CGContextTranslateCTM(context, 0, size.height);
			CGContextScaleCTM(context, 1, -1);
			[imageView.layer renderInContext:context];
			UIGraphicsPopContext();
			CGImageRef imageRef = CGBitmapContextCreateImage(context);
			
			if (imageRef != NULL) {
				result = [UIImage imageWithCGImage:imageRef];
				CGImageRelease(imageRef);
			}
			CGContextRelease(context);
		}
		free(data);
	}
	CGColorSpaceRelease(rgb);
	return result;*/
}

-(void)_hideNitifyBar{
	[notifyIndicator stopAnimating];
	notifyBar.hidden = YES;
	notifyLabel.hidden = YES;
	notifyIndicator.hidden = YES;
	
	CATransition *animation = [CATransition animation];
 	[animation setDelegate:nil];
    [animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromBottom];
	[animation setDuration:0.3];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[notifyBar layer] addAnimation:animation forKey:kHideAnimationKey];
}

-(void) imageSavedToPhotosAlbum:image 
	   didFinishSavingWithError:(NSError *)error 
					contextInfo:(void *)contextInfo{
	NSString *saveFailed = NSLocalizedString(@"Save failed",@"Save failed");
	if (error != nil) {
		NSString *info = [[NSString alloc] initWithFormat:@"%@:%@",saveFailed,error];
		notifyLabel.text = info;
		[info release];
	}
	[self performSelector:@selector(_hideNitifyBar) withObject:nil afterDelay:kHideAfterDelay];
}

-(void) _saveImageToPhotoAlbum{
	UIImage *image = [self _getUIImageToSaveOrPost];
	notifyBar.hidden = NO;
	notifyIndicator.hidden = NO;
	[notifyIndicator startAnimating];
	notifyLabel.hidden = NO;
	NSString *saving = NSLocalizedString(@"Saving",@"Saving");
	notifyLabel.text = saving;
	
	CATransition *animation = [CATransition animation];
 	[animation setDelegate:nil];
    [animation setType:kCATransitionMoveIn];
	[animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.3];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[notifyBar layer] addAnimation:animation forKey:kShowAnimationkey];
	
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -
#pragma mark PostView &  SettingsView
- (void)openSettingsView{
    if (settingsView) return;
    settingsView = [[[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil] autorelease];
	[settingsView setNeedShowPostView:needShowPostView];
	UINavigationController *parentNav = [[[UINavigationController alloc] initWithRootViewController:settingsView] autorelease];
    UINavigationController* nav = [[GurgleAppDelegate getAppDelegate] navigationController];	
    [nav presentModalViewController:parentNav animated:YES];
	
}

- (void)closeSettingView{
	settingsView = nil;
	SinaWeiboApi *sinaApi = [[SinaWeiboApi alloc] init];
	QQWeiboApi *qqApi = [[QQWeiboApi alloc] init];
	if (![sinaApi isAuthorized]
		&& ![qqApi isAuthorized]) {
		needShowPostView = NO;
	}
	[sinaApi release];
	[qqApi release];
	if (needShowPostView) {
		[self openPostView];
	}

}

-(void) openPostView{
	if(postView) return;
	postView = [[[PostViewController alloc] initWithNibName:@"PostView" bundle:nil] autorelease];
	[postView setSelectedPhoto:[self _getUIImageToSaveOrPost]];
	UINavigationController *parentNav = [[[UINavigationController alloc] initWithRootViewController:postView] autorelease];
	postView.navigation = parentNav;
	UINavigationController *nav = [[GurgleAppDelegate getAppDelegate] navigationController];
	[nav presentModalViewController:parentNav animated:NO];
	[postView post];
	needShowPostView = NO;
}

-(void)closePostView{
	postView = nil;
}

#pragma mark -
#pragma mark toolbar method
-(IBAction) takePhotoButtonPressed:(id)sender{
	[self _hideAllControlViews];
	NSString *back = NSLocalizedString(@"Back",@"Back");
	NSString *takeNewPhoto = NSLocalizedString(@"Take new photo",@"Take new photo");
	NSString *pickFromLiabrary = NSLocalizedString(@"Pick from library",@"Pick from library");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:nil 
								  delegate:self cancelButtonTitle:back 
								  destructiveButtonTitle:nil 
								  otherButtonTitles:takeNewPhoto,pickFromLiabrary,nil];
	[actionSheet setTag:kActionSheetTagImagePicker];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

-(IBAction) newPageButtonPressed:(id)sender{
	[self _hideAllControlViews];
	NSString *startNew = NSLocalizedString(@"Start new",@"start new");
	NSString *cancel = NSLocalizedString(@"Cancel",@"Cancel");
	UIActionSheet *action = [[UIActionSheet alloc]
							 initWithTitle:nil 
							 delegate:self 
							 cancelButtonTitle:cancel
							 destructiveButtonTitle:startNew 
							 otherButtonTitles:nil];
	action.tag = kActionSheetTagNewPage;
	[action showInView:self.view];
	[action release];
}

-(void) _addNewProjectButton{
	if ([DeviceUtilities isIOS4]) {
		newPageButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(newPageButtonPressed:)];
	}
	else {
		//PageCurl Effect don't support directly until ios 4
		UIImage *pageCurlImage = [UIImage imageNamed:@"UIBarButtonSystemItemPageCurl.png"];
		UIImage *pageCurlImageDisabled = [UIImage imageNamed:@"UIBarButtonSystemItemPageCurlDisabled.png"];
		UIButton *pageCurlButton = [UIButton buttonWithType:UIButtonTypeCustom];
		pageCurlButton.frame = CGRectMake(0, 0, 34, 29);
		[pageCurlButton setBackgroundImage:pageCurlImage forState:UIControlStateNormal];
		[pageCurlButton setBackgroundImage:pageCurlImageDisabled forState:UIControlStateDisabled];
		[pageCurlButton addTarget:self action:@selector(newPageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		newPageButton = [[UIBarButtonItem alloc] initWithCustomView:pageCurlButton];	
	}
	newPageButton.tag = 100;
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithArray:toolbar.items];
	[buttons addObject:newPageButton];
	[toolbar setItems:buttons];
	newPageButton.enabled = NO;
	[buttons release];
}

-(IBAction) addCalloutButtonPressed:(id) sender{
	[self _hideAllControlViews];
	workTableView.hidden = !workTableView.hidden;
}

-(IBAction) actionButtonPressed:(id)sender{
	[self _hideAllControlViews];
	
	NSString *back = NSLocalizedString(@"Cancel",@"Cancel");
	NSString *postToWeibo = NSLocalizedString(@"Post to weibo",@"post to weibo");
	NSString *saveToLibrary = NSLocalizedString(@"Save to library",@"save to library");
	
	UIActionSheet *actions;
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		NSString *shareByMail = NSLocalizedString(@"Send mail",@"Send mail");
		actions = [[UIActionSheet alloc] initWithTitle:nil 
									delegate:self 
						   cancelButtonTitle:back 
					  destructiveButtonTitle:nil 
						   otherButtonTitles:postToWeibo,saveToLibrary,shareByMail,nil];
	}
	else {
		actions = [[UIActionSheet alloc] initWithTitle:nil 
									delegate:self 
						   cancelButtonTitle:back 
					  destructiveButtonTitle:nil 
						   otherButtonTitles:postToWeibo,saveToLibrary,nil];
	}

	actions.tag = kActionSheetTagSelectAction;
	[actions showInView:self.view];
	[actions release];
}
#pragma mark -
#pragma mark keyboard events

-(void)keyboardWillShow:(NSNotification *)sender{
	
	if (viewOrientation != UIInterfaceOrientationPortrait) {
		inputAccessoryToolbar.frame = CGRectMake(0, 115 , 480, 44);
	}
	else {
		inputAccessoryToolbar.frame = CGRectMake(0, 220 , 320, 44);
	}

}
-(void)keyboardDidShow:(NSNotification *)sender{	
	[inputAccessoryToolbar setHidden:NO];
}
-(void)keyboardWillHide:(NSNotification *)sender{
	[inputAccessoryToolbar setHidden:YES];
}

#pragma mark -
#pragma mark UITextView delegate

-(void) textViewDidChange:(UITextView *)aTextView{
	if (selectedCallout) {	
		selectedCallout.label.text = aTextView.text;
		[selectedCallout.label autoAdjustFontSize];
	}
}
-(void) textViewDidEndEditing:(UITextView *)aTextView{
	[aTextView resignFirstResponder];
}

#pragma mark -
#pragma mark CalloutView operations

-(void) _exitEditingCallout:(CalloutView*) callout{
	[textView resignFirstResponder];
	NSRange textRange = NSMakeRange(0, 0);
	textView.selectedRange = textRange;
	textView.editable = NO;
	textView.hidden = YES;
}

-(void) setControllingButtonHidde:(BOOL) hidden{
	flipVerticalButton.hidden 
	= flipHorizontalButton.hidden 
	= deleteButton.hidden 
	= editButton.hidden = hidden;
}

-(IBAction) flipHorizontal:(id) sender{
	if (selectedCallout) {	
		[selectedCallout flipHorizontal];
	}
}
-(IBAction) flipVertical:(id) sender{
	if (selectedCallout) {	
		[selectedCallout flipVertical];
	}
}

-(void)_removeSelectedCallout{	
	[self _exitEditingCallout:selectedCallout];
	[selectedCallout removeFromSuperview];
	selectedCallout=nil;
	[self _hideContrllingButtons];
}

-(IBAction) deleteCallout:(id)sender{
	if (selectedCallout) {	
		if ( [selectedCallout.label.text compare:@""] == NSOrderedSame) {
			[self _removeSelectedCallout];
		}
		else{
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") destructiveButtonTitle:NSLocalizedString(@"Delete",@"Delete") otherButtonTitles:nil];
			actionSheet.tag = kDeleteCallout;
			[actionSheet showInView:self.view];
			[actionSheet release];
		}
	}
}

-(IBAction) editText:(id)sender{
	if (selectedCallout) {
		selectedCallout.userInteractionEnabled = NO;
		selectedCallout.label.hidden = YES;
		textView.text = selectedCallout.label.text;
		textView.hidden = NO;
		textView.editable = YES;
		[textView setTextColor:selectedCallout.label.textColor];
		NSRange textRange = NSMakeRange(textView.text.length, 0);
		textView.selectedRange = textRange;
		[textView becomeFirstResponder];
		[selectedCallout setOnlyFlipTransform];
		CGFloat x = selectedCallout.frame.origin.x,
		y = selectedCallout.frame.origin.y,
		w = selectedCallout.frame.size.width,
		h = selectedCallout.frame.size.height;
		CGRect txtFrame = CGRectMake(x + 0.1 * w,
									 y + 0.1 * h,
									 w * 0.8, 
									 h * 0.8);
		textView.frame = txtFrame;
		[maskWhenEditing removeFromSuperview];
		[imageView addSubview:maskWhenEditing];
		[maskWhenEditing setHidden:NO];
		[imageView bringSubviewToFront:maskWhenEditing];
		[imageView bringSubviewToFront:inputAccessoryToolbar];
		maskWhenEditing.userInteractionEnabled = YES;
		[imageView bringSubviewToFront:selectedCallout];
		[self.view bringSubviewToFront:textView];
		
		[self _hideAllControlViews];
	}
}


-(IBAction) closeEditText:(id)sender{
	if (selectedCallout) {	
		maskWhenEditing.hidden = YES;
		NSRange textRange = NSMakeRange(0, 0);
		textView.selectedRange = textRange;
		[textView resignFirstResponder];
		[selectedCallout setUserInteractionEnabled:YES];
		textView.hidden = YES;
		selectedCallout.label.hidden = NO;
		[selectedCallout showAndMoveControllingButtonToSide];
	}
}

#pragma mark -
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if ( selectedCallout == nil ||
		[[event touchesForView:selectedCallout] count]<1 ){
		//[self _exitEditingCallout:selectedCallout];
		[self _hideContrllingButtons];
	}
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return viewOrientation == interfaceOrientation;
}

#pragma mark -
#pragma mark Select ballon and color

- (IBAction) onPaletteTapped:(id)sender{
	if (selectedCallout) {
		selectedCallout.userInteractionEnabled = NO;
		[self closeEditText:nil];
		[self _hideAllControlViews];
		paletteView.hidden = NO;
		maskWhenEditing.hidden = NO;
		[paletteSegmentedController setSelectedSegmentIndex:0];
		[maskWhenEditing.superview bringSubviewToFront:maskWhenEditing];
		[selectedCallout.superview bringSubviewToFront:selectedCallout];
	}
}

- (void)_addColorToPalette{
	CGFloat width = 42;
	CGFloat height = 42;
	UIColor* colors[13] = {
		[UIColor magentaColor],
		[UIColor orangeColor],
		[UIColor redColor],
		[UIColor yellowColor],
		[UIColor greenColor],
		[UIColor cyanColor],
		[UIColor whiteColor],
		[UIColor lightGrayColor],
		[UIColor blueColor],
		[UIColor purpleColor],
		[UIColor blackColor],
		[UIColor brownColor],
		[UIColor groupTableViewBackgroundColor]
	};
	CGFloat x = 4;
	for (NSInteger i = 0; i < 13;  i++) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(x, 10, width, height);
		UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:button.bounds];
		backgroundView.backgroundColor = colors[i];
		[button addSubview:backgroundView];
		button.tag = i+100;
		[button addTarget:self action:@selector(_onColorTapped:) forControlEvents:UIControlEventTouchUpInside];
		[paletteScrollView addSubview:button];
		[backgroundView release];
		x += width + 4;
	}
	paletteScrollView.contentSize = CGSizeMake(x, 46);
}

-(void) _onColorTapped:(id)sender{
	if (selectedCallout) {	
		UIButton *button = (UIButton *)sender;
		if (button) {
			UIColor *selectedColor = ((UIImageView *)[button.subviews objectAtIndex:0]).backgroundColor;
			if (paletteSegmentedController.selectedSegmentIndex == 0) {
				[selectedCallout setBackgroundColor:selectedColor];
			}
			else {
				[selectedCallout setTextColor:selectedColor];
			}
		}
	}
}
-(IBAction)colorApplyButtonPressed:(id)sender{
	paletteView.hidden = YES;
	maskWhenEditing.hidden = YES;
	if (selectedCallout){
		selectedCallout.userInteractionEnabled = YES;
	}
}

-(IBAction)closeTableButtonPressed:(id)sender{
	workTableView.hidden = YES;
}
- (void)_onCalloutSelected:(id)sender{
	UIButton *buttonPressed = (UIButton *)sender;
	if (buttonPressed) {
		CalloutView *callout= nil;
		for (UIView* subView in [buttonPressed subviews]){
			if ([subView isKindOfClass:[CalloutView class]]) {
				callout = (CalloutView *)subView;
				break;
			}
		}
		if (callout) {
			CGRect frame = CGRectMake((imageView.frame.size.width - 120)/2 , 
									  20,
									  120, 100);
			if(viewOrientation == UIInterfaceOrientationPortrait){
				frame.origin.y = imageView.frame.size.height - 360;
			}
			CalloutView *newCallout = [[[callout class] alloc] initWithFrame:frame text:@""];
			[newCallout setBackgroundColor:[UIColor purpleColor]];
			[imageView addSubview:newCallout];
			selectedCallout = newCallout;
			[newCallout release];
			[self editText:nil];
			[self _hideAllControlViews];
		}
	}
}

- (void)_addCalloutToWorkTable{
	CGFloat width = 60;
	CGFloat height = 50;
	CGRect calloutFrame = CGRectMake(0, 0, width, height);
	CalloutView* calloutViews[13] = {
		[[ChatEllipseCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[ChatRoundedRectangleCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[ChatRectangleCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[ChatThinkingCloudCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[ChatBillboardCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[ChatBurstCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[CloudCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[RectangleCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[RoundedRectangleCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[EllipseCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[DogEaredRectangleCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[ArrowCalloutView alloc] initWithFrame:calloutFrame text:@""],
		[[HeartCalloutView alloc] initWithFrame:calloutFrame text:@""]
	};
	CGFloat x = 10;
	for (NSInteger i = 0; i < 13;  i++) {
		CalloutView *calloutView = calloutViews[i];
		calloutView.backgroundColor = [UIColor purpleColor];
		calloutView.userInteractionEnabled = NO;
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(x, 0, width, height);
		[button addSubview:calloutView];
		button.tag = i+100;
		[button addTarget:self action:@selector(_onCalloutSelected:) forControlEvents:UIControlEventTouchUpInside];
		[workTableScrollView addSubview:button];
		[calloutView release];
		x += width + 10;
	}
	workTableScrollView.contentSize = CGSizeMake(x, 60);
}


#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	/*
	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	 */
#if defined(LITE_VERSION)
	
	bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            holdView.frame.size.height -
                                            GAD_SIZE_320x50.height -44,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
	
	bannerView_.adUnitID = MY_BANNER_UNIT_ID;
	
	bannerView_.rootViewController = self;
	[self.holdView addSubview:bannerView_];
	// Initiate a generic request to load it with an ad.
	[bannerView_ loadRequest:[GADRequest request]];
	
#endif	
	backgroundImageView.image = [self _getBackgroundImage];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	viewOrientation = UIInterfaceOrientationPortrait;
	[self.navigationController.navigationBar setHidden:YES];
	[self _addCalloutToWorkTable];
	[self _addColorToPalette];
	//toolbar
	[self _addNewProjectButton];
	//textview
	textView = [[CalloutTextView alloc] initWithFrame:CGRectZero];
	textView.delegate = self;
	[self.view addSubview:textView];
	textView.hidden = YES;
	
	//四个控制按钮调到ImageView中
	[deleteButton removeFromSuperview];
	[imageView addSubview:deleteButton];
	[editButton removeFromSuperview];
	[imageView addSubview:editButton];
	[flipVerticalButton removeFromSuperview];
	[imageView addSubview:flipVerticalButton];
	[flipHorizontalButton removeFromSuperview];
	[imageView addSubview:flipHorizontalButton];
	[inputAccessoryToolbar removeFromSuperview];
	[imageView addSubview:inputAccessoryToolbar];
	
	//键盘事件
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:self.view.window]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification object:self.view.window]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification object:self.view.window];

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidUnload {
#if defined(LITE_VERSION)
	if(bannerView_){
		[bannerView_ release];
	}
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	flipVerticalButton = nil;
	flipHorizontalButton = nil;
	deleteButton = nil;
	editButton = nil;
	textView = nil;
	toolbar = nil;
	inputAccessoryToolbar = nil;
	imageView = nil;
	maskWhenEditing = nil;
	calloutButton = nil;
	newPageButton = nil;
	actionButton = nil;
	workTableView = nil;
	workTableScrollView = nil;
	paletteView = nil;
	paletteScrollView = nil;
	paletteSegmentedController = nil;
	closeTableButton = nil;
	imagePicker = nil;
	cameraBar = nil;
	artImage = nil;
	holdView = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
	[flipVerticalButton release];
	[flipHorizontalButton release];
	[deleteButton release];
	[editButton release];
	[textView release];
	[toolbar release];
	[inputAccessoryToolbar release];
	[imageView release];
	[maskWhenEditing release];
	[calloutButton release];
	[newPageButton release];
	[actionButton release];
	[workTableView release];
	[workTableScrollView release];
	[paletteView release];
	[paletteScrollView release];
	[paletteSegmentedController release];
	[closeTableButton release];
	[imagePicker release];
	[cameraBar release];
	[artImage release];
	[holdView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIActionSheetDelegate method
-(void)shareByWeibo{
	SinaWeiboApi *sinaApi = [[SinaWeiboApi alloc] init];
	QQWeiboApi *qqApi = [[QQWeiboApi alloc] init];
	if (![sinaApi isAuthorized]
		&& ![qqApi isAuthorized]) {
		needShowPostView = YES;
		[self openSettingsView];
	}
	else {
		[self openPostView];
	}
	[sinaApi release];
	[qqApi release];
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		if(actionSheet.tag == kActionSheetTagSelectAction){
			switch (buttonIndex) {
				case 0:
					[self shareByWeibo];
					break;
				case 1:
					[self _saveImageToPhotoAlbum];
					break;
				default:
					[self shareByMail];
					break;
			}
		}
		else if(actionSheet.tag == kActionSheetTagImagePicker){
			//imagePicker = [[UIImagePickerController alloc] init];
			//imagePicker.delegate = self;
			if (buttonIndex == 0 &&
				[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
				[imagePicker setShowsCameraControls:NO];	
				cameraBar.hidden = NO;
				/*
				CGRect overlayViewFrame = imagePicker.cameraOverlayView.frame;
				CGRect newFrame = CGRectMake(0.0,
											 CGRectGetHeight(overlayViewFrame) -
											 cameraBar.frame.size.height - 9.0,
											 CGRectGetWidth(overlayViewFrame),
											 cameraBar.frame.size.height + 9.0);
				 */
				CGRect newFrame = CGRectMake(0,426,320,54);
				cameraBar.frame = newFrame;
				//NSLog(@"%@",[[UIDevice currentDevice] systemVersion]);
				cameraOverlayView.hidden = NO;
				imagePicker.cameraOverlayView = cameraOverlayView;
				
			}
			else {
				//imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
				imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			}
			//[self presentModalViewController:imagePicker animated:YES];
			[[[GurgleAppDelegate getAppDelegate] navigationController] presentModalViewController:imagePicker animated:YES];
		}
		else if(actionSheet.tag == kActionSheetTagNewPage){
#if defined(LITE_VERSION)
			[bannerView_ loadRequest:[GADRequest request]];
#endif
			[UIView beginAnimations:kNewPageAnimationKey context:imageView];
			[UIView setAnimationDuration:0.6];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:imageView cache:YES];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
			[UIView commitAnimations];
			for (UIView *subview in imageView.subviews) {
				if ([subview isKindOfClass:[CalloutView class]]) {
					[subview removeFromSuperview];
				}
			}
			selectedCallout = nil;
			imageView.image = nil;
			
			//切换京剧脸谱
			NSString *arts[42] = {@"蔡阳-过五关.jpg",
				@"曹洪-长坂坡.jpg",
				@"常昊-梅花脸.jpg",
				@"陈九公-封神榜.jpg",
				@"崇侯虎-进妲己.jpg",
				@"淳于导-金锁阵.jpg",
				@"崔抒-海潮珠.jpg",
				@"鄂顺-摘星楼.jpg",
				@"樊桧-鸿门宴.jpg",
				@"关平-博望坡.jpg",
				@"广成子-乾元山.jpg",
				@"黄盖-群英会.jpg",
				@"黄龙真人-九曲黄河阵.jpg",
				@"金吒-封神榜.jpg",
				@"雷震子-攻潼关.jpg",
				@"刘长-十老安刘.jpg",
				@"吕布-三英战吕布.jpg",
				@"吕岳-瘟阵.jpg",
				@"孟获-七擒孟获.jpg",
				@"魔里红-封神榜.jpg",
				@"魔里青-封神榜.jpg",
				@"魔里寿-封神榜.jpg",
				@"青背老君-衔石填海.jpg",
				@"邱引-青龙关.jpg",
				@"沙漠柯-连营寨.jpg",
				@"神龙氏-开天辟地.jpg",
				@"通天教主-三进碧游宫.jpg",
				@"魏延-战长沙.jpg",
				@"文丑-磬河战.jpg",
				@"闻仲-大回朝.jpg",
				@"夏侯渊-定军山.jpg",
				@"先蔑-摘樱会.jpg",
				@"项羽-霸王别姬.jpg",
				@"徐盛-借东风.jpg",
				@"杨戬-封神榜.jpg",
				@"伊立-火牛阵.jpg",
				@"于禁-水淹七军.jpg",
				@"元始天尊-九曲黄河阵.jpg",
				@"赵公明-封神榜.jpg",
				@"阵奇-青龙关.jpg",
				@"周纪-摘星楼.jpg",
				@"纣王-摘星楼.jpg"};
			srandom(time(NULL));
			unsigned rnd = random()%42;
			NSString *art = arts[rnd];
			artImage.image = [UIImage imageNamed:art];
			
			backgroundImageView.image = [self _getBackgroundImage];
		}
		else if(actionSheet.tag == kDeleteCallout){
			[self _removeSelectedCallout];
		}
	}
}

#pragma mark -
#pragma mark mail composite

-(IBAction) contactMe:(id)sender{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}



#pragma mark -
#pragma mark Compose Mail
-(void) shareByMail{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSString *sharePic = NSLocalizedString(@"Share picture",@"Share picture");
	
	[picker setSubject:sharePic];
	
	[picker setBccRecipients:nil];
	[picker setCcRecipients:nil];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
	//add attachement
	
	UIImage *image = [self _getUIImageToSaveOrPost];
	NSData *picData = UIImageJPEGRepresentation(image, 0.8);
	[picker addAttachmentData:picData mimeType:@"image/jpeg" fileName:@"gurgle-share.jpg"];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}


// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	NSString *suggestion = NSLocalizedString(@"Suggestion",@"Suggesion");
	[picker setSubject:suggestion];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"Gurgle_feedback@qq.com"]; 
	
	[picker setToRecipients:toRecipients];
	
	[picker setBccRecipients:nil];
	[picker setCcRecipients:nil];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	NSString *sentSuccessfully = NSLocalizedString(@"Mail sent successfully" ,@"Mail sent successfully");
	NSString *sentFail = NSLocalizedString(@"Fail to send",@"Fail to send");
	switch (result)
	{
		case MFMailComposeResultCancelled:
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			[[GurgleAppDelegate getAppDelegate] alert:nil message:sentSuccessfully];
			break;
		case MFMailComposeResultFailed:
			[[GurgleAppDelegate getAppDelegate] alert:@"Sorry" message:sentFail];
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *suggestion = NSLocalizedString(@"Suggestion",@"Suggesion");
	suggestion = [suggestion stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *email = [NSString stringWithFormat:@"mailto:Gurgle_feedback@qq.com?subject=%@&body=",suggestion];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"MemoryWarning");
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


@end

