//
//  XMPPTool.h
//  WeChat
//
//  Created by mac1 on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPP/XMPPFramework.h"

typedef enum{
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetError,     //网络不给力
    
    XMPPResultTypeRegisterSuccess, //注册成功
    XMPPResultTypeRegisterFailure  //注册失败
}XMPPResultType;

typedef void (^XMPPResultBock)(XMPPResultType type);

@interface XMPPTool : NSObject

singleton_interface(XMPPTool);

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPvCardTempModule *vCard;//电子名片
@property (nonatomic, strong) XMPPRoster *roster;//花名册模块
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储 

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
