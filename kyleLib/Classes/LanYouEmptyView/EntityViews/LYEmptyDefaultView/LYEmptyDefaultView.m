//
//  LYEmptyDefaultView.m
//  背景空数据提示图
//
//  Created by 符传刚 on 2020/7/3.
//  Copyright © 2020 符传刚. All rights reserved.
//

#import "LYEmptyDefaultView.h"
#import "LYEmptyViewRequest.h"
#import "LYEmptyViewLabel.h"

@interface LYEmptyDefaultView ()

/* 提示图片 */
@property (nonatomic, strong) UIImageView *iconImgView;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 内容 */
@property (nonatomic, strong) LYEmptyViewLabel *messageLabel;

/* 按钮 */
@property (nonatomic, strong) UIButton *menusBtn;

/* 参数类 */
@property (nonatomic, strong) LYEmptyViewRequest *request;

@end

@implementation LYEmptyDefaultView

/**
 *  初始化视图  因为frame在request中，所以初始化只传request
 *  @param request    视图参数
 */
- (id <LYEmptyViewType>)initWithRequest:(LYEmptyViewRequest *)request {
    return [[LYEmptyDefaultView alloc] initWithFrame:request.frame request:request];
}

- (instancetype)initWithFrame:(CGRect)frame request:(LYEmptyViewRequest *)request {
    self = [super initWithFrame:frame];
    if (self) {
        self.request = request;
        
        request.title = [self isFormattingString:request.title];
        request.message = [self isFormattingString:request.message];
        request.btnTitle = [self isFormattingString:request.btnTitle];
        
        if (request.message.length == 0) request.message = kEmptyDefaultMessage;
        
        /* 提示图片 */
        UIImageView *iconImgView = [[UIImageView alloc] initWithImage:request.icon];
        iconImgView.userInteractionEnabled = YES;
        [self addSubview:iconImgView];
        self.iconImgView = iconImgView;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshClick)];
        singleTap.delaysTouchesBegan = YES;
        [iconImgView addGestureRecognizer:singleTap];
        
        if (request.title.length > 0) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = request.titleFont;
            titleLabel.text = request.title;
            titleLabel.textColor = request.titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:titleLabel];
            self.titleLabel = titleLabel;
        }
        
        /* 内容 */
        LYEmptyViewLabel *messageLabel = [[LYEmptyViewLabel alloc] initWithFrame:CGRectZero];
        messageLabel.text = request.message;
        messageLabel.font = request.messageFont;
        messageLabel.textColor = request.messageColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 3;
        [self addSubview:messageLabel];
        self.messageLabel = messageLabel;
        if (request.messageCanClickRange.length > 0) {
            messageLabel.highlightRangs = @[[LYEmptyViewLabelRange createForLoc:request.messageCanClickRange.location len:request.messageCanClickRange.length]];
            messageLabel.highlightColor = request.messageHilghlightColor;
            messageLabel.clickHighlightColor = request.messageCanClickColor;
            
            // 最后调用这一句
            [messageLabel onConfigFinish:^(LYEmptyViewLabel * _Nonnull label, NSString * _Nonnull clickString, NSRange clickRange) {
                !request.clickHandle ?: request.clickHandle();
            }];
        }
        
        if (request.btnTitle.length > 0) {
            UIButton *menusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [menusBtn setTitle:request.btnTitle forState:UIControlStateNormal];
            [menusBtn setTitleColor:request.btnTitleColor forState:UIControlStateNormal];
            menusBtn.titleLabel.font = request.btnTitleFont;
            menusBtn.layer.cornerRadius = request.btnCornerRadius;
            menusBtn.layer.borderWidth = request.btnLineWidth;
            menusBtn.layer.borderColor = request.btnLineColor.CGColor;
            menusBtn.backgroundColor = request.btnBgColor;
            menusBtn.layer.masksToBounds = YES;
            [menusBtn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:menusBtn];
            self.menusBtn = menusBtn;
        }
    }
    return self;
}

/**
 *  添加提示图
 *  @param view   背景图的父视图
 */
- (void)buildFromView:(UIView *)view {
    [view addSubview:self];
}

/**
 *  移除
 */
 - (void)removeFromView:(UIView *)fromView {
     if (fromView) {
         for (UIView *view in fromView.subviews) {
             if ([view isKindOfClass:[self class]]) {
                 [view removeFromSuperview];
             }
         }
         [self removeFromSuperview];
     }
}

#pragma mark: <---------- UI排列 ---------->
/// UI排列
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGSize iconImgSize = self.iconImgView.image.size;
    CGFloat iconImgViewW = iconImgSize.width;
    CGFloat iconImgViewH = iconImgSize.height;
    CGFloat iconImgViewX = (width - iconImgViewW) / 2;
    CGFloat iconImgViewY = (height - iconImgViewH) / 2 - iconImgViewH / 2 - (self.titleLabel ? 40 : 0);
    if (self.request.iconToTopSpan != 0) {
        iconImgViewY = self.request.iconToTopSpan;
    }
    self.iconImgView.frame = CGRectMake(iconImgViewX, iconImgViewY, iconImgViewW, iconImgViewH);
    
    if (self.titleLabel) {
        CGFloat titleLabelX = 60;
        CGFloat titleLabelY = CGRectGetMaxY(self.iconImgView.frame) + self.request.titleToTopUISpan;
        CGFloat titleLabelW = width - 2 * titleLabelX;
        CGFloat titleLabelH = 20;
        self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
    
    CGFloat messageLabelX = 60;
    CGFloat messageLabelY = CGRectGetMaxY(self.titleLabel ? self.titleLabel.frame : self.iconImgView.frame) + self.request.messageToTopUISpan;
    CGFloat messageLabelW = width - 2 * messageLabelX;
    CGFloat messageLabelH = [self.messageLabel.text boundingRectWithSize:CGSizeMake(messageLabelW, 60) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size.height;
    if (messageLabelH < 20) messageLabelH = 20;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
    
    if (_menusBtn) {
        CGFloat menusBtnW = self.request.btnSize.width;
        CGFloat menusBtnX = (width - menusBtnW) / 2;
        CGFloat menusBtnY = CGRectGetMaxY(self.messageLabel.frame) + self.request.btnToTopUISpan;
        CGFloat menusBtnH = self.request.btnSize.height;
        self.menusBtn.frame = CGRectMake(menusBtnX, menusBtnY, menusBtnW, menusBtnH);
    }
}

- (void)refreshClick {
    !self.request.clickHandle ?: self.request.clickHandle();
}

/// 格式化字符串，将字符串传过来，去除nil，null，NULL等情况
- (nullable NSString *)isFormattingString:(nullable NSString *)string {
    
    NSString *newString = [NSString stringWithFormat:@"%@",string];
    
    if ([newString isEqualToString:@"(null)"]) newString = @"";
    if ([newString isEqualToString:@"<null>"]) newString = @"";
    if ([newString isEqualToString:@"(NULL)"]) newString = @"";
    if ([newString isEqualToString:@"<NULL>"]) newString = @"";
    
    return newString;
}

/*
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
 */

@end
