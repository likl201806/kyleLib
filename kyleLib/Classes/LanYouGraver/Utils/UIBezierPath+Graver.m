//
//  UIBezierPath+Graver.m
//
    

#import "UIBezierPath+Graver.h"

@implementation UIBezierPath (Graver)

+ (UIBezierPath *)wmg_bezierPathWithRect:(CGRect)rect cornerRadius:(WMGCornerRadius)radius lineWidth:(CGFloat)lineWidth
{
    if (WMGCornerRadiusIsPerfect(radius)) {
        return [UIBezierPath bezierPathWithRoundedRect:rect
                                     byRoundingCorners:UIRectCornerAllCorners
                                           cornerRadii:CGSizeMake(radius.topLeft, radius.topLeft)];
    }
    
    CGFloat lineCenter = lineWidth / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(radius.topLeft, lineCenter)];
    [path addArcWithCenter:CGPointMake(radius.topLeft, radius.topLeft) radius:radius.topLeft - lineCenter startAngle:M_PI * 1.5 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(lineCenter, CGRectGetHeight(rect) - radius.bottomLeft)];
    [path addArcWithCenter:CGPointMake(radius.bottomLeft, CGRectGetHeight(rect) - radius.bottomLeft) radius:radius.bottomLeft - lineCenter startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - radius.bottomRight, CGRectGetHeight(rect) - lineCenter)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - radius.bottomRight, CGRectGetHeight(rect) - radius.bottomRight) radius:radius.bottomRight - lineCenter startAngle:M_PI * 0.5 endAngle:0.0 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - lineCenter, radius.topRight)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - radius.topRight, radius.topRight) radius:radius.topRight - lineCenter startAngle:0.0 endAngle:M_PI * 1.5 clockwise:NO];
    [path closePath];
    
    return path;
}

@end
