//
//  WMGTextDrawer+Debug.h
//
    

#import "WMGTextDrawer.h"

@class WMGTextLayoutFrame;
NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer (Debug)

/**
 *  判断Debug开关是否打开
 *
 *  @return YES or NO
 */
+ (BOOL)debugModeEnabled;

/**
 *  打开Debug开关
 */
+ (void)enableDebugMode;
/**
 *  关闭Debug开关
 */
+ (void)disableDebugMode;

/**
 *  设置Debug开关
 *
 *  @param enabled YES or NO
 */
+ (void)setDebugModeEnabled:(BOOL)enabled;

/**
 *  框架内部使用，用来控制是否为每一个绘制元素添加调试底色
 *
 *  @param layoutFrame 排版结果
 *  @param ctx 上下文
 */
- (void)debugModeDrawLineFramesWithLayoutFrame:(WMGTextLayoutFrame *)layoutFrame context:(CGContextRef)ctx;

@end

NS_ASSUME_NONNULL_END
