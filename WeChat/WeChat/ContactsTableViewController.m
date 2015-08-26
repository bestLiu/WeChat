//
//  ContactsTableViewController.m
//  WeChat
//
//  Created by mac1 on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultControl;
}

@property (strong, nonatomic) NSArray *friends;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从数据库里加载好友列表显示
    [self loadFriends];
}

- (void)loadFriends
{
    //用coreData获取数据
    
    //1、上下文，[关联到数据库XMPPRoster.sqlite]
    NSManagedObjectContext *context = [XMPPTool sharedXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2、FetchRequest[查那张表]
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStroageObject"];
    
    //3、设置过滤和排序
    //过滤当前登录用户的好友
    NSString *jid = [UserInfo sharedUserInfo].jid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = predicate;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    //4、请求获取数据
    _resultControl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultControl.delegate = self;
    NSError *error = nil;
    [_resultControl performFetch:&error];
    
    if (error) {
        NSLog(@"error  %@",error);
    }
    
}


- (void)loadFriends2
{
    //用coreData获取数据
    
    //1、上下文，[关联到数据库XMPPRoster.sqlite]
  NSManagedObjectContext *context = [XMPPTool sharedXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2、FetchRequest[查那张表]
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStroageObject"];
    
    //3、设置过滤和排序
    //过滤当前登录用户的好友
    NSString *jid = [UserInfo sharedUserInfo].jid;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = predicate;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    //4、请求获取数据
    self.friends =  [context executeFetchRequest:request error:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate当数据库的内容发生改变后 会调用这个方法
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    LCLog(@"数据发生改变");
    
    //刷新表格
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _resultControl.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    //获取对应的好友
//    XMPPUserCoreDataStorageObject *friend = self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend = _resultControl.fetchedObjects[indexPath.row];

    NSInteger status = [friend.sectionNum integerValue];
    switch (status) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
            
        default:
            break;
    }
    cell.textLabel.text = friend.jidStr;
    
    return cell;
}

//实现这个方法，cell向左滑就可以删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)//删除好友
    {
        XMPPUserCoreDataStorageObject *friend = _resultControl.fetchedObjects[indexPath.row];
        XMPPJID *friendJid = friend.jid;
        [[XMPPTool sharedXMPPTool].roster removeUser:friendJid];
    }
}

@end
