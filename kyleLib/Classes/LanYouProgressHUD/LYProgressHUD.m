//
//  LYProgressHUD.m
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/7/1.
//

#import "LYProgressHUD.h"
#import "LYProgressHUD+CustomLoading.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+HUD.h"
#import "MBProgressHUD+Touch.h"
#import "UIImage+HUD.h"
 
#define LYHUDWeakSelf      __weak typeof(self) weakSelf = self;
 
// toast默认显示时间
static CGFloat const kHudToastDefault = 2.f;
// toast默认显示时间
static CGFloat const kDoneHudDefault = 1.f;

//@interface LYProgressHUDManager : NSObject
///// 全局只有两个HUDs
//@property (strong, nonatomic) MBProgressHUD *toastHUD;
//@property (strong, nonatomic) MBProgressHUD *loadingHUD;
//
//+ (instancetype)manager;
//
//@end

//@implementation LYProgressHUDManager
//
//+ (instancetype)manager {
//    static LYProgressHUDManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[self alloc] init];
//    });
//    return manager;
//}
//
//@end


@interface LYProgressHUD ()
/* HUD类型 */
@property (assign, nonatomic) LYProgressHUDType ly_HUDType;
/* hud上面的文字 */
@property (nonatomic, strong) NSString *ly_message;
/* 文字的颜色 */
@property (nonatomic, strong) UIColor *ly_messageColor;
/* 文字字体样式 */
@property (nonatomic, strong) UIFont *ly_messageFont;
/* hud上面的文字是否多行 */
//@property (nonatomic, assign) BOOL ly_multiLine;
/* 文字最多显示行数 */
@property (assign, nonatomic) NSUInteger ly_numberOfLines;
/* 指示器的颜色 */
@property (nonatomic, strong) UIColor *ly_indicatorColor;
/* 挡板的颜色 */
@property (nonatomic, strong) UIColor *ly_bezelColor;
/* 自定义的view */
@property (nonatomic, strong) UIView *ly_customView;
/* hud加在那个view上 */
@property (nonatomic, strong) UIView *ly_inView;
/* hud的位置 */
@property (nonatomic, assign) LYHUDPostionType ly_postionType;
/* 是否穿透 */
@property (nonatomic, assign) BOOL ly_enableThrough;
/* 穿透区域 */
@property (assign, nonatomic) CGRect ly_enableThroughRect;
/* 自动消失时间,default = 0 */
@property (nonatomic, assign) NSTimeInterval ly_afterDelay;
/* 是否动画显示、消失 */
@property (nonatomic, assign) BOOL ly_animated;
/// <#Description#>
@property (strong, nonatomic) MBProgressHUD *HUD;
@end

@implementation LYProgressHUD

#pragma mark - init

- (instancetype)initWithType:(LYProgressHUDType)type{
    self = [super init];
    if (self) {
        _ly_HUDType = type;
         
        // 公用默认属性
        _ly_inView = UIApplication.sharedApplication.delegate.window;
        _ly_animated = YES;
        _ly_messageFont = [UIFont systemFontOfSize:16.f];
        _ly_numberOfLines = 2;
    }
    return self;
}

