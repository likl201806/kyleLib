//
//  LYEmptyViewRequest.h
//  背景空数据提示图
//
//  Created by 符传刚 on 2020/7/3.
//  Copyright © 2020 符传刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kColorFromHEX(value)  [UIColor colorWithRed:((float)((0x##value & 0xFF0000) >> 16))/255.0 green:((float)((0x##value & 0xFF00) >> 8))/255.0 blue:((float)(0x##value & 0xFF))/255.0 alpha:1.0]

#define kEmptyDefaultType       LYEmptyViewCreateTypeDefault
#define kEmptyDefaultMessage    @"暂无数据"
#define kEmptyDefaultFrame      CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

// 后面要拓展，需要再此新增对应指向的枚举，配置到request当中即可
typedef enum {
    
    LYEmptyViewCreateTypeDefault,   // 默认
} LYEmptyViewCreateType;

@interface LYEmptyViewRequest : NSObject

// 初始化 如果不想使用这个也可以，直接调用 alloc init
+ (id)shareRequest:(void(^)(void))clickHandle;

#pragma mark: <---------- 以下为默认属性 ---------->
// 如果需要传入更多信息，可以通过拓展相关属性到request中，传过去

/** 创建对应类型的View的类型 默认是 LYEmptyViewCreateTypeDefault */
@property (nonatomic, assign) LYEmptyViewCreateType type;

/** 视图的frame 不传，默认是 屏幕的物理尺寸 */
@property (nonatomic, assign) CGRect frame;

/** 背景的图标icon 默认使用图片 ly_empty_default_icon.png */
@property (nonatomic, strong) UIImage *icon;

#pragma mark: <---------- 标题配置 ---------->
/** 标题 不要就不传 */
@property (nonatomic, copy) NSString *title;
/** 标题的颜色 默认 333333 */
@property (nonatomic, strong) UIColor *titleColor;
/** 标题字体大小 默认17号 */
@property (nonatomic, strong) UIFont *titleFont;

#pragma mark: <---------- 内容配置 ---------->
/** 提示的内容 默认显示 暂无数据 */
@property (nonatomic, copy) NSString *message;
/** 内容的字体颜色 默认 999999 */
@property (nonatomic, strong) UIColor *messageColor;
/** 内容字体大小 默认13号 */
@property (nonatomic, strong) UIFont *messageFont;

/** 匹配点击事件的范围 */
@property (nonatomic, assign) NSRange messageCanClickRange;
/** 高亮字体颜色 */
@property (nonatomic, strong) UIColor *messageHilghlightColor;
/** 点击高亮部分字体背景颜色 */
@property (nonatomic, strong) UIColor *messageCanClickColor;

#pragma mark: <---------- 按钮配置 ---------->
/** 按钮标题 传值过来就有按钮，不传值，就不显示按钮，不存在默认按钮 */
@property (nonatomic, copy) NSString *btnTitle;
/** 按钮字体颜色 默认(orangeColor) */
@property (nonatomic, strong) UIColor *btnTitleColor;
/** 按钮字体大小 默认 17 号 */
@property (nonatomic, strong) UIFont *btnTitleFont;
/** 按钮大小 默认 (164, 47) */
@property (nonatomic, assign) CGSize btnSize;
/** 按钮背景颜色 默认无色 */
@property (nonatomic, strong) UIColor *btnBgColor;
/** 按钮边框颜色 默认 orangeColor */
@property (nonatomic, strong) UIColor *btnLineColor;
/** 按钮边框大小 0.6 */
@property (nonatomic, assign) CGFloat btnLineWidth;
/** 按钮边框大小 圆角 默认按钮高度的二分之一 */
@property (nonatomic, assign) CGFloat btnCornerRadius;

/** 图标到顶部的距离，为0表示默认排列距离 => 考虑到使用过程中，背景提示图标到顶部的距离，默认排列不能达到想要的效果，那么就通过这个属性传入 */
@property (nonatomic, assign) CGFloat iconToTopSpan;
/** 标题到头上控件的间隔，默认是20 */
@property (nonatomic, assign) CGFloat titleToTopUISpan;
/** 提示的内容到头上控件的间隔，默认是20 */
@property (nonatomic, assign) CGFloat messageToTopUISpan;
/** 按钮到头上控件的间隔，默认是20 */
@property (nonatomic, assign) CGFloat btnToTopUISpan;

#pragma mark: <---------- 以下为扩展属性 ---------->
/** 点击按钮或者图标回调 */
@property (nonatomic, strong) void(^clickHandle)(void);


@end
