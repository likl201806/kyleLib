//
//  LYProgressHUD.h
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/7/1.
//

#import <Foundation/Foundation.h>
 
// HUD加载父view的类型
typedef NS_ENUM(NSUInteger, LYHUDInViewType) {
    LYHUDInViewTypeKeyWindow = 0, // 加载在KeyWindow上
    LYHUDInViewTypeCurrentView,   // 查找当前控制器的view并加载在上面
};

// HUD的位置类型
typedef NS_ENUM(NSUInteger, LYHUDPostionType) {
    LYHUDPostionTypeCenter,
    LYHUDPostionTypeTop,
    LYHUDPostionTypeBottom,
};

// HUD类型
typedef NS_ENUM(NSUInteger, LYProgressHUDType) {
    LYProgressHUDTypeToast,
    LYProgressHUDTypeLoading,
};

@interface LYProgressHUD : NSObject

#pragma mark - 示例方法
/**
 .message(@"需要显示的文字")
 */
- (LYProgressHUD * (^)(NSString *))message;

/**
 .messageColor(UIColor.redColor)，文字颜色，
 loading下默认#FFFFFF 88%，toast下默认 #02040B 88%
 */
- (LYProgressHUD * (^)(UIColor *))messageColor;

/**
 .messageFont([UIFont sys...]])，文字字体样式
 默认是12pt Regular
 */
- (LYProgressHUD * (^)(UIFont *))messageFont;
 
/**
 .multiLine(2)，文字最多显示行数，默认2行
 */
- (LYProgressHUD * (^)(NSUInteger))numberOfLines;

/**
 .indicatorColor(UIColor.redColor)，加载指示器颜色，默认渐变最深颜色#02040B 88%
 */
- (LYProgressHUD * (^)(UIColor *))indicatorColor;

/**
 .bezelColor(UIColor.redColor)，挡板的颜色
 loading下默认透明，toast下默认黑色0.85的alpha
 */
- (LYProgressHUD * (^)(UIColor *))bezelColor;

/**
 .customView(view),设置自定义的 customView
 */
- (LYProgressHUD * (^)(UIView *))customView;

/**
 .inViewType(inViewType) 加载到指定view类型
 LYHUDInViewTypeKeyWindow -- KeyWindow
 LYHUDInViewTypeCurrentView -- 内部查到当前的控制前的view
 */
- (LYProgressHUD * (^)(LYHUDInViewType))inViewType;

/**
 .inView(view)，加载到指定的view上，如果加载在window或者控制器view上，建议用inViewType方法
 */
- (LYProgressHUD * (^)(UIView *) )inView;

/**
 .postionType(LYHUDPostionTypeBottom) HUD的位置
 默认在中间LYHUDPostionTypeCenter
 */
- (LYProgressHUD * (^)(LYHUDPostionType) )postionType;

/**
 .enableThrough(YES)，是否能够穿透HUD view，默认NO; 能穿透，hud背后的view是还可以操作响应的
 */
- (LYProgressHUD * (^)(BOOL) )enableThrough;

/**
 .enableThroughRect(CGRectMake(0, 0, 100, 100))，可穿透区域，default is CGRectZero
 备注：如果enableThrough=YES，则会全部穿透，enableThroughRect设不设置都无所谓
 */
- (LYProgressHUD * (^)(CGRect))enableThroughRect;

/**
 .afterDelay 消失时间，默认是 0 秒，即不消失，防止出现不消失的场景，如果传 0，会默认设置 20 秒后自动消失
 */
- (LYProgressHUD * (^)(NSTimeInterval))afterDelay;

/**
 .animated(YES)是否动画消失，YES动画，NO不动画，默认为 YES
 */
- (LYProgressHUD * (^)(BOOL))animated;
 
/**
 隐藏HUD，实例方法
 */
- (void)hideAnimated:(BOOL)animated;

/**
 隐藏view内的所有HUD
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

#pragma mark - 类方法
/**
 toast显示，默认2秒隐藏
 */
+ (LYProgressHUD *)showMessageHUD:(void (^)(LYProgressHUD *make))block;

/**
 菊花loading显示，HUD默认不隐藏
 */
+ (LYProgressHUD *)showLoadingHUD:(void (^)(LYProgressHUD *make))block;

/**
 环形头结尾loading显示，HUD默认不隐藏
 */
+ (LYProgressHUD *)showCircleLoadingHUD:(void (^)(LYProgressHUD *make))block;

/**
 环形旋转的loading显示，HUD默认不隐藏
 */
+ (LYProgressHUD *)showRotateLoadingHUD:(void (^)(LYProgressHUD *make))block;

/**
 打勾显示，默认1秒隐藏
 */
+ (LYProgressHUD *)showDoneHUD:(void (^)(LYProgressHUD *make))block;

/**
 环形旋转的上传loading显示，HUD默认不隐藏
 */
+ (LYProgressHUD *)showUploadRotateLoadingHUD:(void (^)(LYProgressHUD *make))block;


@end 












/**
 隐藏指定view上的HUD
 */
//+ (void)hideInView:(UIView *)view animated:(BOOL)animated NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "废弃，目前全局仅持有一个HUD，所有InView:(UIView *)view是无用的");

/**
 全局有两个HUD，toast和loading。如果HUDType不传则这两个都消失
 */
//+ (void)hideHUDType:(LYProgressHUDType)HUDType animated:(BOOL)animated;
//+ (void)hideAnimated:(BOOL)animated;

 
