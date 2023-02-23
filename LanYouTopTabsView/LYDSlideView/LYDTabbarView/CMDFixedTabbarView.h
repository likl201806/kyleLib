//
//  CMDFixedTabbarView.h
//

#import <UIKit/UIKit.h>
#import "CMDSlideTabbarProtocol.h"

@interface CMDFixedTabbarViewTabItem : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *selectedTitleColor;
@end

@interface CMDFixedTabbarView : UIView<CMDSlideTabbarProtocol>
@property(nonatomic, strong) UIImage *backgroundImage;
@property(nonatomic, strong) UIColor *trackColor;
@property(nonatomic, strong) NSArray *tabbarItems;
//- (void)addBarItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly) NSInteger tabbarCount;
@property(nonatomic, weak) id<CMDSlideTabbarDelegate> delegate;
- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;

@end
