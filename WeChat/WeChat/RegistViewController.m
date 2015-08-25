//
//  RegistViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/25.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "RegistViewController.h"
#import "AppDelegate.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCos;
@property (weak, nonatomic) IBOutlet UITextField *userTf;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;

@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    //判断设备的类型 改变左右两边的约束距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftCos.constant = 10;
        self.rightCos.constant = 10;
    }
    
    
    //设置textfeild 的背景
    self.userTf.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdTf.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.registButton setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
   
}


- (IBAction)userTfChange:(id)sender
{
    BOOL enabled = self.userTf.text.length !=0 && self.pwdTf.text.length !=0 ? YES : NO;
    _registButton.enabled = enabled;
}
- (IBAction)pwdChange:(id)sender
{
    [self userTfChange:nil];
}
- (IBAction)registerButtonClick:(id)sender
{
    //判断用户输入的是否是手机号码
    if (![self.userTf isTelphoneNum]) {
     [MBProgressHUD showError:@"请输入正确地手机号码" toView:self.view];
        return;
    }
    [self.view endEditing:YES];
    
    //1.把用户注册的数据保存到单例
    UserInfo *info = [UserInfo sharedUserInfo];
    info.registUser = self.userTf.text;
    info.registPwd = self.pwdTf.text;
    
    //2.调用Appdelegate的注册方法
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.regiseterOperation = YES;
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在注册中..." toView:self.view];
    [app xmppUserRegist:^(XMPPResultType type) {
        [weakSelf handleResultType:type];
    }];
}

/**
 *  处理注册结果
 */
- (void)handleResultType:(XMPPResultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeNetError:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            case XMPPResultTypeRegisterFailure:
                [MBProgressHUD showError:@"用户名重复" toView:self.view];
                break;
            case XMPPResultTypeLoginSuccess:
            {
                [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
                if ([self.delegate respondsToSelector:@selector(registViewControllerDidFinishRegist)]) {
                    [_delegate registViewControllerDidFinishRegist];
                }
                //回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    });
}
- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
