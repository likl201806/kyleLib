//
//  CMDSlideTabbarItemArgs.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMDSlideTabbarItemArgs : NSObject

/** 按钮宽度 */
@property (nonatomic, assign) CGFloat itemWidth;

/**  标题数组  */
@property (nonatomic, copy, readonly) NSString *title;
/**  按钮图片数组  */
@property (nonatomic, strong, readonly) UIImage *normalImage;
/**  选中时候的图片  */
@property (nonatomic, strong, readonly) UIImage *selectImage;

/**  按钮普通状态下的标题颜色 默认黑色  */
@property (nonatomic, strong) UIColor *titleNormalColor;
/**  按钮选中状态下的标题颜色 默认红色   */
@property (nonatomic, strong) UIColor *titleSelectColor;

/**  按钮默认的背景颜色 默认clearColor  */
@property (nonatomic, strong) UIColor *normalBgColor;
/**  选中是都的按钮背景颜色 默认clearColor  */
@property (nonatomic, strong) UIColor *selectBgColor;

/**  按钮标题字体大小 默认15号字体  */
@property (nonatomic, strong) UIFont *titleNormalFont;
@property (nonatomic, strong) UIFont *titleSelectFont;

+ (instancetype)argsWithTitle:(NSString *)title
                  normalImage:(UIImage * _Nullable)normalImage
                  selectImage:(UIImage * _Nullable)selectImage;

@end

NS_ASSUME_NONNULL_END
