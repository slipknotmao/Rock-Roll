//
//  JDTDLocationManager.h
//  JDFRiskSDK
//
//  Created by jd.huaxiaochun on 16/4/29.
//  Copyright © 2016年 jd.slipknot. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YMLOCATION_BD09LL     @"bd09ll"   // bd09ll（百度经纬度坐标）
#define YMLOCATION_BD09MC     @"bd09mc"   // bd09mc（百度摩卡托坐标）
#define YMLOCATION_GCJ02      @"gcj02"    // gcj02（国测局加密坐标）火星
#define YMLOCATION_WGS84      @"wgs84"    // wgs84（gps设备获取的坐标或苹果坐标）

@interface RRYLocationInfoData : NSObject

/*! @abstract 省 */
@property (strong, nonatomic) NSString *province;
/*! @abstract 市 */
@property (strong, nonatomic) NSString *city;
/*! @abstract 区 */
@property (strong, nonatomic) NSString *area;
/*! @abstract 经度 */
@property (assign, nonatomic) double longitude;
/*! @abstract 纬度 */
@property (assign, nonatomic) double latitude;

@end

/*! @abstract 定义位置更新block */
typedef void(^LocationUpdateHandler)(RRYLocationInfoData *locationInfoData);

@interface RRYLocationManager : NSObject

@property (copy, nonatomic, readonly) NSString *strLongitude;
@property (copy, nonatomic, readonly) NSString *strLatitude;

/*! 
 * @brief  单例
 *
 * @return instance
 */
+ (RRYLocationManager *)sharedInstance;

/*!
 * @brief 位置更新handle
 *
 * @param locationUpdateHandle handle
 */
+ (void)locationUpdateWithHandler:(LocationUpdateHandler)locationUpdateHandle;

/*!
 * @brief 开始位置定位
 */
- (void)startLocationPositioning;

@end
