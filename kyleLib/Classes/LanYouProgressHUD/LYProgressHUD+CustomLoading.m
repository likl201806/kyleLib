//
//  LYProgressHUD+CustomLoading.m
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/7/5.
//

#import "LYProgressHUD+CustomLoading.h"
#import "UIImage+HUD.h"

static CGFloat const kLineWith = 4.f;

@implementation LYProgressHUD (CustomLoading)
 
+ (void)ly_circleAnimateWithIndicatorContainView:(UIView *)indicatorContainView
                                            size:(CGSize)size
                                  indicatorColor:(UIColor *)indicatorColor
{
    //外层旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0.0;
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.duration = 2.0;
    rotationAnimation.beginTime = 0.0;
    
    [indicatorContainView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    //内层进度条动画
    CABasicAnimation *strokeAnim1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnim1.fromValue = @0.0;
    strokeAnim1.toValue = @1.0;
    strokeAnim1.duration = 1.0;
    strokeAnim1.beginTime = 0.0;
    strokeAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //内层进度条动画
    CABasicAnimation *strokeAnim2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeAnim2.fromValue = @0.0;
    strokeAnim2.toValue = @1.0;
    strokeAnim2.duration = 1.0;
    strokeAnim2.beginTime = 1.0;
    strokeAnim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 2.0;
    animGroup.repeatCount = HUGE_VALF;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.animations = @[strokeAnim1, strokeAnim2];
     
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CAShapeLayer *circleViewLayer = [CAShapeLayer layer];
    circleViewLayer.lineWidth = kLineWith;
    circleViewLayer.lineCap = kCALineCapRound;
    circleViewLayer.strokeColor = indicatorColor.CGColor;
    circleViewLayer.fillColor = [UIColor clearColor].CGColor;
    circleViewLayer.strokeStart = 0.0;
    circleViewLayer.strokeEnd = 1.0;
    circleViewLayer.path = path.CGPath;
    [circleViewLayer addAnimation:animGroup forKey:@"strokeAnim"];
    
    [indicatorContainView.layer addSublayer:circleViewLayer];
}


+ (void)ly_roateAnimateWithIndicatorContainView:(UIView *)indicatorContainView size:(CGSize)size indicatorColor:(UIColor *)indicatorColor
{ 
    CGFloat radius = size.width / 2 - kLineWith / 2;
    CGPoint arcCenter = CGPointMake(radius + kLineWith / 2, radius + kLineWith / 2);
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:(CGFloat) (M_PI*3/2) endAngle:(CGFloat) (M_PI/2+M_PI*5) clockwise:YES];
    
    CAShapeLayer *rotateViewLayer = [CAShapeLayer layer];
    rotateViewLayer.contentsScale = [[UIScreen mainScreen] scale];
    rotateViewLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
    rotateViewLayer.fillColor = [UIColor clearColor].CGColor;
    rotateViewLayer.strokeColor = indicatorColor.CGColor;
    rotateViewLayer.lineWidth = kLineWith;
    rotateViewLayer.lineCap = kCALineCapRound;
    rotateViewLayer.lineJoin = kCALineJoinBevel;
    rotateViewLayer.path = smoothedPath.CGPath;
    
    CALayer *maskLayer = [CALayer layer];
    
    UIImage *maskImage = [UIImage ly_myBundleImageName:@"ly_hud_angle-mask"];
 
    maskLayer.contents = (__bridge id)[maskImage CGImage];
    maskLayer.frame = indicatorContainView.bounds;
    indicatorContainView.layer.mask = maskLayer;
    
    NSTimeInterval animationDuration = 1;
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = (id) 0;
    animation.toValue = @(M_PI*2);
    animation.duration = animationDuration;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [indicatorContainView.layer.mask addAnimation:animation forKey:@"rotate"];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = linearCurve;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @0.015;
    strokeStartAnimation.toValue = @0.515;
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0.485;
    strokeEndAnimation.toValue = @0.985;
    
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    [indicatorContainView.layer addAnimation:animationGroup forKey:@"progress"];
    
    [indicatorContainView.layer addSublayer:rotateViewLayer];
}

 
#pragma mark - Private

 

@end
