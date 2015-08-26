//
//  UserInfo.m
//  WeChat
//
//  Created by mac1 on 15/8/21.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "UserInfo.h"
#define kUserKey @"user"
#define kPswKey @"psw"
#define kLoginStatusKey @"loginStatus"



@implementation UserInfo



singleton_implementation(UserInfo);

- (void)loadUserInfoFromSandbox
{
    self.user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserKey];
    self.loginStatus = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatusKey];
    self.psw = [[NSUserDefaults standardUserDefaults] objectForKey:kPswKey];
}

- (void)saveUserInfoToSandBox
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.user forKey:kUserKey];
    [ud setObject:self.psw forKey:kPswKey];
    [ud setBool:self.loginStatus forKey:kLoginStatusKey];
    [ud synchronize];
}

- (NSString *)jid
{
    return [NSString stringWithFormat:@"%@@%@",self.user,domain];
}


@end
