//
//  UserInfo.h
//  WeChat
//
//  Created by mac1 on 15/8/21.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserInfo : NSObject

singleton_interface(UserInfo);
@property (nonatomic, copy) NSString *user;//用户名
@property (nonatomic, copy) NSString *psw;//密码
/**
 *  登录状态，YES代表登录过 ， NO代表没有登录
 */
@property (nonatomic, assign) BOOL loginStatus;


@property (nonatomic, copy) NSString *registUser; //注册的用户名
@property (nonatomic, copy) NSString *registPwd; //注册的密码

- (void)loadUserInfoFromSandbox;

- (void)saveUserInfoToSandBox;
@end
