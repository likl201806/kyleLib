//
//  CMDScrollTabbarView.h
//

#import <UIKit/UIKit.h>
#import "CMDSlideTabbarProtocol.h"

@interface CMDScrollTabbarItem : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) CGFloat width;
+ (CMDScrollTabbarItem *)itemWithTitle:(NSString *)title width:(CGFloat)width;
@end

@interface CMDScrollTabbarView : UIView<CMDSlideTabbarProtocol>
@property(nonatomic, strong) UIView *backgroundView;

// tabbar属性
@property (nonatomic, strong) UIColor *tabItemNormalColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *tabItemSelectedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat tabItemNormalFontSize;
@property(nonatomic, strong) UIColor *trackColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) NSArray *tabbarItems;

// CMDSlideTabbarProtocol
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly) NSInteger tabbarCount;
@property(nonatomic, weak) id<CMDSlideTabbarDelegate> delegate;
- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;

@end
