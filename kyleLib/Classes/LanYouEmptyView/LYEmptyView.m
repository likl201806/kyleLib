//
//  LYEmptyView.m
//  背景空数据提示图
//
//  Created by 符传刚 on 2020/7/3.
//  Copyright © 2020 符传刚. All rights reserved.
//

#import "LYEmptyView.h"
#import "LYEmptyDefaultView.h"

@interface LYEmptyView ()

/* 参数类 */
@property (nonatomic, strong) LYEmptyViewRequest *request;

/** 父视图 */
@property (nonatomic, assign) UIView *fromView;

@end

@implementation LYEmptyView

/**
 *  初始化方法传入，不传request都将使用默认的request，不支持后面临时传入
 */
+ (id)shareView {
    LYEmptyView *emptyView = [LYEmptyView shareViewWithRequest:[LYEmptyViewRequest shareRequest:nil]];
    return emptyView;
}

/**
 *  初始化方法传入，不传request都将使用默认的request，不支持后面临时传入
 *  @param request    空视图参数类
 */
+ (id)shareViewWithRequest:(LYEmptyViewRequest *)request {
    LYEmptyView *emptyView = [[LYEmptyView alloc] initWithRequest:request];
    return emptyView;
}

/**
 *  初始化方法传入，不传request都将使用默认的request，不支持后面临时传入
 *  @param request    空视图参数类
 */
- (id)initWithRequest:(LYEmptyViewRequest *)request {
    self = [super init];
    if (self) {
        
        self.request = request;
        
        // 初始化本类所需配置
        [self onInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // 避免每次都直接调用 alloc init 方法创建，使得在使用的时候都要做request是nil的判断，干脆直接在这边附上初始值，后面有新值再替换
        self.request = [LYEmptyViewRequest shareRequest:nil];
        
        // 初始化本类所需配置
        [self onInit];
    }
    return self;
}

/// 初始化本类所需配置
- (void)onInit {
    
    self.entityView = nil;
    
    switch (self.request.type) {
        case LYEmptyViewCreateTypeDefault:
            self.entityView = [[LYEmptyDefaultView alloc] initWithRequest:self.request];
            break;
            
        default:
            self.entityView = [[LYEmptyDefaultView alloc] initWithRequest:self.request];
            break;
    }
}

/**
 *  添加提示图
 *  @param view   背景图的父视图
 */
- (instancetype)showFromView:(UIView *)view {
    self.fromView = view;
    [self.entityView buildFromView:view];
    return self;
}

/**
 *  移除视图
 */
- (void)removeEmptyView {
    if (self.entityView && self.fromView) {
        [self.entityView removeFromView:self.fromView];
    }
}

@end
