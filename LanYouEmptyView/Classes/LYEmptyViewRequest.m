//
//  LYEmptyViewRequest.m
//  背景空数据提示图
//
//  Created by 符传刚 on 2020/7/3.
//  Copyright © 2020 符传刚. All rights reserved.
//

#import "LYEmptyViewRequest.h"

@implementation LYEmptyViewRequest

+ (id)shareRequest:(void(^)(void))clickHandle {
    LYEmptyViewRequest *request = [[self alloc] init];
    request.clickHandle = clickHandle;
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = kEmptyDefaultType;
        self.frame = kEmptyDefaultFrame;
        self.icon = [self loadBundleImage:@"ly_empty_default_icon.png"];
        
        self.title = @"";
        self.titleColor = kColorFromHEX(333333);
        self.titleFont = [UIFont systemFontOfSize:17];
        
        self.message = kEmptyDefaultMessage;
        self.messageColor = kColorFromHEX(999999);
        self.messageFont = [UIFont systemFontOfSize:13];
        self.messageCanClickRange = NSMakeRange(0, 0);
        self.messageCanClickColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.messageHilghlightColor = [UIColor blueColor];
        
        self.btnTitle = @"";
        self.btnTitleColor = [UIColor orangeColor];
        self.btnTitleFont = [UIFont systemFontOfSize:17];
        self.btnSize = CGSizeMake(164, 47);
        self.btnBgColor = [UIColor clearColor];
        self.btnLineColor = [UIColor orangeColor];
        self.btnLineWidth = 0.6;
        self.btnCornerRadius = self.btnSize.height / 2;
        
        self.btnToTopUISpan = 20;
        self.titleToTopUISpan = 20;
        self.messageToTopUISpan = 20;
        self.iconToTopSpan = 0;
        
        self.clickHandle = nil;
    }
    return self;
}

- (UIImage *)loadBundleImage:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) return image;
    
    // 获取当前的bundle,self只是在当前pod库中的一个类，也可以随意写一个其他的类
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    // 获取图片的路径,其中LanYouBaseClasses是组件名
    NSString *imagePath = [currentBundle pathForResource:imageName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle",@"LanYouEmptyView"]];
    // 获取图片
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
