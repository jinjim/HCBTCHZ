//
//  BaseVController.m
//  IFP
//
//  Created by user on 16/2/20.
//  Copyright (c) 2016年 funmain. All rights reserved.
//

#import "BaseVController.h"

@interface BaseVController ()

@end

@implementation BaseVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - push & pop & dismiss view controller
-(void)pushViewController:(NSString *)className
               withParams:(NSDictionary *)paramDict
{
    UIViewController *pushedViewController = nil;
    if (pushedViewController == nil)
    {
        @try {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            pushedViewController = [storyboard instantiateViewControllerWithIdentifier:className];
        }
        @catch (NSException *exception) {
            // NSLog(@"---");
        }
        
    }
    
    if (!pushedViewController)
    {
        pushedViewController = [[NSClassFromString(className) alloc] init];
    }
    if (![pushedViewController isKindOfClass:[UIViewController class]])
    {
        NSLog(@"class[%@] is not ViewController!", className);
        return ;
    }
    else if ([pushedViewController isKindOfClass:[BaseVController class]])
    {
        [(BaseVController *)pushedViewController setParams:[NSDictionary dictionaryWithDictionary:paramDict]];
    }
    pushedViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushedViewController animated:YES];
}

-(void)pushViewController:(NSString *)className
{
    [self pushViewController:className withParams:nil];
}

-(void)presentViewcontroller:(NSString *)className animated:(BOOL)flag
{
    UIViewController *pushedViewController = [[NSClassFromString(className) alloc] init];
    if (![pushedViewController isKindOfClass:[UIViewController class]])
    {
        NSLog(@"class[%@] is not ViewController!", className);
        return ;
    }
    [self presentViewController:pushedViewController animated:flag completion:^{
        
    }];
}

- (void)popViewController
{
    // 如果是导航控制器
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)popToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 显示或者隐藏HUD
// 只显示一个圈
- (MBProgressHUD *)showHUDLoading
{
    return [self showHUDLoadingWithString:@"" onView:self.view];
}
//在self.view上显示hud
- (MBProgressHUD *)showHUDLoadingWithString:(NSString *)hintString
{
    return [self showHUDLoadingWithString:hintString onView:self.view];
}
//显示hud的通用方法
- (MBProgressHUD *)showHUDLoadingWithString:(NSString *)hintString
                                     onView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud) {
        [hud showAnimated:YES];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.label.text = hintString;
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}
//隐藏self.view上的hud
- (void)hideHUDLoading
{
    [self hideHUDLoadingOnView:self.view];
}
//直接隐藏self.view上的hud
- (void)showResultThenHide:(NSString *)resultString {
    [self showResultThenHide:resultString
                  afterDelay:kHudIntervalNormal
                      onView:self.view];
}
//隐藏hud的通用方法
- (void)hideHUDLoadingOnView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    [hud hideAnimated:YES];
}
//延迟隐藏view上hud的通用方法
- (void)showResultThenHide:(NSString *)resultString
                afterDelay:(NSTimeInterval)delay
                    onView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.label.text = resultString;
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:delay];
}
@end
