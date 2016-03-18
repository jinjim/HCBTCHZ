//
//  NSString+More.h
//  HCBTCSJ
//
//  Created by itte on 16/2/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (More)
// 字符串判空
- (BOOL)isEmpty;
// 是否全是数字
- (BOOL)isAllNumbers;
// 去掉空格和换行回车
- (NSString *)trimString;
// 判断是否包含某子字符串
- (BOOL)isContainString:(NSString *)subString;
// 生成MD5字符串
- (NSString *)md5FromString;
// 字符串拼接在后面
- (NSString *)addString:(NSString *)subString;
// 手机号码验证
- (BOOL)isMobilePhone;
//身份证号
- (BOOL)isIdentityCard;
@end
