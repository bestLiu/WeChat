//
//  RegistViewController.h
//  WeChat
//
//  Created by mac1 on 15/8/25.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegistViewControllerDelegate <NSObject>

- (void)registViewControllerDidFinishRegist;

@end

@interface RegistViewController : UIViewController

@property (nonatomic, assign) id<RegistViewControllerDelegate> delegate;

@end
