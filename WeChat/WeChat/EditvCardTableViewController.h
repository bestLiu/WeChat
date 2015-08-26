//
//  EditvCardTableViewController.h
//  WeChat
//
//  Created by mac1 on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditTableViewControllerDelegate <NSObject>

- (void)EditPorfileDidSave;

@end

@interface EditvCardTableViewController : UITableViewController

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, assign) id<EditTableViewControllerDelegate> delegate;

@end
