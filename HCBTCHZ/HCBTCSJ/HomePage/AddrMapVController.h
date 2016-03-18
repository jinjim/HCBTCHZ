//
//  AddrMapVController.h
//  HCBTCHZ
//
//  Created by itte on 3/3/16.
//  Copyright © 2016 itte. All rights reserved.
//

#import "BaseVController.h"

@protocol AddressSearchDelegate <NSObject>
@optional
- (void) didSelectSearchAddress:(AddressModel *)address;

@end

@interface AddrMapVController : BaseVController
@property (weak, nonatomic) id<AddressSearchDelegate> delegate;
@end
