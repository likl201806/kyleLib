//
//  UIBezierPath+Graver.h
//
    

#import <UIKit/UIKit.h>
#import "UIImage+Graver.h"

@interface UIBezierPath (Graver)
/**
 * 该方法用来根据指定的矩形区域获取一个带圆角边框的路径
 * 一般情况下仅限于框架内部使用
 *
 * @param rect 矩形区域
 * @param radius 定义圆角的结构体，可以指定任意一个角的弧度
 * @param lineWidth 路径线条宽度
 *
 * @return 贝塞尔路径
 */
+ (UIBezierPath *)wmg_bezierPathWithRect:(CGRect)rect cornerRadius:(WMGCornerRadius)radius lineWidth:(CGFloat)lineWidth;

@end
