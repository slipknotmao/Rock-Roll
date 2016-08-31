//
//  RRYDeviceInfoService.m
//  RockRollYouth
//
//  Created by jd.huaxiaochun on 16/8/31.
//  Copyright © 2016年 slipknot. All rights reserved.
//

#import "RRYDeviceInfoService.h"
#import "IPAddress.h"
#import <sys/utsname.h>
#import <AdSupport/ASIdentifierManager.h>

@interface RRYDeviceInfoService ()

@property (nonatomic, strong, readwrite) NSString *appId;
@property (nonatomic, strong, readwrite) NSString *appName;
@property (nonatomic, strong, readwrite) NSString *appVersion;
@property (nonatomic, strong, readwrite) NSString *platform;
@property (nonatomic, strong, readwrite) NSString *osSystemVersion;
@property (nonatomic, strong, readwrite) NSString *resolution;
@property (nonatomic, strong, readwrite) NSString *channelInfo;
@property (nonatomic, strong, readwrite) NSString *networkType;
@property (nonatomic, strong, readwrite) NSString *deviceModel;
@property (nonatomic, strong, readwrite) NSString *ipAddress;
@property (nonatomic, strong, readwrite) NSString *identifierForVendor;
@property (nonatomic, strong, readwrite) NSString *advertisingIdentifier;
@property (nonatomic, strong, readwrite) NSString *uuid;
@property (nonatomic, strong, readwrite) NSString *longitude;
@property (nonatomic, strong, readwrite) NSString *latitude;

@end

static RRYDeviceInfoService *deviceInfoService;

@implementation RRYDeviceInfoService

#pragma mark - ClassMethod

+ (RRYDeviceInfoService *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceInfoService = [[RRYDeviceInfoService alloc] init];
    });
    return deviceInfoService;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        // 位置服务回调
        __weak typeof(self) weakSelf = self;
        [RRYLocationManager locationUpdateWithHandler:^(RRYLocationInfoData *locationInfoData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.longitude = [[RRYLocationManager sharedInstance] strLongitude];
            strongSelf.latitude = [[RRYLocationManager sharedInstance] strLatitude];
        }];
        [self deviceInfo];
    }
    return self;
}

#pragma mark - PrivateMethod

- (void)deviceInfo {
    self.appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    self.appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    self.platform = [[UIDevice currentDevice] systemName];
    self.osSystemVersion = [[UIDevice currentDevice] systemVersion];
    self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.resolution = [NSString stringWithFormat:@"%f * %f", [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height];
    self.channelInfo = @"AppStore";
    self.networkType = [self currentNetworkType];
    self.deviceModel = [self platform];
    self.ipAddress = [self getIPAddress];
    self.identifierForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    self.advertisingIdentifier = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] ? [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] : @"";
    self.uuid = [[NSUUID UUID] UUIDString];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"appId = %@, appName = %@, platform = %@, osSystemVersion = %@, appVersion = %@, resolution = %@, channelInfo = %@, networkType = %@, deviceModel = %@, ipAddress = %@, identifierForVendor = %@, advertisingIdentifier = %@, uuid = %@", self.appId, self.appName, self.platform, self.osSystemVersion, self.appVersion, self.resolution, self.channelInfo, self.networkType, self.deviceModel, self.ipAddress, self.identifierForVendor, self.advertisingIdentifier, self.uuid];
}

/*!
 *  @brief  转换设备型号
 *
 *  @return 设备型号
 */
- (NSString *)platform{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

- (NSString *)getIPAddress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

/*!
 *  @brief 当前网络状态
 *
 *  @return 状态str
 */
- (NSString *)currentNetworkType{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == ReachableViaWWAN) {
        return @"WWAN";
    } else if (netStatus == ReachableViaWiFi) {
        return @"WIFI";
    } else {
        return @"Newwork Not Connected";
    }
}

@end
