//
//  UIViewController+CMStateViewController.h
//

#import <UIKit/UIKit.h>
#import "CMStatableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CMStatableViewControllerDelegate <NSObject>
@optional
/// 点击刷新
- (void)tapRefresh;
@end

@interface UIViewController (CMStateViewController)<CMStatableViewControllerDelegate>
/// 状态试图
@property (nonatomic, strong) UIView<CMStatableView> * _Nullable stateView;

/// 设置状态
- (void)setState:(CMContentState)state;
@end

NS_ASSUME_NONNULL_END
