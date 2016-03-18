//
//  MKNetworkManager.m
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//
#import "AFNetworkManager.h"

// 是否需要自定义HTTP-Header 0-不需要；1-需要
#define KHttpHeadParam 0

// https 证书文件名
#define KHttpsFileName @"test.crt"
// https 证书密码
#define KHttpsPassword @"pwd123"

// 请求参数类型
#define KRequestType   RequestTypeJSON

@interface AFNetworkManager ()
@property (strong, nonatomic) AFHTTPSessionManager *httpManager;
@property (assign, nonatomic) RequestDataType requestDataType;
@property (assign, nonatomic) ResponseDataType responseDataType;
@end

@implementation AFNetworkManager


#pragma mark - 基础网络配置
+(AFNetworkManager *)sharedInstance
{
    static dispatch_once_t onceTocken;
    __strong static id _sharedObject = nil;
    dispatch_once(&onceTocken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 * 创建AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)httpManager
{
    if (_httpManager == nil)
    {
        NSString *baseURL = kBaseURL;
        self.requestDataType = RequestTypePlainText;
        self.responseDataType = ResponseTypeJSON;
        _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: baseURL]];
        [self configDataFormat];
    }
    return _httpManager;
}
/**
 * 配置请求和返回的数据格式
 */
- (void)configDataFormat
{
    // 请求参数配置
    switch (self.requestDataType) {
        case RequestTypeJSON:
            _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
            [_httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [_httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        case RequestTypePlainText:
            _httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
    // 请求返回数据配置
    switch (self.responseDataType) {
        case ResponseTypeJSON:
            _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case ResponseTypeXML:
            _httpManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case ResponseTypeData:
            _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    _httpManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    NSSet *contentSet = [NSSet setWithArray:@[@"application/json",
                                              @"text/html",
                                              @"text/json",
                                              @"text/plain",
                                              @"text/javascript",
                                              @"text/xml",
                                              @"image/*"]];
    _httpManager.responseSerializer.acceptableContentTypes = contentSet;
    // 设置允许同时最大并发数量，过大容易出问题
    _httpManager.operationQueue.maxConcurrentOperationCount = 5;
}


#pragma mark - http get请求
-(void)AFNHttpGetWithAPI:(NSString *)apiName
            andDictParam:(NSDictionary *)dictParam
        requestSuccessed:(RequestSuccessed)requestSuccessed
          requestFailure:(RequestFailure)requestFailure
{
    [self.httpManager GET:apiName parameters:dictParam progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@",responseObject);
        CommonModel *commModel = [CommonModel mj_objectWithKeyValues:responseObject];
        if ([commModel.Status integerValue] > 0) {
            requestSuccessed(commModel.Value);
        }
        else{
            requestFailure([commModel.Status integerValue], commModel.Message);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        requestFailure(error.code, error.description);
    }];
}

#pragma mark - http post请求
-(void)AFNHttpRequestWithAPI:(NSString *)apiName
                andDictParam:(NSDictionary *)dictParam
            requestSuccessed:(RequestSuccessed)requestSuccessed
              requestFailure:(RequestFailure)requestFailure
{
    [self.httpManager POST:apiName parameters:dictParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        CommonModel *commModel = [CommonModel mj_objectWithKeyValues:responseObject];
        if ([commModel.Status integerValue] > 0) {
            requestSuccessed(commModel.Value);
        }
        else{
            requestFailure([commModel.Status integerValue], commModel.Message);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        requestFailure(error.code, error.description);
    }];
}
@end
