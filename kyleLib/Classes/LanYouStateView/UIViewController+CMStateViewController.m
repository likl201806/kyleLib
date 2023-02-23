//
//  UIViewController+CMStateViewController.m
//

#import "UIViewController+CMStateViewController.h"
#import "CMStateView.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

@implementation UIViewController (CMStateViewController)
static char * const kStateViewKey = "stateView";
- (UIView<CMStatableView> *)stateView {
    UIView<CMStatableView> *stateView = objc_getAssociatedObject(self, kStateViewKey);
    if (stateView == nil) {
        stateView = [CMStateView stateView];
        stateView.hidden = YES;
        [self setStateView:stateView];
        
        [self.view addSubview:stateView];
         __weak typeof(self) weakSelf = self;
        [stateView setActionCallback:^(id  _Nonnull sender) {
            /// 重刷
            if ([weakSelf respondsToSelector:@selector(tapRefresh)]) {
                [weakSelf tapRefresh];
            }
        }];

        [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return stateView;
}

- (void)setStateView:(UIView<CMStatableView> *)aStateView {
    UIView<CMStatableView> *stateView = objc_getAssociatedObject(self, kStateViewKey);
    if (stateView != aStateView) {
        // 删除旧的，添加新的
        [stateView removeFromSuperview];
        // 存储新的
        objc_setAssociatedObject(self, kStateViewKey,
                                 aStateView, OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)setState:(CMContentState)state {
    [self.stateView setState:state];
    // 将stateView 放到最上层，防止被其他View 覆盖
    [self.view bringSubviewToFront:self.stateView];
}
@end
