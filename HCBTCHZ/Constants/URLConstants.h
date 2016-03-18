//
//  URLConstants.h
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//

#ifndef URLConstants_h
#define URLConstants_h


//#define kBaseURL                  @"http://dev.gc.56qq.com:8014/"
#define kBaseURL                  @"http://192.168.2.190:85/"


#pragma mark - 登录注册相关
#define KLogin                     @"Login.ashx"                  // 登录接口
#define KRegister                  @"RegistCargoOwner.ashx"       // 注册接口
#define KSendMessage               @"SendMessage.ashx"            // 获取验证码

#define KResetPassword             @"ResetPassword.ashx"          // 重置密码



#pragma mark - 地址相关接口
#define KGetCommonAddress          @"GetCommonAddresses.ashx"         // 获取常用地址
#define KSaveCommonAddress         @"SaveCommonAddress.ashx"          // 添加常用地址
#define KDeleteCommonAddress       @"DeleteCommonAddress.ashx"        // 删除常用地址

#pragma mark - 常用司机接口
#define KGetCommonDriver           @"GetCommonDrivers.ashx"           // 获取常用司机
#define KAddDriver                 @"AddDriver.ashx"                  // 添加常用司机
#define KDeleteDriver              @"DeleteDriver.ashx"               // 删除常用司机
#define KSearchDriver              @"GetCommonDriversByFiter.ashx"    // 搜索常用司机


#pragma mark - 订单相关
#define KGetGoodsType              @"GetGoodsType.ashx"               // 获取货物类型描述

/**
 * 激光推送相关账号
 */
#define KJPushAccount              @"85de8bb4532252f90a5f059b"

#endif /* URLConstants_h */
