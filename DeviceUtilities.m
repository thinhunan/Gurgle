//
//  DeviceUtilities.m
//  PicTell2
//
//  Created by Think on 11-2-20.
//  Copyright 2011 ThinK's Studio. All rights reserved.
//

#import "DeviceUtilities.h"


@implementation DeviceUtilities
+(BOOL)isIOS4{
	UIDevice *currentDevice = [UIDevice currentDevice];
	NSString *systemVersion = [currentDevice systemVersion];
	double version = [systemVersion doubleValue];
	if (version >= 4.0) {
		return true;
	}
	return false;
}
@end
