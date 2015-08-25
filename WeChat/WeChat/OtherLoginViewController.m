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
    
    //把用户名和密码放到userInfo单例类
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    userInfo.user = _userTf.text;
    userInfo.psw = _pswTf.text;
    
    
    [super login];
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
