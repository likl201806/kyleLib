//
//  UIImage+HUD.m
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/7/5.
//

#import "UIImage+HUD.h"
#import "LYProgressHUD.h"

@implementation UIImage (HUD)

+ (UIImage *)ly_createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)ly_myBundleImageName:(NSString *)imageName {
    UIImage *assetImg = [UIImage imageNamed:imageName];
    if (assetImg){
        return assetImg;
    }
    NSBundle *currentBundle = [NSBundle bundleForClass:[LYProgressHUD class]];
    NSString *path = [currentBundle pathForResource:imageName ofType:@"png" inDirectory:@"LanYouProgressHUD.bundle"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

@end
