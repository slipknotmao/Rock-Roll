//
//  RRYDeviceInfoService.h
//  RockRollYouth
//
//  Created by jd.huaxiaochun on 16/8/31.
//  Copyright © 2016年 slipknot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRYDeviceInfoService : NSObject

@property (nonatomic, strong, readonly) NSString *appId;
@property (nonatomic, strong, readonly) NSString *appName;
@property (nonatomic, strong, readonly) NSString *appVersion;
@property (nonatomic, strong, readonly) NSString *platform;
@property (nonatomic, strong, readonly) NSString *osSystemVersion;
@property (nonatomic, strong, readonly) NSString *resolution;
@property (nonatomic, strong, readonly) NSString *channelInfo;
@property (nonatomic, strong, readonly) NSString *networkType;
@property (nonatomic, strong, readonly) NSString *deviceModel;
@property (nonatomic, strong, readonly) NSString *ipAddress;
@property (nonatomic, strong, readonly) NSString *identifierForVendor;
@property (nonatomic, strong, readonly) NSString *advertisingIdentifier;
@property (nonatomic, strong, readonly) NSString *uuid;
@property (nonatomic, strong, readonly) NSString *fcuuid;
@property (nonatomic, strong, readonly) NSString *longitude;
@property (nonatomic, strong, readonly) NSString *latitude;

+ (RRYDeviceInfoService *)sharedInstance;

@end
