//
//  CMDTabedSlideView.h
//

#import <UIKit/UIKit.h>
#import "CMDSlideTabbarProtocol.h"

@interface CMDTabedbarItem : NSObject
@property (nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;

+ (CMDTabedbarItem *)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
@end

@class CMDTabedSlideView;

@protocol CMDTabedSlideViewDelegate <NSObject>
- (NSInteger)numberOfTabsInCMDTabedSlideView:(CMDTabedSlideView *)sender;
- (UIViewController *)CMDTabedSlideView:(CMDTabedSlideView *)sender controllerAt:(NSInteger)index;
@optional
- (void)CMDTabedSlideView:(CMDTabedSlideView *)sender didSelectedAt:(NSInteger)index;
- (void)CMDTabedSlideView:(CMDTabedSlideView *)sender movingWithProgress:(CGFloat)progress isToLeft:(BOOL)isToLeft;
@end

@interface CMDTabedSlideView : UIView<CMDSlideTabbarDelegate>
//@property(nonatomic, strong) NSArray *viewControllers;
@property(nonatomic, weak) UIViewController *baseViewController;
@property(nonatomic, assign) NSInteger selectedIndex;


//set tabbar properties.
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property(nonatomic, strong) UIImage *tabbarBackgroundImage;
@property(nonatomic, strong) UIColor *tabbarTrackColor;
@property(nonatomic, strong) NSArray *tabbarItems;
@property(nonatomic, assign) float tabbarHeight;
@property(nonatomic, assign) float tabbarBottomSpacing;

/** 是否支持滑动切换 */
@property (nonatomic, assign) BOOL isCanDrawing;

// cache properties
@property(nonatomic, assign) NSInteger cacheCount;

- (void)buildTabbar;

//@property(nonatomic, strong) IBOutlet id<CMDSlideTabbarProtocol> tabarView;

@property(nonatomic, weak)IBOutlet id<CMDTabedSlideViewDelegate>delegate;


-(void)reloadTabbarData;

@end
