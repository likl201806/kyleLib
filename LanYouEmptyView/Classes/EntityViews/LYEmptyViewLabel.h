//
//  LYEmptyViewLabel.h
//  LYEmptyViewBridge
//
//  Created by 符传刚 on 2020/10/30.
//  Copyright © 2020 JGBlazers. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LYEmptyViewLabelRange;
@interface LYEmptyViewLabel : UILabel

/** 范围数组 */
@property (nonatomic, strong) NSArray <LYEmptyViewLabelRange *>*highlightRangs;

/** 高亮颜色 */
@property (nonatomic, strong) UIColor *highlightColor;

/** 点击高亮文字的颜色 */
@property (nonatomic, strong) UIColor *clickHighlightColor;

/**
 *  配置完所有信息都，最后调用这个方法，重启字符串的渲染 => 不调用这个方法，就无法出现相应的属性字符串了
 */
- (void)onConfigFinish:(void(^)(LYEmptyViewLabel *label, NSString *clickString, NSRange clickRange))clickHandle;

@end


@interface LYEmptyViewLabelRange : NSObject

/** 起点 */
@property (nonatomic, assign) NSUInteger loc;
/** 长度 */
@property (nonatomic, assign) NSUInteger len;

+ (instancetype)createForLoc:(NSInteger)loc len:(NSInteger)len;

@end

NS_ASSUME_NONNULL_END
