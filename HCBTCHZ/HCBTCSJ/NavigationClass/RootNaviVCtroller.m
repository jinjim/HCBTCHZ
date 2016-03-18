//
//  RootNaviVCtroller.m
//  HCB
//
//  Created by user on 16/2/20.
//  Copyright (c) 2016年 funmain. All rights reserved.
//

#import "RootNaviVCtroller.h"


@implementation HomeNaviVCtroller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem:self.tabBarItem withTitle:@"首页" withTitleSize:13.0 selectedImage:[UIImage imageNamed:@"tab_home_sel"] selectedTitleColor:[UIColor orangeColor] unselectedImage:[UIImage imageNamed:@"tab_home_btn"]  unselectedTitleColor:[UIColor blackColor]];
}
@end

@implementation NearbyNaviVCtroller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem:self.tabBarItem withTitle:@"附近" withTitleSize:13.0 selectedImage:[UIImage imageNamed:@"tab_nearby_sel"] selectedTitleColor:[UIColor orangeColor] unselectedImage:[UIImage imageNamed:@"tab_nearby_btn"]  unselectedTitleColor:[UIColor blackColor]];
}
@end

@implementation MyOrderNaviVCtroller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem:self.tabBarItem withTitle:@"运单" withTitleSize:13.0 selectedImage:[UIImage imageNamed:@"tab_waybill_sel"] selectedTitleColor:[UIColor orangeColor] unselectedImage:[UIImage imageNamed:@"tab_waybill_btn"]  unselectedTitleColor:[UIColor blackColor]];
}
@end

@implementation ProfileNaviVCtroller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarItem:self.tabBarItem withTitle:@"我的" withTitleSize:13.0 selectedImage:[UIImage imageNamed:@"tab_mine_sel"] selectedTitleColor:[UIColor orangeColor] unselectedImage:[UIImage imageNamed:@"tab_mine_btn"]  unselectedTitleColor:[UIColor blackColor]];
}
@end


@implementation BaseNaviVCtroller
- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 自定义tabbar
- (void)setTabBarItem:(UITabBarItem *)tabBarItem
            withTitle:(NSString *)title
        withTitleSize:(CGFloat)titleSize
        selectedImage:(UIImage *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
      unselectedImage:(UIImage *)unselectedImage
 unselectedTitleColor:(UIColor *)unselectColor
{
    //设置图片
    tabBarItem = [tabBarItem initWithTitle:title image:[unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont systemFontOfSize:titleSize]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont systemFontOfSize:titleSize]} forState:UIControlStateSelected];
}

@end