- (LYProgressHUD * (^)(NSString *) )message {
    LYHUDWeakSelf
    return ^LYProgressHUD *(NSString *msg) {
        weakSelf.ly_message = msg;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(UIColor *))messageColor {
    LYHUDWeakSelf
    return ^LYProgressHUD *(UIColor *messageColor) {
        weakSelf.ly_messageColor = messageColor;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(UIFont *))messageFont {
    LYHUDWeakSelf
    return ^LYProgressHUD *(UIFont *messageFont) {
        weakSelf.ly_messageFont = messageFont;
        return weakSelf;
    };
}
 
- (LYProgressHUD * (^)(NSUInteger) )numberOfLines {
    LYHUDWeakSelf
    return ^LYProgressHUD *(NSUInteger numberOfLines) {
        weakSelf.ly_numberOfLines = numberOfLines;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(UIColor *))indicatorColor {
    LYHUDWeakSelf
    return ^LYProgressHUD *(UIColor *indicatorColor) {
        weakSelf.ly_indicatorColor = indicatorColor;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(UIColor *))bezelColor {
    LYHUDWeakSelf
    return ^LYProgressHUD *(UIColor *bezelColor) {
        weakSelf.ly_bezelColor = bezelColor;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(UIView *) )customView {
    LYHUDWeakSelf
    return ^LYProgressHUD *(id obj) {
        weakSelf.ly_customView = obj;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(LYHUDInViewType))inViewType {
    LYHUDWeakSelf
    return ^LYProgressHUD *(LYHUDInViewType inViewType) {
        if (inViewType == LYHUDInViewTypeKeyWindow) {
            weakSelf.ly_inView = [UIApplication sharedApplication].keyWindow;
        } else if (inViewType == LYHUDInViewTypeCurrentView) {
            weakSelf.ly_inView = [LYProgressHUD fmi_topViewController].view;
            if (!weakSelf.ly_inView) {
                weakSelf.ly_inView = [UIApplication sharedApplication].keyWindow;
            }
        }
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(UIView *) )inView {
    LYHUDWeakSelf
    return ^LYProgressHUD *(id obj) {
        if (obj) {
            weakSelf.ly_inView = obj;
        }else {
            weakSelf.ly_inView = [UIApplication sharedApplication].keyWindow;
        }
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(LYHUDPostionType) )postionType {
    LYHUDWeakSelf
    return ^LYProgressHUD *(LYHUDPostionType postionType) {
        weakSelf.ly_postionType = postionType;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(BOOL) )enableThrough {
    LYHUDWeakSelf
    return ^LYProgressHUD *(BOOL enableThrough) {
        weakSelf.ly_enableThrough = enableThrough;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(CGRect))enableThroughRect {
    LYHUDWeakSelf
    return ^LYProgressHUD *(CGRect enableThroughRect) {
        weakSelf.ly_enableThroughRect = enableThroughRect;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(NSTimeInterval))afterDelay {
    LYHUDWeakSelf
    return ^LYProgressHUD *(NSTimeInterval afterDelay) {
        weakSelf.ly_afterDelay = afterDelay;
        return weakSelf;
    };
}

- (LYProgressHUD * (^)(BOOL))animated {
    LYHUDWeakSelf
    return ^LYProgressHUD *(BOOL animated) {
        weakSelf.ly_animated = animated;
        return weakSelf;
    };
}

- (void)hideAnimated:(BOOL)animated {
    [self.HUD hideAnimated:animated];
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    return [MBProgressHUD hideHUDForView:view animated:animated];;
}
 
#pragma mark - Toast Message

+ (LYProgressHUD *)showMessageHUD:(void (^)(LYProgressHUD *))block {
    NSAssert([NSThread isMainThread], @"必须在主线程调用 UI 相关");
    
    LYProgressHUD *makeObj = [[LYProgressHUD alloc] initWithType:LYProgressHUDTypeToast];
    if (block) {
        block(makeObj);
    }
    
    // 容错
    if (![makeObj.ly_message isKindOfClass:NSString.class]) {
        return nil;
    }
    if (makeObj.ly_message.length == 0) {
        return nil;
    }
    
    // 默认 2 秒后自动消失
    if (makeObj.ly_afterDelay <= 0) {
        makeObj.ly_afterDelay = kHudToastDefault;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.ly_inView animated:makeObj.ly_animated];
    makeObj.HUD = hud;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    if (makeObj.ly_numberOfLines >= 2) {
        hud.detailsLabel.numberOfLines = makeObj.ly_numberOfLines;
        hud.detailsLabel.text = makeObj.ly_message;
        hud.detailsLabel.font = makeObj.ly_messageFont;
    } else {
        hud.label.text = makeObj.ly_message;
        hud.label.font = makeObj.ly_messageFont;
    }
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = !makeObj.ly_enableThrough;
    hud.bezelView.backgroundColor = makeObj.ly_bezelColor;
    hud.margin = 15;
    hud.offset = [LYProgressHUD offsetWithPostionType:makeObj.ly_postionType];
    if (makeObj.ly_afterDelay > 0) {
        [hud hideAnimated:YES afterDelay:makeObj.ly_afterDelay];
    }
    if (makeObj.ly_customView) {
        hud.customView = makeObj.ly_customView;
        hud.mode = MBProgressHUDModeCustomView;
    }
    
    if (makeObj.ly_numberOfLines >= 2) { // 文字颜色最后，否则无效
        hud.detailsLabel.textColor = makeObj.ly_messageColor;
    } else {
        hud.label.textColor = makeObj.ly_messageColor;
    }
    
    hud.ly_enableThroughRect = makeObj.ly_enableThroughRect;
    
    return makeObj;
}

#pragma mark - Loading
+ (LYProgressHUD *)showLoadingHUD:(void (^)(LYProgressHUD *))block {
    NSAssert([NSThread isMainThread], @"必须在主线程调用 UI 相关");
     
    LYProgressHUD *makeObj = [[LYProgressHUD alloc] initWithType:LYProgressHUDTypeLoading];
    if (block) {
        block(makeObj);
    }
     
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.ly_inView animated:makeObj.ly_animated];
    makeObj.HUD = hud;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    if (makeObj.ly_message) {
        if (makeObj.ly_numberOfLines >= 2) {
            hud.detailsLabel.numberOfLines = makeObj.ly_numberOfLines;
            hud.detailsLabel.text = makeObj.ly_message;
            hud.detailsLabel.font = makeObj.ly_messageFont;
        } else {
            hud.label.text = makeObj.ly_message;
            hud.label.font = makeObj.ly_messageFont;
        }
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = !makeObj.ly_enableThrough;
    hud.bezelView.backgroundColor = makeObj.ly_bezelColor;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic pop
    hud.offset = [LYProgressHUD offsetWithPostionType:makeObj.ly_postionType];
    if (makeObj.ly_afterDelay > 0) {
        [hud hideAnimated:YES afterDelay:makeObj.ly_afterDelay];
    }
    if (makeObj.ly_customView) {
        hud.customView = makeObj.ly_customView;
        hud.mode = MBProgressHUDModeCustomView;
    }
    
    if (makeObj.ly_numberOfLines >= 2) { // 文字颜色最后，否则无效
        hud.detailsLabel.textColor = makeObj.ly_messageColor;
    } else {
        hud.label.textColor = makeObj.ly_messageColor;
    }
     
    hud.ly_enableThroughRect = makeObj.ly_enableThroughRect;
    
    return makeObj;
}
 
+ (LYProgressHUD *)showCircleLoadingHUD:(void (^)(LYProgressHUD *make))block {
    LYProgressHUD *HUD = [LYProgressHUD showLoadingHUD:^(LYProgressHUD * _Nonnull make) {
        if (block) {
            block(make);
        }
        
        // 自定义加载动画
        CGSize imageSize = CGSizeMake(40, 40);
        UIImage *image = [UIImage ly_createImageWithColor:UIColor.clearColor size:imageSize];
         
        UIImageView *customView = [[UIImageView alloc] initWithImage:image];
        
        [LYProgressHUD ly_circleAnimateWithIndicatorContainView:customView size:imageSize indicatorColor:make.ly_indicatorColor];
        
        make.customView(customView);
    }];
    
    return HUD;
}
 
+ (LYProgressHUD *)showRotateLoadingHUD:(void (^)(LYProgressHUD *make))block {
    return [LYProgressHUD showCommomRotateLoadingHUDImageName:@"ly_hud_loading" bezelColor:UIColor.clearColor block:block];
}

+ (LYProgressHUD *)showUploadRotateLoadingHUD:(void (^)(LYProgressHUD *make))block {
    return [LYProgressHUD showCommomRotateLoadingHUDImageName:@"ly_hud_loading_white" bezelColor:[UIColor colorWithRed:2/255.0 green:4/255.0 blue:11/255.0 alpha:0.60] block:block];
}

+ (LYProgressHUD *)showCommomRotateLoadingHUDImageName:(NSString *)imageName bezelColor:(UIColor *)bezelColor block:(void (^)(LYProgressHUD *make))block {
    LYProgressHUD *HUD = [LYProgressHUD showLoadingHUD:^(LYProgressHUD * _Nonnull make) {
        make.bezelColor(bezelColor);
        if (block) {
            block(make);
        }
        
        // 自定义加载动画
        CGSize imageSize = CGSizeMake(40, 40);
        UIImage *image = [UIImage ly_createImageWithColor:UIColor.clearColor size:imageSize];

        UIImageView *customView = [[UIImageView alloc] initWithImage:image];
        
        UIImage *loadingImage = [UIImage ly_myBundleImageName:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:loadingImage];
        imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        [customView addSubview:imageView];
        
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.duration = 1.25;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.removedOnCompletion = NO;
        
        [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

        make.customView(customView);
    }];
    
    return HUD;
}

#pragma mark - 图标不旋转
/**
 打勾显示，默认1秒隐藏
 */
+ (LYProgressHUD *)showDoneHUD:(void (^)(LYProgressHUD *make))block{
    LYProgressHUD *makeObj = [LYProgressHUD showCommomHUDImageName:@"ly_hud_done" bezelColor:UIColor.clearColor block:block];
    // 默认 1 秒后自动消失
    double delayInSeconds = 1.0;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [makeObj hideAnimated:YES];
    });
    
    return makeObj;
}

/**
 图片不旋转的HUD
 @param imageName 图片名称
 @param bezelColor 背景颜色
 @param block 回调
 */
+ (LYProgressHUD *)showCommomHUDImageName:(NSString *)imageName bezelColor:(UIColor *)bezelColor block:(void (^)(LYProgressHUD *make))block {
    LYProgressHUD *HUD = [LYProgressHUD showLoadingHUD:^(LYProgressHUD * _Nonnull make) {
        make.bezelColor(bezelColor);
        if (block) {
            block(make);
        }
        
        // 自定义加载动画
        CGSize imageSize = CGSizeMake(40, 40);
        UIImage *image = [UIImage ly_createImageWithColor:UIColor.clearColor size:imageSize];

        UIImageView *customView = [[UIImageView alloc] initWithImage:image];
        
        UIImage *loadingImage = [UIImage ly_myBundleImageName:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:loadingImage];
        imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        [customView addSubview:imageView];

        make.customView(customView);
    }];
    
    return HUD;
}

#pragma mark - Private
+ (UIViewController *)fmi_topViewController {
    UIViewController *topVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }

    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *mainview = (UITabBarController *) topVC;
        UINavigationController *selectView = [mainview.viewControllers objectAtIndex:mainview.selectedIndex];
        if (selectView) {
            return selectView.visibleViewController;
        }
    } else if ([topVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *selectView = (UINavigationController *) topVC;
        return selectView.visibleViewController;
    } else if (topVC && [topVC isKindOfClass:[UIViewController class]]) {
        return topVC;
    }
    return nil;
}

+ (CGPoint)offsetWithPostionType:(LYHUDPostionType)postionType {
    switch (postionType) {
        case LYHUDPostionTypeTop:
            return CGPointMake(0.f, -MBProgressMaxOffset);
        case LYHUDPostionTypeBottom:
            return CGPointMake(0.f, MBProgressMaxOffset);
        case LYHUDPostionTypeCenter:
        default:
            return CGPointZero;
    }
}

#pragma mark - Lazy
- (UIColor *)ly_messageColor {
    if (!_ly_messageColor) {
        switch (self.ly_HUDType) {
            case LYProgressHUDTypeLoading:
                _ly_messageColor = [UIColor colorWithRed:2.f / 255.f green:4.f / 255.f blue:11.f / 255.f alpha:0.88];
                break;
            case LYProgressHUDTypeToast:
                _ly_messageColor = [UIColor colorWithWhite:1.0 alpha:0.88];
                break;
        }
    }
    return _ly_messageColor;
}

- (UIColor *)ly_indicatorColor {
    if (!_ly_indicatorColor) {
        _ly_indicatorColor = [UIColor colorWithRed:2.f / 255.f green:4.f / 255.f blue:11.f / 255.f alpha:0.88];;
    }
    return _ly_indicatorColor;
}

- (UIColor *)ly_bezelColor {
    if (!_ly_bezelColor) {
        switch (self.ly_HUDType) {
            case LYProgressHUDTypeLoading:
                _ly_bezelColor = UIColor.clearColor;
                break;
            case LYProgressHUDTypeToast:
                _ly_bezelColor = [UIColor colorWithWhite:0.0 alpha:0.85];
                break;
        }
    }
    return _ly_bezelColor;
}

@end 
