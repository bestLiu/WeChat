//
//  PersonTableViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/21.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "PersonTableViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"

@interface PersonTableViewController ()
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
/**
 *  微信号
 */
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;

@end

@implementation PersonTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //显示当前用户个人信息
    
    //用coreData获取数据

    //1、上下文，关联到数据库
    
    //2、FetchRequest

    //3、设置过滤和排序
    
    //4、请求获取数据
    
    //XMPP提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    //设置头像
    if (myVCard.photo) {
        self.headImageView.image = [UIImage imageWithData:myVCard.photo];
    }
    //设置昵称
    self.nickNameLabel.text = myVCard.nickname;
    
    //设置微信号[用户名]
    
    NSString *user = [UserInfo sharedUserInfo].user;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号:%@",user];
    

}
- (IBAction)logoutBtnClick:(id)sender {
    [[XMPPTool sharedXMPPTool] logout];
}

   
@end
