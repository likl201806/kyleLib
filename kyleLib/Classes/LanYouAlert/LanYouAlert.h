//
//  LanYouAlert.h
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "LanYouAlertHelper.h"

#import "IGAlertProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface LanYouAlert : NSObject

/// 初始化

+ (nonnull LanYouAlertConfig *)alert;

+ (nonnull LanYouAlertConfig *)actionsheet;

/// 获取Alert窗口
+ (nonnull LanYouAlertWindow *)getAlertWindow;

/// 设置主窗口
+ (void)configMainWindow:(UIWindow *)window;

/// 继续队列显示
+ (void)continueQueueDisplay;

/// 清空队列
+ (void)clearQueue;

/**
 关闭指定标识 

 @param identifier 标识
 @param completionBlock 关闭完成回调
  */
+ (void)closeWithIdentifier:(NSString *)identifier completionBlock:(void (^ _Nullable)(void))completionBlock;

/**
 关闭指定标识

 @param identifier 标识
 @param force 是否强制关闭
 @param completionBlock 关闭完成回调
  */
+ (void)closeWithIdentifier:(NSString *)identifier force:(BOOL)force completionBlock:(void (^ _Nullable)(void))completionBlock;

/**
 关闭当前

 @param completionBlock 关闭完成回调
  */
+ (void)closeWithCompletionBlock:(void (^ _Nullable)(void))completionBlock;

@end

@interface LanYouAlertConfigModel : NSObject

/// ✨通用设置

/// 设置 标题 -> 格式: .CMTitle(@@"")
@property (nonatomic , copy , readonly ) CMConfigToString CMTitle;

/// 设置 内容 -> 格式: .CMContent(@@"")
@property (nonatomic , copy , readonly ) CMConfigToString CMContent;

/// 设置 自定义视图 -> 格式: .CMCustomView(UIView)
@property (nonatomic , copy , readonly ) CMConfigToView CMCustomView;

/// 设置 动作 -> 格式: .IGYRAction(@"name" , ^{ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToStringAndBlock IGYRAction;

/// 设置 取消动作 -> 格式: .CMCancelAction(@"name" , ^{ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToStringAndBlock CMCancelAction;

/// 设置 取消动作 -> 格式: .CMDestructiveAction(@"name" , ^{ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToStringAndBlock CMDestructiveAction;

/// 设置 添加标题 -> 格式: .CMConfigTitle(^(UILabel *label){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToConfigLabel CMAddTitle;

/// 设置 添加内容 -> 格式: .CMConfigContent(^(UILabel *label){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToConfigLabel CMAddContent;

/// 设置 添加自定义视图 -> 格式: .CMAddCustomView(^(CMCustomView *){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToCustomView CMAddCustomView;

/// 设置 添加一项 -> 格式: .CMAddItem(^(CMItem *){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToItem CMAddItem;

/// 设置 添加动作 -> 格式: .CMAddAction(^(IGYRAction *){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToAction CMAddAction;

/// 设置 添加动作 -> 格式: .CMConfigToActions(^(NSArray <IGYRAction *> *actions){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToActions CMAddActions;

/// 设置 头部内的间距 -> 格式: .CMHeaderInsets(UIEdgeInsetsMake(20, 20, 20, 20))
@property (nonatomic , copy , readonly ) CMConfigToEdgeInsets CMHeaderInsets;

/// 设置 上一项的间距 (在它之前添加的项的间距) -> 格式: .CMItemInsets(UIEdgeInsetsMake(5, 0, 5, 0))
@property (nonatomic , copy , readonly ) CMConfigToEdgeInsets CMItemInsets;

/// 设置 最大宽度 -> 格式: .CMMaxWidth(280.0f)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMMaxWidth;

/// 设置 最大高度 -> 格式: .CMMaxHeight(400.0f)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMMaxHeight;

/// 设置 设置最大宽度 -> 格式: .CMConfigMaxWidth(CGFloat(^)(^CGFloat(CMScreenOrientationType type) { return 280.0f; })
@property (nonatomic , copy , readonly ) CMConfigToFloatBlock CMConfigMaxWidth;

