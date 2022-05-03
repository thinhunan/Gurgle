//
//  QQWeiboApi.h
//  Gurgle
//
//  Created by Think on 11-4-24.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboApi.h"
#import "IPAddress.h"

@interface QQWeiboApi : WeiboApi {
	NSString* ipAddress;
}
-(NSString *) getIpAddress;
@end
