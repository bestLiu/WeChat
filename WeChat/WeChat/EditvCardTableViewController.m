//
//  EditvCardTableViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "EditvCardTableViewController.h"
#import "XMPPvCardTemp.h"

@interface EditvCardTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFeild;

@end

@implementation EditvCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题和Textfield的默认值
    self.title = self.cell.textLabel.text;
    
    self.textFeild.text = self.cell.detailTextLabel.text;
    
    //右边添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClick)];
}


- (void)saveButtonClick
{
    // 1、更改cell的detailTextLabel的text
    self.cell.detailTextLabel.text = self.textFeild.text;
    [self.cell layoutSubviews];
    
    // 2、当天控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(EditPorfileDidSave)]) {
        [_delegate EditPorfileDidSave];//通知代理，点击保存按钮
    }

}

@end
