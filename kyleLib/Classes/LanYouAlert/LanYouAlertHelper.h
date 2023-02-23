//
//  LanYouAlertHelper.m
//
#ifndef LanYouAlertHelper_h
#define LanYouAlertHelper_h


@class LanYouAlert , LanYouAlertConfig , LanYouAlertConfigModel , LanYouAlertWindow , CMAction , CMItem , CMCustomView;

typedef NS_ENUM(NSInteger, CMScreenOrientationType) {
   /// 屏幕方向类型 横屏
    CMScreenOrientationTypeHorizontal,
   /// 屏幕方向类型 竖屏
    CMScreenOrientationTypeVertical
};


typedef NS_ENUM(NSInteger, LanYouAlertType) {
    
    LanYouAlertTypeAlert,
    
    CMAlertTypeActionSheet
};


typedef NS_ENUM(NSInteger, CMActionType) {
   /// 默认
    CMActionTypeDefault,
   /// 取消
    CMActionTypeCancel,
   /// 销毁
    CMActionTypeDestructive
};


typedef NS_OPTIONS(NSInteger, CMActionBorderPosition) {
   /// Action边框位置 上
    CMActionBorderPositionTop      = 1 << 0,
   /// Action边框位置 下
    CMActionBorderPositionBottom   = 1 << 1,
   /// Action边框位置 左
    CMActionBorderPositionLeft     = 1 << 2,
   /// Action边框位置 右
    CMActionBorderPositionRight    = 1 << 3
};


typedef NS_ENUM(NSInteger, CMItemType) {
   /// 标题
    CMItemTypeTitle,
   /// 内容
    CMItemTypeContent,
   /// 输入框
    CMItemTypeTextField,
   /// 自定义视图
    CMItemTypeCustomView,
};


typedef NS_ENUM(NSInteger, CMCustomViewPositionType) {
   /// 居中
    CMCustomViewPositionTypeCenter,
   /// 靠左
    CMCustomViewPositionTypeLeft,
   /// 靠右
    CMCustomViewPositionTypeRight
};

typedef NS_OPTIONS(NSInteger, CMAnimationStyle) {
   /// 动画样式方向 默认
    CMAnimationStyleOrientationNone    = 1 << 0,
   /// 动画样式方向 上
    CMAnimationStyleOrientationTop     = 1 << 1,
   /// 动画样式方向 下
    CMAnimationStyleOrientationBottom  = 1 << 2,
   /// 动画样式方向 左
    CMAnimationStyleOrientationLeft    = 1 << 3,
   /// 动画样式方向 右
    CMAnimationStyleOrientationRight   = 1 << 4,
    
   /// 动画样式 淡入淡出
    CMAnimationStyleFade               = 1 << 12,
    
   /// 动画样式 缩放 放大
    CMAnimationStyleZoomEnlarge        = 1 << 24,
   /// 动画样式 缩放 缩小
    CMAnimationStyleZoomShrink         = 2 << 24,
};
typedef NS_OPTIONS(NSInteger, CMAlertActionBorderStyle) {
    /// 自由组合
    CMAlertActionBorderStyleAll,
    /// 上面边框和中部短线
    CMAlertActionBorderStyleTopMiddle,
    /// 只有中部短线
    CMAlertActionBorderStyleMiddle
};
NS_ASSUME_NONNULL_BEGIN
typedef LanYouAlertConfigModel * _Nonnull (^CMConfig)(void);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToBool)(BOOL is);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToInteger)(NSInteger number);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToFloat)(CGFloat number);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToString)(NSString *str);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToView)(UIView *view);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToImageView)(void(^)(UIImageView *imageView));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToColor)(UIColor *color);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToSize)(CGSize size);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToPoint)(CGPoint point);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToEdgeInsets)(UIEdgeInsets insets);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToAnimationStyle)(CMAnimationStyle style);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToBlurEffectStyle)(UIBlurEffectStyle style);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToInterfaceOrientationMask)(UIInterfaceOrientationMask);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToFloatBlock)(CGFloat(^)(CMScreenOrientationType type));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToAction)(void(^)(CMAction *action));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToActions)(NSArray <void(^)(CMAction *)>*actions);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToCustomView)(void(^)(CMCustomView *custom));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToStringAndBlock)(NSString *str, void (^ _Nullable)(void));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToConfigLabel)(void(^ _Nullable)(UILabel *label));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToConfigTextField)(void(^ _Nullable)(UITextField *textField));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToItem)(void(^)(CMItem *item));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToBlock)(void(^block)(void));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToBlockReturnBool)(BOOL(^block)(void));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToBlockIntegerReturnBool)(BOOL(^block)(NSInteger index));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToBlockAndBlock)(void(^)(void (^animatingBlock)(void) , void (^animatedBlock)(void)));

typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToAlertActionBorderStyle)(CMAlertActionBorderStyle style);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToBackClickBlock)(void(^block)(void));
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToStatusBarStyle)(UIStatusBarStyle style);
typedef LanYouAlertConfigModel * _Nonnull (^CMConfigToContainerRectCorner)(UIRectCorner corner,CGSize cornerRadii);

NS_ASSUME_NONNULL_END



#endif /* LanYouAlertHelper_h */
