//
//  CMQRCodePreviewView.h
//

#import <UIKit/UIKit.h>
#import "BSCMainCameraMutableCodeView.h"

NS_ASSUME_NONNULL_BEGIN

@class CMQRCodePreviewView;
@protocol CMQRCodePreviewViewDelegate <NSObject>

- (void)codeScanningView:(CMQRCodePreviewView *)scanningView didClickedTorchSwitch:(UIButton *)switchButton;

@end

@interface CMQRCodePreviewView : UIView

@property (nonatomic, assign, readonly) CGRect rectFrame;
@property (nonatomic, weak) id<CMQRCodePreviewViewDelegate> delegate;

/**多二维码相关*/
//多二维码绿点装载view
@property (nonatomic, strong) BSCMainCameraMutableCodeView *mutableCodeView;

- (instancetype)initWithFrame:(CGRect)frame rectFrame:(CGRect)rectFrame lineFrame:(CGRect)lineFrame cornerColor:(UIColor *)cornerColor lineColor:(UIColor *)lineColor;

//开始扫描
- (void)startScanning;
//停止扫描
- (void)stopScanning;
//开始展示loading（菊花）
- (void)startIndicating;
//停止展示loading（菊花）
- (void)stopIndicating;
//显示电筒
- (void)showTorchSwitch;
//隐藏电筒
- (void)hideTorchSwitch;

@end

NS_ASSUME_NONNULL_END
