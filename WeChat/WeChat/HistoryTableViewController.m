//
//  HistoryTableViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "HistoryTableViewController.h"

@interface HistoryTableViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听一个登录状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanges:) name:LCLoginStatusChangeNotification object:nil];
}

- (void)loginStatusChanges:(NSNotification *)noti
{
#warning 通知是在子线程被调用的，所以在主线程刷新UI
    
     NSLog(@"noti ___ %@",noti.userInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        int status = [noti.userInfo[@"loginStatus"] integerValue];
        switch (status) {
            case XMPPResultTypeConnecting://正在连接
                [self.indicator startAnimating];
                break;
            case XMPPResultTypeNetError://连接失败
                [self.indicator stopAnimating];
                break;
            case XMPPResultTypeLoginSuccess://登录成功
                [self.indicator stopAnimating];
                break;
            case XMPPResultTypeLoginFailure:
                [self.indicator stopAnimating];
                break;
                
            default:
                break;
        }
    });
   

}

@end
