//
//  AppDelegate.m
//  WeChat
//
//  Created by mac1 on 15/8/20.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPP/XMPPFramework.h"
/**
 *  1.初始化XMPPStream 
    2.连接服务器（传一个JID）
    3.链接服务器成功后，再发送密码授权
    4.授权成功后，再发送“在线消息”
 */

@interface AppDelegate ()<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;
}

- (void)setupXMPPStream;
- (void)connectToHost;
- (void)sendPswToHost;
- (void)sendOnlineToHost;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //程序以启动就链接到主机
    [self connectToHost];
    return YES;
}

- (void)setupXMPPStream
{
    _xmppStream = [[XMPPStream alloc] init];
   
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)connectToHost
{
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    // 设置JID resource标识用户登录的客户端，iPhone Android Windowsphone
    XMPPJID *myJID = [XMPPJID jidWithUser:@"zhangsan" domain:@"liuchun.local" resource:@"iPhone"];
    _xmppStream.myJID = myJID;
    
    //设置服务器的域名
    _xmppStream.hostName = @"liuchun.local";
    //设置端口,如果服务器的端口是5222 可以省略
    _xmppStream.hostPort = 5222;
    
    NSError *error = nil;
    //链接 1、超时用的
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"%@",error);
    }
}

- (void)sendPswToHost
{
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
    if (error) {
        
    }
}

- (void)sendOnlineToHost
{
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

#pragma mark - XMPPStreamDelegate
//连接主机成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功");
    
    //连接主机成功后发送密码进行授权
    [self sendPswToHost];
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    //如果有错误 就代表连接失败
    NSLog(@"与主机断开连接 error %@",error);
}

//授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    [self sendOnlineToHost];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"授权失败  error %@",error);
}


#pragma mark - 注销
- (void)logout
{
    //1.发送离线消息
    XMPPPresence *offLine = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offLine];
    
    //2.与服务器断开连接
    [_xmppStream disconnect];
}

@end
