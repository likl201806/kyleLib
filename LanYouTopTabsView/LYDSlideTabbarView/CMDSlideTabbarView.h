//
//  CMDSlideTabbarView.h
//

#import <UIKit/UIKit.h>
#import "CMDSlideTabbarItem.h"
#import "CMDSlideTabbarProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMDSlideTabbarView : UIView<CMDSlideTabbarProtocol>

// DLSlideTabbarProtocol => 协议中提供的交互属性
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly) NSInteger tabbarCount;
@property(nonatomic, weak) id <CMDSlideTabbarDelegate> delegate;

/** 在滑动的过程中，是否要关掉渐变过程 */
@property (nonatomic, assign) BOOL isCloseAutoChange;
/**
 height：滑动条的高度
 width：= 0：自适应文字的宽度；= 1：item的宽度；其余值：不为0/1时，就以这个值为准； => 默认(0, 3)
 */
@property (nonatomic, assign) CGSize moveViewSize;
/**左侧边距*/
@property (assign, nonatomic) CGFloat originX;
/**moveView距离底部的间距*/
@property (nonatomic, assign) CGFloat moveViewMarginToBottom;
/** 移动条的颜色 */
@property (nonatomic, strong) UIColor *moveViewColor;
/** 移动条 */
@property (nonatomic, strong) UIImageView *moveView;

- (instancetype)initWithFrame:(CGRect)frame
                        argss:(NSArray <CMDSlideTabbarItemArgs *>*)argss;

-(void)reloadSlideViewData:(NSArray <CMDSlideTabbarItemArgs *>*)argss;

@end

NS_ASSUME_NONNULL_END
