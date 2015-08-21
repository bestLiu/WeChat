//
//  AppDelegate.h
//  WeChat
//
//  Created by mac1 on 15/8/20.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetError     //网络不给力
}XMPPResultType;



typedef void (^XMPPResultBock)(XMPPResultType type);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)xmppUserLogin:(XMPPResultBock)resultBlcok;

-(void)logout;

@end

