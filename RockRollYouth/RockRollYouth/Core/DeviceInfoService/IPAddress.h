//
//  IPAddress.h
//  JDMobile
//
//  Created by heweihua on 15/10/15.
//  Copyright © 2015年 jr. All rights reserved.
//

// Implicit declaration of function 'ether_ntoa' is invalid in C99:
//http://stackoverflow.com/questions/11245280/implicit-declaration-of-function-ether-ntoa-is-invalid-in-c99

#ifndef IPAddress_h
#define IPAddress_h

#define MAXADDRS    32
extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];
//Function prototypes
void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();

#endif /* IPAddress_h */


// 引用.c文件， 在xxx.pch中，需要：
//#ifdef __OBJC__
//#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
//#endif


//- (NSString *)deviceIPAdress {
//    InitAddresses();
//    GetIPAddresses();
//    GetHWAddresses();
//    
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
//}