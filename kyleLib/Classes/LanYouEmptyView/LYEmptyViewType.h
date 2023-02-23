//
//  LYEmptyViewType.h
//  背景空数据提示图
//
//  Created by 符传刚 on 2020/7/3.
//  Copyright © 2020 符传刚. All rights reserved.
//


// ****  创建的视图，都要必须遵守此协议并实现以下协议方法  ****

#import <Foundation/Foundation.h>

@class LYEmptyViewRequest;
@protocol LYEmptyViewType <NSObject>

/**
 *  初始化视图  因为frame在request中，所以初始化只传request
 *  @param request    视图参数
 */
- (id <LYEmptyViewType>)initWithRequest:(LYEmptyViewRequest *)request;

/**
 *  添加提示图
 *  @param view   背景图的父视图
 */
- (void)buildFromView:(UIView *)view;

/**
 *  移除
 */
- (void)removeFromView:(UIView *)fromView;

@end
