//
//  UIImageScrollView.h
//  Gurgle
//
//  Created by Think on 11-3-30.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageScrollView : UIScrollView {
	UIImageView *imageView;
}
@property(nonatomic,retain) IBOutlet UIImageView *imageView;
@end
