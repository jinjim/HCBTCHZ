//
//  FastOrderVController.h
//  HCBTCHZ
//
//  Created by itte on 3/3/16.
//  Copyright © 2016 itte. All rights reserved.
//

#import "BaseVController.h"

@protocol OrderAddressDelegate <NSObject>

- (void)orderAddressSelected:(NSDictionary *)dict;

@end

@interface OrderInfoVController : BaseVController
@property (weak, nonatomic) id<OrderAddressDelegate> delegate;
@end
