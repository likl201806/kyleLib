//
//  LYEmptyView.h
//  背景空数据提示图
//
//  Created by 符传刚 on 2020/7/3.
//  Copyright © 2020 符传刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYEmptyViewRequest.h"
#import "LYEmptyViewType.h"
#import "UIView+LYEmptyView.h"

@interface LYEmptyView : NSObject

/** 空视图 */
@property (nonatomic, strong) id <LYEmptyViewType> entityView;

/**
 *  初始化方法传入，不传request都将使用默认的request，不支持后面临时传入
 *  注意 ===>>> 这个不是单例，不是单例，所以要想要获取异常背景View的对象，记得自己开一个全局属性来保留一下
 */
+ (instancetype)shareView;

/**
 *  初始化方法传入，不传request都将使用默认的request，不支持后面临时传入
 *  @param request    空视图参数类
 *  注意 ===>>> 这个不是单例，不是单例，所以要想要获取异常背景View的对象，记得自己开一个全局属性来保留一下
 */
+ (instancetype)shareViewWithRequest:(LYEmptyViewRequest *)request;

/**
 *  初始化方法传入，不传request都将使用默认的request，不支持后面临时传入
 *  @param request    空视图参数类
 */
- (instancetype)initWithRequest:(LYEmptyViewRequest *)request;

/**
 *  添加提示图
 *  @param view   背景图的父视图
 */
- (instancetype)showFromView:(UIView *)view;

/**
 *  移除视图
 */
- (void)removeEmptyView;


@end
