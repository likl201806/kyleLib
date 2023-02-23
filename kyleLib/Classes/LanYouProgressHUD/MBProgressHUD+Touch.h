//
//  MBProgressHUD+Touch.h
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/9/23.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Touch)

/// 可点击范围区域
@property (assign, nonatomic) CGRect ly_enableThroughRect;

@end

NS_ASSUME_NONNULL_END
