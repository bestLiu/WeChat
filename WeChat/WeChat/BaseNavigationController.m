//
//  BaseNavigationController.m
//  WeChat
//
//  Created by mac1 on 15/8/21.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end



@implementation BaseNavigationController

+ (void)initialize
{
}
+ (void)setupNavTheme
{
    //设置导航样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //1、设置导航条背景
    [navBar setBackgroundImage:[UIImage stretchedImageWithName:@"topbarbg_ios7"]forBarMetrics:UIBarMetricsDefault];
    

    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:att];
    
    //设置状态栏的样式
    //默认，这个状态栏的样式由控制器决定的
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

// 结论，如果控制器由导航控制器管理，设置状态栏时，要在导航控制器里面设置
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
