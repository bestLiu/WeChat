//
//  AddContactTableViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "AddContactTableViewController.h"

@interface AddContactTableViewController ()<UITextFieldDelegate>

@end

@implementation AddContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //1 获取好友账号
    NSString *user = textField.text;
    
    //判断这个账号是不是手机号码
    if (![textField isTelphoneNum]) {
        
        [self showAlert:@"请输入正确地手机号码"];
        return YES;
    }
    
    //判断是否添加自己
    if ([user isEqualToString:[UserInfo sharedUserInfo].user]) {
        [self showAlert:@"不能添加自己为好友"];
    }
    
    //判断好友是否已经存在
     XMPPJID *friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",user,domain]];
   if( [[XMPPTool sharedXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[XMPPTool sharedXMPPTool].xmppStream])
   {
       [self showAlert:@"当前好友已经存在"];
   }
    
    //2 发送好友添加请求
    //添加好友，xmpp订阅
   
   [[XMPPTool sharedXMPPTool].roster subscribePresenceToUser:friendJid];
    return YES;
}


- (void)showAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}
@end
