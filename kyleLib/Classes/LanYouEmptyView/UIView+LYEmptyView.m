//
//  UIView+LYEmptyView.m
//  LanYouEmptyView_Example
//
//  Created by 符传刚 on 2020/10/30.
//  Copyright © 2020 2044471447@qq.com. All rights reserved.
//

#import "UIView+LYEmptyView.h"
#import "LYEmptyView.h"
#import <objc/runtime.h>

static NSString *kLYEMPTYVIEW_KEY = @"LYEmptyView";

@implementation UIView (LYEmptyView)

@dynamic ly_emptyView;

+ (LYEmptyView *)createEmptyView:(LYEmptyViewRequest *)request {
    if (!request) {
        request = [LYEmptyViewRequest shareRequest:nil];
    }
    return [LYEmptyView shareViewWithRequest:request];
}

- (void)removeEmptyView {
    LYEmptyView *emptyView = objc_getAssociatedObject(self, &kLYEMPTYVIEW_KEY);
    if (emptyView) {
        [emptyView removeEmptyView];
        objc_setAssociatedObject(self, &kLYEMPTYVIEW_KEY, nil, OBJC_ASSOCIATION_RETAIN);
        self.ly_emptyView = nil;
    }
}

- (void)setLy_emptyView:(LYEmptyView *)ly_emptyView {
    objc_setAssociatedObject(self, &kLYEMPTYVIEW_KEY, ly_emptyView, OBJC_ASSOCIATION_RETAIN);
    [ly_emptyView showFromView:self];
}

- (LYEmptyView *)ly_emptyView {
    LYEmptyView *emptyView = objc_getAssociatedObject(self, &kLYEMPTYVIEW_KEY);
    return emptyView;
}

@end
