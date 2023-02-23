//
//  CMDSlideTabbarItem.h
//

#import <UIKit/UIKit.h>
#import "CMDSlideTabbarItemArgs.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMDSlideTabbarItem : UIView

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 图标*/
@property (nonatomic, strong) UIImageView *iconV;

/** 参数与 */
@property (nonatomic, strong) CMDSlideTabbarItemArgs *args;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)itemWithArgs:(CMDSlideTabbarItemArgs *)args;

@end

NS_ASSUME_NONNULL_END
