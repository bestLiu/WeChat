//
//  ChatInputView.m
//  WeChat
//
//  Created by liuchun on 15/8/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ChatInputView.h"

@implementation ChatInputView

+ (instancetype)inputView
{
    return [[NSBundle mainBundle] loadNibNamed:@"ChatInputView" owner:nil options:nil][0];
}

@end
