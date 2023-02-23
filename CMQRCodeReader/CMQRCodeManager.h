//
//  CMQRCodeManager.h
//

#import <UIKit/UIKit.h>
#import "CMQRCodePreviewView.h"
#import "CMQRCodeModel.h"
#import "WEDRResultModel.h"
/**view*/
#import "BSCMainCameraMutableCodeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMQRCodeManager : NSObject

#pragma mark - 扫描二维码/条形码
- (instancetype)initWithPreviewView:(CMQRCodePreviewView *)previewView completion:(void(^)(void))completion;

//开始扫描，自动停止
- (void)startScanningWithCallback:(void(^)(NSString *))callback autoStop:(BOOL)autoStop;
//开始扫描，手动停止
- (void)startScanningWithCallback:(void(^)(NSString *))callback;
//停止扫描
- (void)stopScanning;
//跳转相册
- (void)presentPhotoLibraryWithRooter:(UIViewController *)rooter callback:(void(^)(NSString *))callback;

#pragma mark - 生成二维码
//根据模型生成二维码
+ (UIImage *)generateQRCodeWithModel:(WEDRResultModel *)model;

//从多二维码背景view返回扫描view
-(void)backFromMutableCode;

@end

NS_ASSUME_NONNULL_END
