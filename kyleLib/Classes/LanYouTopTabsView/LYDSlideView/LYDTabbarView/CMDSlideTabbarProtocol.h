//
//  CMDSlideTabbarProtocol.h
//

#import <Foundation/Foundation.h>

@protocol CMDSlideTabbarDelegate <NSObject>
- (void)CMDSlideTabbar:(id)sender selectAt:(NSInteger)index;
@end

@protocol CMDSlideTabbarProtocol <NSObject>

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly) NSInteger tabbarCount;
@property(nonatomic, weak) id<CMDSlideTabbarDelegate> delegate;
- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;

@end
