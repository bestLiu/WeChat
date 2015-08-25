//
//  LoginViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/21.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "BaseNavigationController.h"

@interface LoginViewController ()<RegistViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
// 设置TextField和button 的样式
    self.pwdTf.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.pwdTf addLeftViewWithImage:@"Card_Lock"];
    [self.loginButton setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
    //设置用户名为上次登录的用户名;
    //从单例中获取用户名
    self.userLabel.text = [UserInfo sharedUserInfo].user;
}

- (IBAction)loginButtonClick:(id)sender
{
    //保存数据到单例
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.psw = self.pwdTf.text;
    
    //调用父类的方法
    [super login];
}

#pragma mark - RegistViewControllerDelegate
- (void)registViewControllerDidFinishRegist
{
    //完成注册了,userlabel显示注册的用户名
    self.userLabel.text = [UserInfo sharedUserInfo].registUser;
    
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //获取注册控制器
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[BaseNavigationController class]]) {
        BaseNavigationController *navVC = destVC;
        RegistViewController *registVC = navVC.viewControllers[0];
        //设置代理
        registVC.delegate = self;
    }
}


@end
