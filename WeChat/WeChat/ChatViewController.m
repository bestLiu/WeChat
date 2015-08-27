//
//  ChatViewController.m
//  WeChat
//
//  Created by liuchun on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInputView.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate>
{
    NSFetchedResultsController *_resultControl;
}

@property (strong, nonatomic) NSLayoutConstraint *inputViewConstraint;//inputView底部的约束
@property (strong, nonatomic) NSLayoutConstraint *inputViewHegihtCos;//inputView高度的约束
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    

    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadMsg];
}

- (void)setupView
{
    // 代码方式实现自动布局 VFL
    
    //创建一个tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;//autoresizing关掉
    self.tableView = tableView;
    
    
    //创建输入框view
    ChatInputView *inputView = [ChatInputView inputView];
    inputView.textView.delegate = self;
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
    self.inputViewHegihtCos = VCons[2];
}

#pragma mark 加载XMPPMessageArchiving数据库的数据，显示到表上
- (void)loadMsg
{
    //上下文
    NSManagedObjectContext *context = [XMPPTool sharedXMPPTool].msgSorage.mainThreadManagedObjectContext;
    
    //请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //设置过滤,当前登录用户JID的消息 好友jid的消息
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[UserInfo sharedUserInfo].jid,self.friendJid.bare];
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    request.predicate = predicate;
    
    //查询
    _resultControl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    [_resultControl performFetch:&error];
    if (error) {
        NSLog(@"error __%@",error);
    }
}

#pragma mark -UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _resultControl.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    //获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultControl.fetchedObjects[indexPath.row];
    
    if([msg.outgoing boolValue])//自己发的消息
    {
        cell.textLabel.text = [NSString stringWithFormat:@"I Say:%@",msg.body];
    }else//别人发送的消息
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Other Say:%@",msg.body];
    }
    
    return cell;
}

#pragma mark Resultcontroller代理 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //刷新数据
    [self.tableView reloadData];
    
    //滚动到最后一条消息
    [self scrollToButtom];
}

#pragma mark -UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat contentH = textView.contentSize.height;
    if (contentH > 33 && contentH <= 68) {//大于33，超过一行的高度，小于68高度是在3行内
        self.inputViewHegihtCos.constant = contentH + 18;
    }
    
    NSString *text = textView.text;
    //换行就等于点击了send
    if ([text rangeOfString:@"\n"].length != 0) {
        
        //去掉换行符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //发送数据
        [self sendMsgWithText:text];
        textView.text = @"";
        //发送完消息把高度改过来
        self.inputViewHegihtCos.constant = 50;
    }else
    {
        
    }
}

//发送聊天消息
- (void)sendMsgWithText:(NSString *)text
{
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    //设置内容
    [msg addBody:text];
    [[XMPPTool sharedXMPPTool].xmppStream sendElement:msg];
    
}

//表格滚动到底部
- (void)scrollToButtom
{
    NSInteger lastRow = _resultControl.fetchedObjects.count - 1;
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/*---------------------------------------------------分割线--------------------------------------------------------------*/
- (void)keyboardWillShow:(NSNotification *)noti
{
    //隐藏键盘的方法，距离底部永远为0
    
    self.inputViewConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    CGRect kbEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight = kbEndFrame.size.height;
    
    //横屏{0，0，352，1024} 很明显宽度和高度搞反了
    // 竖 {0，0，768，264}
    //如果是iOS7 以下的，当屏幕是横着的，键盘的高度是size.with
    self.inputViewConstraint.constant = kbHeight;
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        kbHeight = kbEndFrame.size.width;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self scrollToButtom];
}

//- (void)keyboardWillChange:(NSNotification *)noti
//{
//    NSDictionary *userInfo = [noti userInfo];
//    //获取窗口高度
//    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
//    
//    //键盘结束的frame
//    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    CGFloat keyboardEndY = keyboardEndFrame.origin.y;
//    
//   [UIView animateWithDuration:2 animations:^{
//       self.inputViewConstraint.constant = windowH - keyboardEndY;
//   } completion:nil];
//    
//    
//    
//}

@end
