//
//  CMAlert.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IGAlertProtocol <NSObject>

/// 统一样式的弹窗 一个按钮
- (void)alertWithTitle:(NSString *)title
               content:(NSString *)content
           actionTitle:(NSString *)actionTitle
           actionBlock:(void (^_Nullable)(void))actionBlock;
     

/// 统一样式的弹窗 两个按钮
- (void)alertWithTitle:(NSString *)title
               content:(NSString *)content
       leftActionTitle:(NSString *)leftActionTitle
      rightActionTitle:(NSString *)rightActionTitle
           actionBlock:(void (^_Nullable)(NSInteger index))actionBlock;

@end

NS_ASSUME_NONNULL_END
