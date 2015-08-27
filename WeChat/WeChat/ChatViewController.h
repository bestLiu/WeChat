//
//  ChatViewController.h
//  WeChat
//
//  Created by liuchun on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"

@interface ChatViewController : UIViewController

@property (nonatomic, strong) XMPPJID *friendJid;

@end
