//
//  AddressListVController.h
//  HCBTCHZ
//
//  Created by itte on 16/3/4.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "BaseVController.h"

@protocol AddressSelectDelegate <NSObject>
@optional
- (void) didSelectAddress:(AddressModel *)address;

@end

@interface AddressListVController : BaseVController
@property (weak, nonatomic) id<AddressSelectDelegate> delegate;
@end
