//
//  CMQRCodeModel.h
//  CamQRScanner
//
//   on 2022/6/18.
//

#import "DBRBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMQRCodeModel : DBRBBaseModel

//二维码code
@property (nonatomic, copy) NSString *qrCode;
//code的frame值
@property (nonatomic, assign) CGRect bounds;
//中心点位置
@property (nonatomic, assign) CGPoint center;

@end

NS_ASSUME_NONNULL_END
