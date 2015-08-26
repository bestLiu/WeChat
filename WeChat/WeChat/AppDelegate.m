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
        [[XMPPTool sharedXMPPTool] xmppUserLogin:nil];
    }
    return YES;
}




@end
