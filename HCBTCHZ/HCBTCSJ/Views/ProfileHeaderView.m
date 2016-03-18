//
//  ProfileHeaderView.m
//  HCBTCHZ
//
//  Created by itte on 16/3/15.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "ProfileHeaderView.h"

@implementation ProfileHeaderView

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
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:nil options:nil];
        self = [nibView objectAtIndex:0];
    }
    return self;
}
@end