/// 设置 设置最大高度 -> 格式: .CMConfigMaxHeight(CGFloat(^)(^CGFloat(CMScreenOrientationType type) { return 600.0f; })
@property (nonatomic , copy , readonly ) CMConfigToFloatBlock CMConfigMaxHeight;

/// 设置 圆角半径 -> 格式: .CMCornerRadius(13.0f)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMCornerRadius;

/// 设置 开启动画时长 -> 格式: .CMOpenAnimationDuration(0.3f)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMOpenAnimationDuration;

/// 设置 关闭动画时长 -> 格式: .CMCloseAnimationDuration(0.2f)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMCloseAnimationDuration;

/// 设置 颜色 -> 格式: .CMHeaderColor(UIColor)
@property (nonatomic , copy , readonly ) CMConfigToColor CMHeaderColor;

/// 设置 背景颜色 -> 格式: .CMBackGroundColor(UIColor)
@property (nonatomic , copy , readonly ) CMConfigToColor CMBackGroundColor;

/// 设置 半透明背景样式及透明度 [默认] -> 格式: .CMBackgroundStyleTranslucent(0.0)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMBackgroundStyleTranslucent;

/// 设置 模糊背景样式及类型 -> 格式: .CMBackgroundStyleBlur(UIBlurEffectStyleDark)
@property (nonatomic , copy , readonly ) CMConfigToBlurEffectStyle CMBackgroundStyleBlur;

/// 设置 点击头部关闭 -> 格式: .CMClickHeaderClose(YES)
@property (nonatomic , copy , readonly ) CMConfigToBool CMClickHeaderClose;

/// 设置 点击背景关闭 -> 格式: .CMClickBackgroundClose(YES)
@property (nonatomic , copy , readonly ) CMConfigToBool CMClickBackgroundClose;

/// 设置 弹窗是否可以滚动 -> 格式: .CMScrollEnabled(YES)
@property (nonatomic , copy , readonly ) CMConfigToBool CMScrollEnabled;

/// 设置 阴影偏移 -> 格式: .CMShadowOffset(CGSizeMake(0.0f, 0.0f))
@property (nonatomic , copy , readonly ) CMConfigToSize CMShadowOffset;

/// 设置 阴影不透明度 -> 格式: .CMShadowOpacity(0.3f)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMShadowOpacity;

/// 设置 阴影半径 -> 格式: .CMShadowRadius(0.0f)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMShadowRadius;

/// 设置 阴影颜色 -> 格式: .CMShadowOpacity(UIColor)
@property (nonatomic , copy , readonly ) CMConfigToColor CMShadowColor;

/// 设置 标识 -> 格式: .CMIdentifier(@@"ident")
@property (nonatomic , copy , readonly ) CMConfigToString CMIdentifier;

/// 设置 是否加入到队列 -> 格式: .CMQueue(YES)
@property (nonatomic , copy , readonly ) CMConfigToBool CMQueue;

/// 设置 优先级 -> 格式: .CMPriority(1000)
@property (nonatomic , copy , readonly ) CMConfigToInteger CMPriority;

/// 设置 是否继续队列显示 -> 格式: .CMContinueQueue(YES)
@property (nonatomic , copy , readonly ) CMConfigToBool CMContinueQueueDisplay;

/// 设置 window等级 -> 格式: .CMWindowLevel(UIWindowLevel)
@property (nonatomic , copy , readonly ) CMConfigToFloat CMWindowLevel;

/// 设置 是否支持自动旋转 -> 格式: .CMShouldAutorotate(YES)
@property (nonatomic , copy , readonly ) CMConfigToBool CMShouldAutorotate;

/// 设置 是否支持显示方向 -> 格式: .CMShouldAutorotate(UIInterfaceOrientationMaskAll)
@property (nonatomic , copy , readonly ) CMConfigToInterfaceOrientationMask CMSupportedInterfaceOrientations;

