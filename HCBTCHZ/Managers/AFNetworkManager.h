//
//  MKNetworkManager.h
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

// 请求方式
typedef NS_ENUM(NSInteger, AFNRequestType)
{
    AFNHttpGET,
    AFNHttpPOST,
    AFNHttpsGET,
    AFNHttpsPOST
};

// 请求数据返回格式
typedef NS_ENUM(NSUInteger, ResponseDataType) {
    ResponseTypeJSON = 1, // 默认
    ResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    ResponseTypeData = 3
};

// 请求参数格式
typedef NS_ENUM(NSUInteger, RequestDataType) {
    RequestTypeJSON = 1, // 默认
    RequestTypePlainText  = 2 // 普通text/html
};

typedef void (^RequestSuccessed)(id responseObject);
typedef void (^RequestFailure)(NSInteger errorCode, NSString *errorMessage);

@interface AFNetworkManager : NSObject


+(AFNetworkManager *)sharedInstance;

// http get请求
-(void)AFNHttpGetWithAPI:(NSString *)apiName
            andDictParam:(NSDictionary *)dictParam
        requestSuccessed:(RequestSuccessed)requestSuccessed
          requestFailure:(RequestFailure)requestFailure;

// http post请求
-(void)AFNHttpRequestWithAPI:(NSString *)apiName
                andDictParam:(NSDictionary *)dictParam
            requestSuccessed:(RequestSuccessed)requestSuccessed
              requestFailure:(RequestFailure)requestFailure;

//// http post上传文件
//-(void)MKHttpUpLoadImgWithAPI:(NSString *)apiName
//             andWordDictParam:(NSDictionary *)dictWordParam
//                   andImgDict:(NSDictionary *)dictImageParam
//             requestSuccessed:(RequestSuccessed)requestSuccessed
//               requestFailure:(RequestFailure)requestFailure;
//
//// http post请求(自定义请求Body)
//-(void)MKHttpRequestWithAPI:(NSString *)apiName
//                andStrParam:(NSString *)bodyParam
//           requestSuccessed:(RequestSuccessed)requestSuccessed
//             requestFailure:(RequestFailure)requestFailure;
@end
