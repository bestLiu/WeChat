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
/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */
@interface AppDelegate ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
    XMPPResultBock _reslutBlock;
}

// 1. 初始化XMPPStream
-(void)setupXMPPStream;


// 2.连接到服务器
-(void)connectToHost;

// 3.连接到服务成功后，再发送密码授权
-(void)sendPwdToHost;


// 4.授权成功后，发送"在线" 消息
-(void)sendOnlineToHost;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [BaseNavigationController setupNavTheme];
    
    //从沙盒中加载用户的数据到单例
    [[UserInfo sharedUserInfo] loadUserInfoFromSandbox];
    
    //判断用户的登录状态 YES 直接来到主界面
    if ([UserInfo sharedUserInfo].loginStatus == YES) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.window setRootViewController:storyboard.instantiateInitialViewController];
        
        //自动登录服务器
        [self xmppUserLogin:nil];
    }
    return YES;
}



#pragma mark  -私有方法
#pragma mark 初始化XMPPStream
-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 连接到服务器
-(void)connectToHost{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    
    //从沙盒获取用户名
    NSString *user = [UserInfo sharedUserInfo].user;
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"liuchun.local" resource:@"iphone" ];
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名
    _xmppStream.hostName = @"liuchun.local";//不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    // 连接
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        NSLog(@"%@",err);
    }
    
}


#pragma mark 连接到服务成功后，再发送密码授权
-(void)sendPwdToHost{
    NSLog(@"再发送密码授权");

    //从单例里获取密码
    NSString *psw = [UserInfo sharedUserInfo].psw;
    NSError *err = nil;
    [_xmppStream authenticateWithPassword:psw error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
}

#pragma mark  授权成功后，发送"在线" 消息
-(void)sendOnlineToHost{
    
    NSLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    
    
}
#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"与主机连接成功");
    
    // 主机连接成功后，发送密码进行授权
    [self sendPwdToHost];
}
#pragma mark  与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    NSLog(@"与主机断开连接 %@",error);
    
    if (error && _reslutBlock) {
        _reslutBlock(XMPPResultTypeNetError);
    }
    
    //如果没有错误，表示正常的断开连接（人为断开连接）;
    
    
}


#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"授权成功");
    
    [self sendOnlineToHost];
    
    //回调控制器登录成功
    if (_reslutBlock) {
        _reslutBlock(XMPPResultTypeLoginSuccess);
    }
    
}


#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 %@",error);
    if (_reslutBlock) {
        _reslutBlock(XMPPResultTypeLoginFailure);
    }
}


#pragma mark -公共方法
-(void)logout{
    // " 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //  与服务器断开连接
    [_xmppStream disconnect];
    
    //回到登录界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    [self.window setRootViewController:sb.instantiateInitialViewController];
    
    //更新用户的登录状态
    [UserInfo sharedUserInfo].loginStatus = NO;
    [[UserInfo sharedUserInfo] saveUserInfoToSandBox];
}

- (void)xmppUserLogin:(XMPPResultBock)resultBlcok
{
    // 先把block存起来
    _reslutBlock = resultBlcok;
    
    //如果以前连接过服务器，要断开
    [_xmppStream disconnect];
    [self connectToHost];
}

@end
