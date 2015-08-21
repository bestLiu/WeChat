//
//  OtherLoginViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/21.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "OtherLoginViewController.h"
#import "AppDelegate.h"


@interface OtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCos;
@property (weak, nonatomic) IBOutlet UITextField *userTf;
@property (weak, nonatomic) IBOutlet UITextField *pswTf;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation OtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其他方式登录";
    //判断设备的类型 改变左右两边的约束距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftCos.constant = 10;
        self.rightCos.constant = 10;
    }
    
    
    //设置textfeild 的背景
    self.userTf.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pswTf.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginButton setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
}
- (IBAction)loginButtonClick:(id)sender {
    
    //登录
    /**
     *  官方的登录实现
     1、把用户名和密码放到userInfo单例类
     2、调用 AppDelegate的一个connect 连接到服务器
     */

    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.user = _userTf.text;
    userInfo.psw = _pswTf.text;

    [self.view endEditing:YES];
    //登录之前提示
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app xmppUserLogin:^(XMPPResultType type) {
        [weakSelf handleResultType:type];
        
    }];
    
}

- (void)handleResultType:(XMPPResultType)type
{
    //主线程刷新UI
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                [weakSelf enterMainPage];
                break;
            case XMPPResultTypeLoginFailure:
                [MBProgressHUD showError:@"用户名或者密码不正确" toView:self.view];
                
                break;
            case XMPPResultTypeNetError:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            default:
                break;
        }

    });
}


- (void)enterMainPage
{
    //更改用户登录状态
    [UserInfo sharedUserInfo].loginStatus = YES;
    
    //把用户数据，保存到沙盒
    [[UserInfo sharedUserInfo] saveUserInfoToSandBox];
    
    //隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    //登录成功去主界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
