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
    XMPPResultTypeNetError,     //网络不给力
    XMPPResultTypeRegisterSuccess, //注册成功
    XMPPResultTypeRegisterFailure  //注册失败
}XMPPResultType;



typedef void (^XMPPResultBock)(XMPPResultType type);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  YES代表注册 ，NO 代表登录
 */
@property (nonatomic, assign,getter=isRegiseterOperation) BOOL regiseterOperation;//是否是注册方法

//用户登录
- (void)xmppUserLogin:(XMPPResultBock)resultBlcok;

//用户注册
- (void)xmppUserRegist:(XMPPResultBock)resultBlcok;

//用户注销
-(void)logout;

@end