/// 设置 打开动画配置 -> 格式: .CMOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. })
@property (nonatomic , copy , readonly ) CMConfigToBlockAndBlock CMOpenAnimationConfig;

/// 设置 关闭动画配置 -> 格式: .CMCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. })
@property (nonatomic , copy , readonly ) CMConfigToBlockAndBlock CMCloseAnimationConfig;

/// 设置 打开动画样式 -> 格式: .CMOpenAnimationStyle()
@property (nonatomic , copy , readonly ) CMConfigToAnimationStyle CMOpenAnimationStyle;

/// 设置 关闭动画样式 -> 格式: .CMCloseAnimationStyle()
@property (nonatomic , copy , readonly ) CMConfigToAnimationStyle CMCloseAnimationStyle;

/// 设置 状态栏样式 -> 格式: .CMStatusBarStyle(UIStatusBarStyleDefault)
@property (nonatomic , copy , readonly ) CMConfigToStatusBarStyle CMStatusBarStyle;

/// 设置 Container的圆角 -> 格式: .CMContainerCorner(UIRectCornerTopLeft | UIRectCornerTopRight, CGSizeMake(8, 8))
@property (nonatomic , copy , readonly ) CMConfigToContainerRectCorner CMContainerCorner;

/// 显示  -> 格式: .CMShow()
@property (nonatomic , copy , readonly ) CMConfig CMShow;



/// ✨alert 专用设置

/// 设置 Action边框样式 -> 格式: .IGYRActionBorderStyle(IGYRActionBorderTypeAll)
@property (nonatomic , copy , readonly ) CMConfigToAlertActionBorderStyle CMAlertActionBorderStyle;

/// 设置 按钮中部分割线大小 CMAlertActionBorderStyleAll下设置无效  -> 格式: .CMAlertActionBorderSize(CGSizeMake(0.5f, 18f)) 
@property (nonatomic , copy , readonly ) CMConfigToSize CMAlertActionBorderSize;

/// 设置 添加输入框 -> 格式: .CMAddTextField(^(UITextField *){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToConfigTextField CMAddTextField;

/// 设置 中心点偏移 -> 格式: .CMCenterOffset(CGPointMake(0, 0))
@property (nonatomic , copy , readonly ) CMConfigToPoint CMAlertCenterOffset;
    
/// 设置 是否闪避键盘 -> 格式: .CMAvoidKeyboard(YES)
@property (nonatomic , copy , readonly ) CMConfigToBool CMAvoidKeyboard;

/// 设置 添加弹窗背景图片 -> 格式: .CMAddAlertBGImageView(^(UIImageView * _Nonnull imageView){ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToImageView CMAddAlertBGImageView;

/// ✨actionSheet 专用设置

/// 设置 ActionSheet的背景视图颜色 -> 格式: .IGYRActionSheetBackgroundColor(UIColor)
@property (nonatomic , copy , readonly ) CMConfigToColor IGYRActionSheetBackgroundColor;

/// 设置 取消动作的间隔宽度 -> 格式: .IGYRActionSheetCancelActionSpaceWidth(10.0f)
@property (nonatomic , copy , readonly ) CMConfigToFloat IGYRActionSheetCancelActionSpaceWidth;

/// 设置 取消动作的间隔颜色 -> 格式: .IGYRActionSheetCancelActionSpaceColor(UIColor)
@property (nonatomic , copy , readonly ) CMConfigToColor IGYRActionSheetCancelActionSpaceColor;

/// 设置 ActionSheet距离屏幕底部的间距 -> 格式: .IGYRActionSheetBottomMargin(10.0f)
@property (nonatomic , copy , readonly ) CMConfigToFloat IGYRActionSheetBottomMargin;

/// 设置 是否可以关闭 -> 格式: .cmShouldClose(^{ return YES; })
@property (nonatomic, copy, readonly ) CMConfigToBlockReturnBool cmShouldClose;

