//
//  PersonNextTableViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "PersonNextTableViewController.h"
#import "XMPPvCardTemp.h"
#import "EditvCardTableViewController.h"

@interface PersonNextTableViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,EditTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView; //头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgnameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件

@end

@implementation PersonNextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self loadvCard];
    
   
}


/**
 *  加载电子名片信息
 */
- (void)loadvCard
{
    //显示个人信息
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
    
    
    //公司
    self.orgnameLabel.text = myVCard.orgName;
    
    //部门
    if (myVCard.orgUnits.count > 0) {
        self.orgunitLabel.text = myVCard.orgUnits[0];
    }
    
    //职位
    self.titleLabel.text = myVCard.title;
    
    //电话,myVCard.telecomsAddresses这个get方法，没有对电子名片的xml数据进行解析。使用note字段充当电话
    self.phoneNumLabel.text = myVCard.note;
    
    //邮件 , 用meiler充当邮件
    self.emailLabel.text = myVCard.mailer;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取cell的tag
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    if (tag == 2) {
        return;
    }
    else if(tag == 0)//选着照片
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        [self performSegueWithIdentifier:@"EditvCardSegue" sender:cell];
    }
}



#pragma mark UIAcitonSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 2) {
        return;
    }
    else if (buttonIndex == 0)
    {
        //照相
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        //相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //显示图片选择器
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    //获取图片设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //更新到服务器
    [self EditPorfileDidSave];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -Edit完成代理,数据更新到服务器
- (void)EditPorfileDidSave
{
    //保存数据到服务器
    //获取当前电子名片信息
    XMPPvCardTemp *myVCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    //头像
    myVCard.photo = UIImagePNGRepresentation(self.headImageView.image);
    //昵称
    myVCard.nickname = self.nickNameLabel.text;
    
    //公司
    myVCard.orgName = self.orgnameLabel.text;
    
    //部门
    if (self.orgunitLabel.text.length > 0) {
        myVCard.orgUnits = @[self.orgunitLabel.text];
    }
    
    //职位
    myVCard.title = self.titleLabel.text;
    
    // 电话
    myVCard.note = self.phoneNumLabel.text;
    
    //邮件
    myVCard.mailer = self.emailLabel.text;
    
    //更新 这个方法内部会实现数据上传到服务器，程序自己操作
    [[XMPPTool sharedXMPPTool].vCard updateMyvCardTemp:myVCard];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人信息的控制
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[EditvCardTableViewController class]]) {
        EditvCardTableViewController *editVc = destVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
}


@end
