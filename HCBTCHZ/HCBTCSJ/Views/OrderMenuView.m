//
//  OrderMenuView.m
//  HCBTCHZ
//
//  Created by itte on 16/3/14.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "OrderMenuView.h"

@implementation OrderMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    if (self = [super init]) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderMenuView" owner:nil options:nil];
        self = [nibView objectAtIndex:0];
    }
    return self;
}

@end
