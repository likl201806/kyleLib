//
//  UIImage+HUD.h
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HUD)

+ (UIImage *)ly_createImageWithColor:(UIColor *)color size:(CGSize)size;


+ (UIImage *)ly_myBundleImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
