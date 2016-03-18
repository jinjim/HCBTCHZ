//
//  RootNaviVCtroller.h
//  HCB
//
//  Created by user on 16/2/20.
//  Copyright (c) 2016年 funmain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNaviVCtroller : UINavigationController
- (void)setTabBarItem:(UITabBarItem *)tabBarItem
            withTitle:(NSString *)title
        withTitleSize:(CGFloat)titleSize
        selectedImage:(UIImage *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
      unselectedImage:(UIImage *)unselectedImage
 unselectedTitleColor:(UIColor *)unselectColor;

@end

@interface HomeNaviVCtroller : BaseNaviVCtroller
@end

@interface NearbyNaviVCtroller : BaseNaviVCtroller

@end

@interface MyOrderNaviVCtroller : BaseNaviVCtroller

@end

@interface ProfileNaviVCtroller : BaseNaviVCtroller

@end