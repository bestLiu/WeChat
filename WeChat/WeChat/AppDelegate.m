//
//  AppDelegate.m
//  WeChat
//
//  Created by mac1 on 15/8/20.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//


#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "BaseNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"//XMPP日志


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",path);
    
    [BaseNavigationController setupNavTheme];
    
    //从沙盒中加载用户的数据到单例
    [[UserInfo sharedUserInfo] loadUserInfoFromSandbox];
    
    //判断用户的登录状态 YES 直接来到主界面
    if ([UserInfo sharedUserInfo].loginStatus == YES) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.window setRootViewController:storyboard.instantiateInitialViewController];
        
        //自动登录服务器
        //1s后再自动登录,一般情况下都不会马上连接，会稍微等等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[XMPPTool sharedXMPPTool] xmppUserLogin:nil];
        });
    }
    return YES;
}




@end