/// 设置 是否可以关闭(Action 点击) -> 格式: .cmShouldActionClickClose(^(NSInteger index){ return YES; })
@property (nonatomic, copy, readonly ) CMConfigToBlockIntegerReturnBool cmShouldActionClickClose;

/// 设置 当前关闭回调 -> 格式: .CMCloseComplete(^{ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToBlock CMCloseComplete;
/// 设置 点击背景回调(modelIsClickBackgroundClose 回调 优先) -> 格式: .CMConfigToBackClickBlock(^{ //code.. })
@property (nonatomic , copy , readonly ) CMConfigToBackClickBlock CMBackClickComplete;
/// 是否开启底部安全区域设置 默认为关
@property (nonatomic , copy , readonly ) CMConfigToBool CMOpenSafeAreaBottom;
@end


@interface CMItem : NSObject

/// item类型
@property (nonatomic , assign ) CMItemType type;

/// item间距范围
@property (nonatomic , assign ) UIEdgeInsets insets;

/// item设置视图Block
@property (nonatomic , copy ) void (^block)(id view);

- (void)update;

@end

@interface IGYRAction : NSObject

/// action类型
@property (nonatomic , assign ) IGYRActionType type;

/// action标题
@property (nonatomic , strong ) NSString *title;

/// action高亮标题
@property (nonatomic , strong ) NSString *highlight;

/// action标题(attributed)
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/// action高亮标题(attributed)
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/// action字体
@property (nonatomic , strong ) UIFont *font;

/// action标题颜色
@property (nonatomic , strong ) UIColor *titleColor;

/// action高亮标题颜色
@property (nonatomic , strong ) UIColor *highlightColor;

/// action背景颜色 (与 backgroundImage 相同)
@property (nonatomic , strong ) UIColor *backgroundColor;

/// action高亮背景颜色
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/// action背景图片 (与 backgroundColor 相同)
@property (nonatomic , strong ) UIImage *backgroundImage;

/// action高亮背景图片
@property (nonatomic , strong ) UIImage *backgroundHighlightImage;

/// action图片
@property (nonatomic , strong ) UIImage *image;

/// action高亮图片
@property (nonatomic , strong ) UIImage *highlightImage;

/// action间距范围
@property (nonatomic , assign ) UIEdgeInsets insets;

/// action图片的间距范围
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/// action标题的间距范围
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/// action圆角曲率
@property (nonatomic , assign ) CGFloat cornerRadius;

/// action高度
@property (nonatomic , assign ) CGFloat height;

/// action边框宽度
@property (nonatomic , assign ) CGFloat borderWidth;

/// action边框颜色
@property (nonatomic , strong ) UIColor *borderColor;

/// action边框位置 默认是IGYRActionBorderPositionTop 如配置了CMAlertActionBorderStyle 可能会失效
@property (nonatomic , assign ) IGYRActionBorderPosition borderPosition;

/// action点击不关闭
@property (nonatomic , assign ) BOOL isClickNotClose;

/// action点击事件回调Block
@property (nonatomic , copy ) void (^ _Nullable clickBlock)(void);

- (void)update;

@end

@interface CMCustomView : NSObject

/// 自定义视图对象
@property (nonatomic , strong, nullable ) UIView *view;

/// 自定义视图位置类型 (默认为居中)
@property (nonatomic , assign ) CMCustomViewPositionType positionType;

/// 是否自动适应宽度 (不支持 AutoLayout 布局的视图)
@property (nonatomic , assign ) BOOL isAutoWidth;

@end

@interface LanYouAlertConfig : NSObject

@property (nonatomic , strong, nonnull ) LanYouAlertConfigModel *config;

@property (nonatomic , assign ) LanYouAlertType type;

@end


@interface LanYouAlertWindow : UIWindow @end

@interface LanYouAlertBaseController : UIViewController @end

@interface LanYouAlertViewController : LanYouAlertBaseController @end

@interface LanYouActionSheetViewController : LanYouAlertBaseController @end

NS_ASSUME_NONNULL_END
