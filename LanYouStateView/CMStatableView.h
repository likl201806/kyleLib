//
//  CMStatableView.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数据状态
typedef NS_ENUM(NSUInteger, CMContentState) {
    /// 默认状态 隐藏
    CMContentStateHide,
    /// 加载中
    CMContentStateLoading,
    /// 提示状态，空或者其他提示
    CMContentStateTip,
    /// 加载失败，回调数据 result != 1
    CMContentStateLoadFail,
    /// 错误
    CMContentStateError,
    /// 拓展状态1
    CMContentStateExt1,
    /// 拓展状态2
    CMContentStateExt2,
    /// 拓展状态3
    CMContentStateExt3,
};

/// 事件回调
typedef void (^CMStateActionBlock)(id sender);

/// 有状态View
@protocol CMStatableView <NSObject>
/// 状态
@property (nonatomic, assign) CMContentState state;
/// 回调
@property (nonatomic, copy) CMStateActionBlock actionCallback;

/// 设置图标
/// @param icon 图标
/// @param state 状态
- (void)setIcon:(nullable UIImage *)icon forState:(CMContentState)state;

/// 设置标题
/// @param title 标题
/// @param state 状态
- (void)setTitle:(nullable NSString *)title forState:(CMContentState)state;

/// 设置详情
/// @param detail 详情
/// @param state 状态
- (void)setDetail:(nullable NSString *)detail forState:(CMContentState)state;

/// 设置按钮标题
/// @param action 按钮
/// @param state 状态
- (void)setAction:(nullable NSString *)action forState:(CMContentState)state;

/// 设置富文本标题
- (void)setAttributedTitle:(nullable NSAttributedString *)attributedTitle forState:(UIControlState)state;

/// 设置富文本详情
- (void)setAttributedDetail:(nullable NSAttributedString *)attributedDetail forState:(UIControlState)state;

/// 设置富文本按钮标题
- (void)setAttributedAction:(nullable NSAttributedString *)attributedAction forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
