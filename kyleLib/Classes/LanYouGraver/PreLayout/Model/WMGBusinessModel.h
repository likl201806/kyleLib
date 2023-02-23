//
//  WMGBusinessModel.h
//
    

#import <Foundation/Foundation.h>
#import "WMGClientData.h"

NS_ASSUME_NONNULL_BEGIN
/*
 业务数据模型，标识网络返回的标准数据模型基类
 如果业务中已有业务数据模型基类，可直接遵从<WMGClientData>协议即可，不再需要此类
 */
@interface WMGBusinessModel : NSObject<WMGClientData>

@end

NS_ASSUME_NONNULL_END
