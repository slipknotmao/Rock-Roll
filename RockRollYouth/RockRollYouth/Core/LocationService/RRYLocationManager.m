//
//  JDTDLocationManager.h
//  JDFRiskSDK
//
//  Created by jd.huaxiaochun on 16/4/29.
//  Copyright © 2016年 jd.slipknot. All rights reserved.
//

#import "RRYLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define ALERT_VIEW_SETTING_TAG      1001            // alertView setting tag
const static CGFloat kLocationitude = - 6666.66f;   // init locationitude

@implementation RRYLocationInfoData

@end

@interface RRYLocationManager () <CLLocationManagerDelegate, UIAlertViewDelegate>

/*! @abstract 位置管理对象 */
@property (strong, nonatomic) CLLocationManager *locationManager;
/*! @abstract 位置对象 */
@property (strong, nonatomic) CLLocation *location;
/*! @abstract 地理编码器对象 */
@property (strong, nonatomic) CLGeocoder *geocoder;
/*! @abstract 位置更新block */
@property (copy, nonatomic) LocationUpdateHandler locationUpdateHandle;
@property (copy, nonatomic, readwrite) NSString *strLongitude;
@property (copy, nonatomic, readwrite) NSString *strLatitude;

@end

static RRYLocationManager *locationManagerSharedInstance = nil;

@implementation RRYLocationManager

#pragma mark - ClassMethod

/*!
 * @brief 位置更新handle
 *
 * @param locationUpdateHandle handle
 */
+ (void)locationUpdateWithHandler:(LocationUpdateHandler)locationUpdateHandle{
    [self sharedInstance].locationUpdateHandle = locationUpdateHandle;
    // 开始位置定位
    [[self sharedInstance] startLocationPositioning];
}

/*!
 * @brief  单例
 *
 * @return instance
 */
+ (RRYLocationManager *)sharedInstance{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        locationManagerSharedInstance = [[RRYLocationManager alloc] init];
    });
    return locationManagerSharedInstance;
}

#pragma mark - Init
/*!
 * @brief  分配初始化
 *
 * @return instance
 */
- (instancetype)init{
    self = [super init];
    if (self) {
        // 初始化定位管理容器对象
        _locationManager = [[CLLocationManager alloc] init];
        // 设置代理
        _locationManager.delegate = self;
        // 设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 初始化默认不存在经纬度
        _location = [[CLLocation alloc] initWithLatitude:kLocationitude longitude:kLocationitude];
        // 初始化地理编码对象
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

#pragma mark - InstanceMethod
/*!
 * @brief 开始位置定位
 */
- (void)startLocationPositioning{
    if ([CLLocationManager locationServicesEnabled] && _locationManager) {
#ifdef __IPHONE_8_0
        if (IOS_VERSION >= 8.0) {
            // 使用时设置(应用前台场景时请求)
            [_locationManager requestWhenInUseAuthorization];
            // 始终设置(应用后台场景时请求)
            //[_locationManager requestAlwaysAuthorization];
        }
#endif
        // 开始更新用户位置
        [_locationManager startUpdatingLocation];
    }
}

/*!
 * @brief 停止位置定位
 */
- (void)stopLocationPositioning{
    if (_locationManager) {
        // 停止更新位置
        [_locationManager stopUpdatingLocation];
    }
    _location = nil;
    _location = [[CLLocation alloc] initWithLatitude:kLocationitude longitude:kLocationitude];
}

/*!
 * @brief 反地理编码位置
 */
- (void)reverseGeocodeLocation{
    if (_location && _geocoder && _location.coordinate.longitude != kLocationitude && _location.coordinate.latitude != kLocationitude) {
        if (_geocoder.geocoding) {
            // 地理编码中则先挂起
            [_geocoder cancelGeocode];
        }
        __weak __typeof(self) weakSelf = self;
        // 地理编码block
        [_geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error && placemarks.count > 0) {
                for (CLPlacemark *placemark in placemarks) {
                    // 常用placemark字段
                    __unused NSDictionary *dic = placemark.addressDictionary;
                    __unused NSString *Country = [placemark.addressDictionary objectForKey:@"Country"];
                    __unused NSString *CountryCode = [placemark.addressDictionary objectForKey:@"CountryCode"];
                    __unused NSString *name = [placemark.addressDictionary objectForKey:@"Name"];
                    __unused NSString *street = [placemark.addressDictionary objectForKey:@"Street"];
                    __unused NSString *subThoroughfare = [placemark.addressDictionary objectForKey:@"SubThoroughfare"];
                    __unused NSString *thorougfare = [placemark.addressDictionary objectForKey:@"Thoroughfare"];
                    __unused NSString *state = [placemark.addressDictionary objectForKey:@"State"];
                    __unused NSString *city = [placemark.addressDictionary objectForKey:@"City"];
                    __unused NSString *subLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
                    
                    // 初始化自定义位置对象
                    RRYLocationInfoData *locationInfoData = [[RRYLocationInfoData alloc] init];
                    locationInfoData.province = Country;
                    locationInfoData.city = city;
                    locationInfoData.area = street;
                    locationInfoData.longitude = placemark.location.coordinate.longitude;
                    locationInfoData.latitude = placemark.location.coordinate.latitude;
                    // block
                    weakSelf.locationUpdateHandle(locationInfoData);
                    
                }
            }
            // 挂起地理编码
            [_geocoder cancelGeocode];
        }];
    }
}

#pragma mark - CLLocationManagerDelegate
/*!
 * @brief 位置更新回调
 *
 * @param manager   位置管理
 * @param locations 位置集合
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.count > 0) {
        // 获取第一个位置对象
        _location = locations[0];
        self.strLongitude = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
        self.strLatitude = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
        [self reverseGeocodeLocation];
    }
    // 更新后就停止位置服务 注释掉则一直更新回调
    [manager stopUpdatingLocation];
}

/*!
 * @brief 定位失败回调
 *
 * @param manager 位置管理
 * @param error   错误对象
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self stopLocationPositioning];
}

/*!
 * @brief 位置服务状态变化回调
 *
 * @param manager 位置管理
 * @param status  位置服务状态
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [manager startUpdatingLocation];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIAlertDelegate
/*!
 * @brief 点击alertView按钮回调
 *
 * @param alertView   alertView
 * @param buttonIndex 点击按钮索引
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (ALERT_VIEW_SETTING_TAG == alertView.tag) {
        if (buttonIndex == 0) {
            // 设置
            if (&UIApplicationOpenSettingsURLString != NULL) {
                // openURL 设置服务
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
            }
        }
    }
}

@end
