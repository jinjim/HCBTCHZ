//
//  NSString+More.m
//  HCBTCSJ
//
//  Created by itte on 16/2/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "NSString+More.h"

@implementation NSString (More)
//字符串判空
- (BOOL)isEmpty
{
    return !([self length] && [self stringByReplacingOccurrencesOfString:@" " withString:@""]);
}

// 是否全是数字
- (BOOL)isAllNumbers
{
    NSString *numRegex = @"^[0-9]\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    return [predicate evaluateWithObject:self];
}

// 判断是否包含某子字符串
- (BOOL)isContainString:(NSString *)subString
{
    return [self rangeOfString:subString].location != NSNotFound;
}

//去掉空格和换行回车
- (NSString *)trimString
{
    if (self == nil)
    {
        return @"";
    }
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


// 生成MD5字符串
- (NSString *)md5FromString
{
    if ([self isEmpty]) {
        return @"";
    }
    const char *cStr = [[self trimString] UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(uint32_t)strlen(cStr),digest);
    
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

// 字符串拼接在后面
- (NSString *)addString:(NSString *)subString
{
    return [NSString stringWithFormat:@"%@%@",self, subString];
}

//手机号码验证
- (BOOL)isMobilePhone
{
    NSString *phoneRegex = @"(^(01|1)[3,4,5,8][0-9])\\d{8}$" ;
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

//身份证号
- (BOOL)isIdentityCard
{
    if (self.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}
@end
