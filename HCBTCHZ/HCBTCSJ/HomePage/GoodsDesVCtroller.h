//
//  GoodsDesVCtroller.h
//  HCBTCHZ
//
//  Created by itte on 16/3/8.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "BaseVController.h"

@protocol GoodsDescriptionDelegate <NSObject>
- (void)selectedItem:(NSString *)desc;
@end

@interface GoodsDesVCtroller : BaseVController
@property (weak, nonatomic) id<GoodsDescriptionDelegate> delegate;

@end
