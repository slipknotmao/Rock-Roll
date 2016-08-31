//
//  RRYCrashHandleService.m
//  RockRollYouth
//
//  Created by jd.huaxiaochun on 16/8/31.
//  Copyright © 2016年 slipknot. All rights reserved.
//

#import "RRYCrashHandleService.h"
#import "RRYDeviceInfoService.h"

#define CATCH_CRASH_FILE    @"crash"
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@implementation RRYCrashHandleService

+ (void)crashRegist {
    NSSetUncaughtExceptionHandler(&handleException);
    [self crashHandle];
}

+ (void)crashHandle {
    //TODO: JSPatch热修复
    //TODO: 清除本地缓存 清除可能崩溃的资源
}

void handleException(NSException * exception)
{
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"name:%@reason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    if ([content isKindOfClass:[NSString class]] && content.length > 0) {
        DDLogError(@"content is %@",content);
        content = [content stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@"---"];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"***"];
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        DDLogError(@"content is %@",content);
        [RRYCrashHandleService setCatchCrashPathWithContent:content];
    }
}

/*!
 *  @brief crash保存本地
 *
 *  @param content crash
 *
 *  @return BOOL
 */
+ (BOOL)setCatchCrashPathWithContent:(NSString *)content {
    //保存到本地,下次启动的时候，上传这个log
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    [fileManager removeItemAtPath:CATCH_CRASH_FILE error:nil];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:CATCH_CRASH_FILE];
    
    NSMutableData  *writer = [[NSMutableData alloc] init];
    [writer appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    return [writer writeToFile:path atomically:YES];
}

/*!
 *  @brief 获取本地crashPath
 *
 *  @return
 */
+ (NSString *)getCatchCrashPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:CATCH_CRASH_FILE];
    return path;
}

/*!
 *  @brief 移除本地crashLog
 */
+ (void)removeOldLog {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self getCatchCrashPath];
    if ([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:CATCH_CRASH_FILE error:nil];
    }
}

/*!
 *  @brief 上传crash请求
 *
 *  @param logStr crashLog
 *  @param result result
 */
+ (void)uploadLogInfo:(NSString *)logStr resultBlock:(void (^)(BOOL success))result {
    
    //TODO: url?
    NSURL *url = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSData* postData = [logStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   result(NO);
                                   NSLog(@"UpLoadCatchCrashError:%@%ld", error.localizedDescription,(long)error.code);
                               }else{
                                   
                                   NSError *err = nil;
                                   NSDictionary *rDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"code"]];
                                   
                                   if ([codeStr isEqualToString:@"0"]) {
                                       [self removeOldLog];
                                       result(YES);
                                   }else{
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       NSLog(@"UpLoadCatchCrashCode:%ld", (long)responseCode);
                                       result(NO);
                                   }
                               }
                           }];
}

/*!
 *  @brief 再次启动程时上传异常数据
 *
 *  @param result 结果
 */
+ (void)uploadExceptionHandler:(void (^)(BOOL success))result {
    
    NSString *path = [self getCatchCrashPath];
    NSData* reader = [NSData dataWithContentsOfFile:path];
    NSString *log = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    
    if (log.length > 0) {
        [self uploadLogInfo:log resultBlock:^(BOOL success){
            result(success);
        }];
    }
}

@end
