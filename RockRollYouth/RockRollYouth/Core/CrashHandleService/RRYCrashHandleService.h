//
//  RRYCrashHandleService.h
//  RockRollYouth
//
//  Created by jd.huaxiaochun on 16/8/31.
//  Copyright © 2016年 slipknot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRYCrashHandleService : NSObject

+ (void)crashRegist;

+ (void)crashHandle;

+ (void)uploadExceptionHandler:(void (^)(BOOL success))result;

@end
