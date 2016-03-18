//
//  GoodsDescCell.m
//  HCBTCHZ
//
//  Created by itte on 16/3/8.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "GoodsDescCell.h"

@implementation GoodsDescCell

- (void)awakeFromNib {
    // Initialization code
    self.btnTitle.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnTitle.layer.borderWidth = 1.0;
    self.btnTitle.layer.cornerRadius = 5;
}

@end
