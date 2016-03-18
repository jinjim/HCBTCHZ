//
//  OrderSelectVController.h
//  HCBTCHZ
//
//  Created by itte on 16/3/7.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "BaseVController.h"

@protocol OrderSelectDelegate <NSObject>
// 货物描述选择
- (void) goodsDescriptionSelect:(NSDictionary *)dict;
// 货物定价
- (void) goodsPriceConfirm:(NSDictionary *)dict;
// 车型选择
- (void) carTypeSelect:(NSString *)carType;
// 订单指派
- (void) orderSendSome:(NSDictionary *)dict;
@end

@interface OrderSelectVController : BaseVController

@property (weak, nonatomic) id<OrderSelectDelegate> delegate;
@end
