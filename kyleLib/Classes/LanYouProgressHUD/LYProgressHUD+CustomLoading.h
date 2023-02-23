//
//  LYProgressHUD+CustomLoading.h
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/7/5.
//

#import "LYProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN
 

@interface LYProgressHUD (CustomLoading)

// 环形头结尾动画
+ (void)ly_circleAnimateWithIndicatorContainView:(UIView *)indicatorContainView
                                            size:(CGSize)size
                                  indicatorColor:(UIColor *)indicatorColor;

// 圆圈转动动画
+ (void)ly_roateAnimateWithIndicatorContainView:(UIView *)indicatorContainView
                                           size:(CGSize)size
                                 indicatorColor:(UIColor *)indicatorColor;

@end

NS_ASSUME_NONNULL_END
