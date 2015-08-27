//
//  ChatInputView.h
//  WeChat
//
//  Created by liuchun on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatInputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (instancetype)inputView;
@end
