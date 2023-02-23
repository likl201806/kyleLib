//
//  UIView+LYEmptyView.h
//  LanYouEmptyView_Example
//
//  Created by 符传刚 on 2020/10/30.
//  Copyright © 2020 2044471447@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LYEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@class LYEmptyView, LYEmptyViewRequest;
@interface UIView (LYEmptyView)

@property (nonatomic, strong) LYEmptyView * _Nullable ly_emptyView;

+ (LYEmptyView *)createEmptyView:(LYEmptyViewRequest *)request;

- (void)removeEmptyView;

@end

NS_ASSUME_NONNULL_END
