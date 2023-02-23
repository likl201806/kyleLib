//
//  LanYouDiscoverCommon.h
//

#ifndef LanYouDiscoverCommon_h
#define LanYouDiscoverCommon_h


// **************  编码所需公共提宏  ************** /
//弱引用
#define kCMDWEAKSELF typeof(self) __weak weakSelf = self

// 获取当前版本号
#define kGetVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// **************  布局所需提宏  ************** ///获取屏幕宽高
#define kCMDScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kCMDScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kCMDScreenSize [UIScreen mainScreen].bounds.size
#define kCMDRScreenHeight(w, h) (kCMDScreenWidth * (h) / w)

// 是否是iPhone X
#define kCMD_is_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kCMDStatusBarHeight (kCMD_is_iPhoneX ? 44.0 : 20.0)
#define kCMDNavBarHeight (kCMD_is_iPhoneX ? 88.0 : 64.0)
#define kCMDTabbarHeight (kCMD_is_iPhoneX ? 83.0 : 49.0)
#define kCMDSearchBarHeight (kCMD_is_iPhoneX ? 84.0 : 64.0)
#define kCMDAriyaTitleHeight 44.0

//设置light字体大小
#define kCMDLightFont(f) [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
// 设置普通字体大小
#define kCMDFont(f) [UIFont systemFontOfSize:(f)]
// 设置普通字体大小
#define kCMDBoldFont(f) [UIFont boldSystemFontOfSize:(f)]

// 随机色
#define kCMDColorARC [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
// 设置普通RGB颜色
#define kCMDColorRGBA( r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kCMDColorFromHEX(value)  [UIColor colorWithRed:((float)((0x##value & 0xFF0000) >> 16))/255.0 green:((float)((0x##value & 0xFF00) >> 8))/255.0 blue:((float)(0x##value & 0xFF))/255.0 alpha:1.0]

#endif /* LanYouDiscoverCommon_h */


