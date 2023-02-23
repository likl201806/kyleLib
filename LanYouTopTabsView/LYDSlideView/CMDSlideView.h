//
//  CMDSlideView.h
//

#import <UIKit/UIKit.h>

@class CMDSlideView;

@protocol CMDSlideViewDataSource <NSObject>
- (NSInteger)numberOfControllersInCMDSlideView:(CMDSlideView *)sender;
- (UIViewController *)CMDSlideView:(CMDSlideView *)sender controllerAt:(NSInteger)index;
@end

@protocol CMDSlideViewDelegate <NSObject>
@optional
- (void)CMDSlideView:(CMDSlideView *)slide switchingFrom:(NSInteger)oldIndex to:(NSInteger)toIndex percent:(float)percent;
- (void)CMDSlideView:(CMDSlideView *)slide didSwitchTo:(NSInteger)index;
- (void)CMDSlideView:(CMDSlideView *)slide switchCanceled:(NSInteger)oldIndex;
@end

@interface CMDSlideView : UIView
//@property(nonatomic, strong) NSArray *viewControllers;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, weak) UIViewController *baseViewController;
@property(nonatomic, weak) id<CMDSlideViewDelegate>delegate;
@property(nonatomic, weak) id<CMDSlideViewDataSource>dataSource;

/** 是否支持滑动切换 */
@property (nonatomic, assign) BOOL isCanDrawing;
- (void)switchTo:(NSInteger)index;

@end
