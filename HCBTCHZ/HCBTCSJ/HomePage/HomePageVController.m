//
//  HomePageVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "HomePageVController.h"
#import "UserLoginVController.h"

@interface HomePageVController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgTotalCar;
@property (weak, nonatomic) IBOutlet UIImageView *imgSectionCar;
@property (weak, nonatomic) IBOutlet UIImageView *imgWallet;
@property (weak, nonatomic) IBOutlet UIImageView *imgAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgDriver;

@property (strong, nonatomic) NSArray *vcArray;

@end

@implementation HomePageVController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.imgSearch bk_whenTapped:^{
//        [self btnNextPageClick:0];
//    }];
    [self.imgTotalCar bk_whenTapped:^{
        [self btnNextPageClick:0];
    }];
    [self.imgSectionCar bk_whenTapped:^{
        [self btnNextPageClick:1];
    }];
    [self.imgWallet bk_whenTapped:^{
        [self btnNextPageClick:2];
    }];
    [self.imgAddress bk_whenTapped:^{
        [self btnNextPageClick:3];
    }];
    [self.imgDriver bk_whenTapped:^{
        [self btnNextPageClick:4];
    }];
}

- (NSArray *)vcArray
{
    if (_vcArray == nil) {
        _vcArray = @[@"CreateOrderVController",@"CreateOrderVController",@"",@"AddressListVController",@"MyDriverVController"];
    }
    return _vcArray;
}


- (void)fds:(id)sender
{
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setObject:@"15882241557" forKey:@"username"];
    [dictParam setObject:@"123123" forKey:@"pwd"];
    [dictParam setObject:@"354054023630790" forKey:@"imei"];
    [[AFNetworkManager sharedInstance] AFNHttpGetWithAPI:KLogin andDictParam:dictParam requestSuccessed:^(id responseObject) {
        
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        
    }];
}


- (void) btnNextPageClick:(NSInteger)index
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (index < 2) {
        [dict setValue:@(index) forKey:@"type"];
    }
    [self pushViewController:self.vcArray[index] withParams:dict];
}

@end
