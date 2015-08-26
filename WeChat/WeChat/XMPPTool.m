//
//  XMPPTool.m
//  WeChat
//
//  Created by mac1 on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "XMPPTool.h"

/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */
@interface XMPPTool ()<XMPPStreamDelegate>{

    XMPPResultBock _reslutBlock;
    
    XMPPReconnect *_reconnect;//自动连接模块
    
    XMPPvCardCoreDataStorage *_vCoreDataStorage; //电子名片数据存储
    
    XMPPvCardAvatarModule *_avatar;//头像
    

    
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

@implementation XMPPTool
singleton_implementation(XMPPTool);



#pragma mark  -私有方法
#pragma mark 初始化XMPPStream
-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
//    每一个模块添加后都要激活
    
    //添加电子名片模块
    _vCoreDataStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCoreDataStorage];
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    //激活
    [_avatar activate:_xmppStream];
    
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    //添加花名册模块【获取好友列表】
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}
#pragma mark 释放xmppStream相关资源
- (void)teardownXmpp
{
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCoreDataStorage = nil;
    _avatar = nil;
    _xmppStream = nil;
    _roster = nil;
    _rosterStorage = nil;
}

#pragma mark 连接到服务器
-(void)connectToHost{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    
    //从单例获取用户名
    NSString *user = nil;
    if (self.isRegiseterOperation) {
        user = [UserInfo sharedUserInfo].registUser;
    }else{
        user = [UserInfo sharedUserInfo].user;
    }
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
    
    if (self.isRegiseterOperation) {//注册操作，发送注册密码
        NSString *pwd = [UserInfo sharedUserInfo].registPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }
    else{//登录操作
        // 主机连接成功后，发送密码进行授权
        [self sendPwdToHost];
        
    }
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

// 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    LCLog(@"注册成功");
    if (_reslutBlock) {
        _reslutBlock(XMPPResultTypeRegisterSuccess);
    }
}

// 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    if (_reslutBlock) {
        _reslutBlock(XMPPResultTypeRegisterFailure);
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
    [UIStoryboard showInitialVCWithName:@"Login"];
    
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
    
    //链接到主机发送登录密码
    [self connectToHost];
}


- (void)xmppUserRegist:(XMPPResultBock)resultBlcok
{
    // 先把block存起来
    _reslutBlock = resultBlcok;
    
    //如果以前连接过服务器，要断开
    [_xmppStream disconnect];
    
    //连接到主机发送注册密码
    [self connectToHost];
}


- (void)dealloc
{
    [self teardownXmpp];
}


@end
