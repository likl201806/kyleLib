//
//  CMDCustomSlideView.h
//

#import <UIKit/UIKit.h>

#import "CMDSlideTabbarProtocol.h"
#import "CMDSlideView.h"
#import "CMDTabedSlideView.h"
#import "CMDCacheProtocol.h"

@class CMDCustomSlideView;
@protocol CMDCustomSlideViewDelegate <NSObject>
- (NSInteger)numberOfTabsInCMDCustomSlideView:(CMDCustomSlideView *)sender;
- (UIViewController *)CMDCustomSlideView:(CMDCustomSlideView *)sender controllerAt:(NSInteger)index;
@optional
- (void)CMDCustomSlideView:(CMDCustomSlideView *)sender didSelectedAt:(NSInteger)index;
@end

@interface CMDCustomSlideView : UIView<CMDSlideTabbarDelegate, CMDSlideViewDelegate, CMDSlideViewDataSource>
//{
//    UIViewController *_baseViewController;
//}
@property(nonatomic, weak) UIViewController *baseViewController;
@property(nonatomic, assign) NSInteger selectedIndex;

// tabbar
@property(nonatomic, strong) UIView<CMDSlideTabbarProtocol> *tabbar;
@property(nonatomic, assign) float tabbarBottomSpacing;

// cache properties
@property(nonatomic, strong) id<CMDCacheProtocol> cache;

// delegate
@property(nonatomic, weak)IBOutlet id<CMDCustomSlideViewDelegate>delegate;

// init method. 初始分方法
- (void)setup;

-(void)reloadSlideData;

@end
