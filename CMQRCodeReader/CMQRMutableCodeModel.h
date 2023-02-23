//
//  CMQRMutableCodeModel.h
//  CamQRScanner
//
//   on 2022/8/1.
//  识别多点的辅助模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMQRMutableCodeModel : NSObject

/**
 更新扫描次数与个数
 @param codeCount 当前扫描结果二维码/条形码个数
 */
-(void)updateScanDataWithCodeCount:(NSInteger)codeCount magnify:(void(^)(void))magnify completed:(void(^)(void))completed;

/**
 清空扫描数据
 */
-(void)clearScanData;

@end

NS_ASSUME_NONNULL_END
