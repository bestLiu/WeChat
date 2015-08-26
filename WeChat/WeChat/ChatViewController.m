//
//  ChatViewController.m
//  WeChat
//
//  Created by liuchun on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInputView.h"

@interface ChatViewController ()

@property (strong, nonatomic) NSLayoutConstraint *inputViewConstraint;//inputView底部的约束

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    

    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupView
{
    // 代码方式实现自动布局 VFL
    
    //创建一个tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;//autoresizing关掉
    //创建输入框view
    ChatInputView *inputView = [ChatInputView inputView];
    [self.view addSubview:inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;//autoresizing关掉
    
    //自动布局
    
    //水平方向的约束
    //1.tableView
    NSDictionary *views = @{@"tableView":tableView,
                            @"inputView":inputView};
   NSArray *tableViewHCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHCons];
    //2.inputView
    NSArray *inputViewHCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHCons];
    
    //垂直方向的约束
    NSArray *VCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:VCons];
    self.inputViewConstraint = [VCons lastObject];
}

- (void)keyboardWillChange:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    //获取窗口高度
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    
    //键盘结束的frame
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardEndY = keyboardEndFrame.origin.y;
    
   [UIView animateWithDuration:2 animations:^{
       self.inputViewConstraint.constant = windowH - keyboardEndY;
   } completion:nil];
    
    
    
}

@end
