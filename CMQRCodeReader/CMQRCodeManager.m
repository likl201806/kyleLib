//
//  CMQRCodeManager.m
//

#import "CMQRCodeManager.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>
#import "CMQRCodeButton.h"
#import "CMQRMutableCodeModel.h"
//手机震动
#import <AudioToolbox/AudioToolbox.h>

static NSString *QiInputCorrectionLevelL = @"L";//!< L: 7%
static NSString *QiInputCorrectionLevelM = @"M";//!< M: 15%
static NSString *QiInputCorrectionLevelQ = @"Q";//!< Q: 25%
static NSString *QiInputCorrectionLevelH = @"H";//!< H: 30%

@interface CMQRCodeManager () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, CMQRCodePreviewViewDelegate>

//相机生命
@property (nonatomic, strong) AVCaptureSession *session;
//相机内容预览view
@property (nonatomic, strong) CMQRCodePreviewView *previewView;
//相机内容预览layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
//灯光观察
@property (nonatomic, copy) void(^lightObserver)(BOOL, BOOL);
//二维码回调
@property (nonatomic, copy) void(^callback)(NSString *);
//电筒开关
@property (nonatomic, assign) BOOL lightObserverHasCalled;
//自动停止扫描
@property (nonatomic, assign) BOOL autoStop;
//多个二维码数据
@property (nonatomic, strong) NSMutableArray<CMQRCodeModel *> *qrModels;
//识别多个二维码的辅助模型
@property (nonatomic, strong) CMQRMutableCodeModel *mutableModel;

@end

@implementation CMQRCodeManager

#pragma mark - 扫描二维码/条形码

- (instancetype)initWithPreviewView:(CMQRCodePreviewView *)previewView completion:(nonnull void (^)(void))completion {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartCodeScan:) name:kgdpogaNotification object:nil];
        if ([previewView isKindOfClass:[CMQRCodePreviewView class]]) {
            _previewView = (CMQRCodePreviewView *)previewView;
            _previewView.delegate = self;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        // 在全局队列开启新线程，异步初始化AVCaptureSession（比较耗时）
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
            self.session = [[AVCaptureSession alloc] init];
            //高分辨率才能识别多个二维码
            self.session.sessionPreset = AVCaptureSessionPreset3840x2160;
            if ([self.session canAddInput:input]) {
                [self.session addInput:input];
            }
            if ([self.session canAddOutput:output]) {
                [self.session addOutput:output];
                if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode] &&
                    [output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code] &&
                    [output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code] && [output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
                    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code];
                }
            }

            [device lockForConfiguration:nil];
            if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            [device unlockForConfiguration];
            
            // 回主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
                [[previewLayer connection]  setVideoOrientation:AVCaptureVideoOrientationPortrait];
                previewLayer.frame = previewView.layer.bounds;
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                [previewView.layer insertSublayer:previewLayer atIndex:0];
                self.previewLayer = previewLayer;
                
                // 设置扫码区域
                CGRect rectFrame = self.previewView.rectFrame;
                if (!CGRectEqualToRect(rectFrame, CGRectZero)) {
                    CGFloat y = rectFrame.origin.y / previewView.bounds.size.height;
                    CGFloat x = (previewView.bounds.size.width - rectFrame.origin.x - rectFrame.size.width) / previewView.bounds.size.width;
                    CGFloat h = rectFrame.size.height / previewView.bounds.size.height;
                    CGFloat w = rectFrame.size.width / previewView.bounds.size.width;
                    output.rectOfInterest = CGRectMake(y, x, h, w);
                }
                
                // 缩放手势
                UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
                [previewView addGestureRecognizer:pinchGesture];
                
                // 停止previewView上转动的指示器
                [self.previewView stopIndicating];
                
                if (completion) {
                    completion();
                }
            });
        });
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Public functions
- (void)startScanningWithCallback:(void (^)(NSString * _Nonnull))callback {
    [self startScanningWithCallback:callback autoStop:NO];
}

- (void)startScanningWithCallback:(void (^)(NSString * _Nonnull))callback autoStop:(BOOL)autoStop {
    _callback = callback;
    _autoStop = autoStop;
    [self startScanning];
}

- (void)startScanning {
    __weak typeof(self) weakSelf = self;
    
    if (_session && !_session.isRunning) {
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(global, ^{
            [weakSelf.session startRunning];
        });
        [_previewView startScanning];
    }
    
    [self observeLightStatus:^(BOOL dimmed, BOOL torchOn) {
        if (dimmed || torchOn) {
            [weakSelf.previewView stopScanning];
            [weakSelf.previewView showTorchSwitch];
        } else {
            [weakSelf.previewView startScanning];
            [weakSelf.previewView hideTorchSwitch];
        }
    }];
}

- (void)stopScanning {
    if (_session && _session.isRunning) {
        [_session stopRunning];
        [_previewView stopScanning];
    }
    [CMQRCodeManager switchTorch:NO];
    [CMQRCodeManager resetZoomFactor];
}

- (void)presentPhotoLibraryWithRooter:(UIViewController *)rooter callback:(nonnull void (^)(NSString * _Nonnull))callback {
    _callback = callback;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePicker.delegate = self;
    [rooter presentViewController:imagePicker animated:YES completion:nil];
}

- (void)handleCodeString:(NSString *)codeString {
    if (_autoStop) {
        [self stopScanning];
    }
    if (_callback) {
        _callback(codeString);
    }
}

//重新扫描
-(void)restartScan{
    /**
     原来的情况停止扫描即可
     [self stopScanning];
     */
    //之所以增加其他操作，是因为要解决已经出现多点扫描结果的情况下，回到后台再返回前台会有问题
    [[NSNotificationCenter defaultCenter] postNotificationName:ksdgjageporgNotification object:nil userInfo:@{kCamsadaelsdf:@(NO)}];
    [self backFromMutableCode];
}

//删除多二维码绿点并重新扫描
-(void)backFromMutableCode{
    //恢复transform
    [UIView animateWithDuration:0.3 animations:^{
        self.previewView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    }];
    //删除绿点
    if (self.previewView.mutableCodeView.subviews.count > 0){
        for (UIView *subView in self.previewView.mutableCodeView.subviews) {
            if ([subView isKindOfClass:[CMQRCodeButton class]]){
                [subView removeFromSuperview];
            }
        }
    }
    //重新开始扫描
    [self startScanning];
}

#pragma mark - Private functions
+ (void)resetZoomFactor {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    device.videoZoomFactor = 1.0;
    [device unlockForConfiguration];
}

#pragma mark - Private - 生成二维码
//根据模型生成二维码
+ (UIImage *)generateQRCodeWithModel:(WEDRResultModel *)model{
    UIImage *codeImage = nil;
    
    CGFloat screenScale = [UIScreen mainScreen].scale;
    NSData *codeData = [model.codeString dataUsingEncoding:NSUTF8StringEncoding];
    // 1.创建二维码过滤器
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.设置默认值
    [qrFilter setDefaults];
    /*
     inputMessage,         二维码的内容
     inputCorrectionLevel  二维码的容错率
     */
    // 3.给二维码过滤器添加信息  KVC
    // inputMessage必须要传入二进制   否则会崩溃
    [qrFilter setValue:codeData forKey:@"inputMessage"];
    // 4.获取二维码的图片
    CIImage *ciimage = qrFilter.outputImage;
    // 获取二维码实际大小
    model.codeMinWH = ciimage.extent.size.width;
    // 放大图片的比例
    CGFloat sideScale = fminf(model.codeWH / ciimage.extent.size.width, model.codeWH / ciimage.extent.size.height) * screenScale;// 计算需要缩放的比例
    ciimage = [ciimage imageByApplyingTransform:CGAffineTransformMakeScale(sideScale, sideScale)];
    // 5.创建颜色过滤器
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    // 6.设置默认值
    [colorFilter setDefaults];
    /*
     inputImage,     需要设定颜色的图片
     inputColor0,    前景色 - 二维码的颜色
     inputColor1     背景色 - 二维码背景的颜色
     */
    // 7.给颜色过滤器添加信息
    // 设定图片
    [colorFilter setValue:ciimage forKey:@"inputImage"];
    // 设定前景色
    [colorFilter setValue:[CIColor colorWithCGColor:[model codeColor].CGColor] forKey:@"inputColor0"];
    // 设定背景色
    [colorFilter setValue:[CIColor colorWithCGColor:[model codeBGColor].CGColor] forKey:@"inputColor1"];
    // 获取图片
    ciimage = colorFilter.outputImage;
    
    codeImage = [UIImage imageWithCIImage:ciimage];
    
    return codeImage;
}

#pragma mark - Private - 打开/关闭手电筒
- (void)observeLightStatus:(void (^)(BOOL, BOOL))lightObserver {
    _lightObserver = lightObserver;
    
    AVCaptureVideoDataOutput *lightOutput = [[AVCaptureVideoDataOutput alloc] init];
    [lightOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    if ([_session canAddOutput:lightOutput]) {
        [_session addOutput:lightOutput];
    }
}

+ (void)switchTorch:(BOOL)on {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureTorchMode torchMode = on? AVCaptureTorchModeOn: AVCaptureTorchModeOff;
    
    if (device.hasFlash && device.hasTorch && torchMode != device.torchMode) {
        [device lockForConfiguration:nil];
        [device setTorchMode:torchMode];
        [device unlockForConfiguration];
    }
}

#pragma mark - Private - 缩放手势
- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    CGFloat minZoomFactor = 1.0;
    CGFloat maxZoomFactor = device.activeFormat.videoMaxZoomFactor;
    
    if (@available(iOS 11.0, *)) {
        minZoomFactor = device.minAvailableVideoZoomFactor;
        maxZoomFactor = device.maxAvailableVideoZoomFactor;
    }
    
    static CGFloat lastZoomFactor = 1.0;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastZoomFactor = device.videoZoomFactor;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat zoomFactor = lastZoomFactor * gesture.scale;
        zoomFactor = fmaxf(fminf(zoomFactor, maxZoomFactor), minZoomFactor);
        [device lockForConfiguration:nil];
        device.videoZoomFactor = zoomFactor;
        [device unlockForConfiguration];
    }
}

/**自定义心跳动画*/
-(void)heartAnimationWith:(UIView *)view{
    //动画1
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"transform.scale";
    animation1.toValue = @0.7;
    animation1.repeatCount = 2;
    animation1.duration = 0.3;
    animation1.autoreverses = YES;
    //组合动画
    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = 3.0f;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.removedOnCompletion = NO;
    animaGroup.repeatCount = MAXFLOAT;
    animaGroup.animations = @[animation1];
    //动画赋予view
    [view.layer addAnimation:animaGroup forKey:@"Animation"];
}

#pragma mark - Notification functions
- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [self startScanning];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self restartScan];
}

-(void)restartCodeScan:(NSNotification *)noti{
    [self restartScan];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    __weak typeof(self) weakSelf = self;
    if (metadataObjects.count > 1){
        NSMutableArray *models = [NSMutableArray array];
        for (int i=0; i<metadataObjects.count; i++) {
            AVMetadataMachineReadableCodeObject *code = [metadataObjects igObjectAtIndex:i];
            CGRect codeRect = code.bounds;
            //获取绿点在摄像头设备中的坐标
            CGPoint deviceCodeCenter = CGPointMake(codeRect.origin.x+0.5*codeRect.size.width, codeRect.origin.y+0.5*codeRect.size.height);
            //将绿点摄像头设备中的坐标转化成屏幕坐标
            CGPoint screenCodeCenter = [_previewLayer pointForCaptureDevicePointOfInterest:deviceCodeCenter];
            CGRect screenCodeRect = [_previewLayer rectForMetadataOutputRectOfInterest:codeRect];
            CMQRCodeModel *codeModel = [[CMQRCodeModel alloc] init];
            codeModel.bounds = screenCodeRect;
            codeModel.center = screenCodeCenter;
            codeModel.qrCode = code.stringValue;
            [models addObject:codeModel];
        }
        [self.mutableModel updateScanDataWithCodeCount:metadataObjects.count magnify:^{
            
        } completed:^{
            [weakSelf stopScanning];
            [weakSelf showMutableCodeButtons:models];
            /**
             拉近动画--取消
             [weakSelf magnifyTransformWithModels:models];
             */
        }];
    }else{
        if (metadataObjects.count != 0){
            AVMetadataMachineReadableCodeObject *code = metadataObjects.firstObject;
            if (code.stringValue) {
                [self.mutableModel updateScanDataWithCodeCount:1 magnify:^{
                    
                } completed:^{
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [weakSelf handleCodeString:code.stringValue];
                }];
            }
        }
    }
}

-(void)magnifyTransformWithModels:(NSMutableArray<CMQRCodeModel *> *)models{
    //放大属性
    CGFloat magnifyScale = 1;
    CGFloat margin = 50;
    CGFloat minX = IGScreenW;
    CGFloat maxX = 0;
    CGFloat minY = IGScreenH;
    CGFloat maxY = 0;
    //平移属性
    CGPoint centerP = CGPointMake(0.5*IGScreenW, 0.5*IGScreenH);
    CGFloat moveX = 0;
    CGFloat moveY = 0;
    //尺寸属性
    CGFloat magnifyWidth = IGScreenW;
    CGFloat magnifyHeight = IGScreenH;
    //计算放大比例与平移量
    if (models.count > 0){
        //计算四极
        for (CMQRCodeModel *model in models) {
            CGFloat modelOriginX = model.bounds.origin.x;
            CGFloat modelOriginY = model.bounds.origin.y;
            CGFloat modelWidth = model.bounds.size.width;
            CGFloat modelHeight = model.bounds.size.height;
            if (modelOriginX < minX){
                minX = modelOriginX;
            }
            if (modelOriginX+modelWidth > maxX){
                maxX = modelOriginX+modelWidth;
            }
            if (modelOriginY < minY){
                minY = modelOriginY;
            }
            if (modelOriginY+modelHeight > maxY){
                maxY = modelOriginY+modelHeight;
            }
        }
        //增加边界
        minX -= margin;
        maxX += margin;
        minY -= margin;
        maxY += margin;
        //如果四个极点中任何一个超过屏幕，则不做transform
        if (minX < 0){
            return;
        }
        if (maxX > IGScreenW){
            return;
        }
        if (minY < 0){
            return;
        }
        if (maxY > IGScreenH){
            return;
        }
        //计算放大后范围尺寸
        magnifyWidth = maxX-minX;
        magnifyHeight = maxY-minY;
        //计算放大比例
        CGFloat scaleX = IGScreenW/magnifyWidth;
        CGFloat scaleY = IGScreenH/magnifyHeight;
        magnifyScale = MIN(scaleX, scaleY);
        //计算中心点
        centerP = CGPointMake(0.5*(minX+maxX), 0.5*(minY+maxY));
        moveX = 0.5*IGScreenW-centerP.x;
        moveY = 0.5*IGScreenH-centerP.y;
        //避免放大化框选超过边缘
        if (moveX > 0){ //结果在平面中心左侧
            if (moveX+0.5*magnifyWidth+margin > 0.5*IGScreenW){
                moveX = 0.5*IGScreenW-0.5*magnifyWidth-margin;
            }
        }else{  //结果在平面中心右侧
            if (-moveX+0.5*magnifyWidth+margin > 0.5*IGScreenW){
                moveX = -(0.5*IGScreenW-0.5*magnifyWidth-margin);
            }
        }
        if (moveY > 0){
            if (moveY+0.5*magnifyHeight+margin > 0.5*IGScreenH){
                moveY = 0.5*IGScreenH-0.5*magnifyHeight-margin;
            }
        }else{
            if (-moveY+0.5*magnifyHeight+margin > 0.5*IGScreenH){
                moveY = -(0.5*IGScreenH-0.5*magnifyHeight-margin);
            }
        }
        
        /**preview transform*/
        CGAffineTransform pvtransform = self.previewView.transform;
        //设置平移
        CGAffineTransform pvmoveTransform = CGAffineTransformTranslate(pvtransform, moveX, moveY);
        //设置缩放
        CGAffineTransform pvscaleTransform = CGAffineTransformScale(pvmoveTransform, magnifyScale, magnifyScale);
        //将transform赋值给layer
        [UIView animateWithDuration:0.3 animations:^{
            self.previewView.transform = pvscaleTransform;
        }];
    }
}

-(void)showMutableCodeButtons:(NSMutableArray<CMQRCodeModel *> *)models{
    //显示多二维码背景view
    [[NSNotificationCenter defaultCenter] postNotificationName:ksdgjageporgNotification object:nil userInfo:@{kCamsadaelsdf:@(YES)}];
    //删除绿点
    if (self.previewView.mutableCodeView.subviews.count > 0){
        for (UIView *subView in self.previewView.mutableCodeView.subviews) {
            if ([subView isKindOfClass:[CMQRCodeButton class]]){
                [subView removeFromSuperview];
            }
        }
    }
    //增加新绿点
    if (models.count > 0){
        CGAffineTransform transform = self.previewView.transform;
        CGFloat transformScale = transform.a;
        CGFloat originMoveX = 0.5*(transformScale-1)*IGScreenW;
        CGFloat originMoveY = 0.5*(transformScale-1)*IGScreenH;
        self.qrModels = models;
        for (int i=0; i<models.count; i++) {
            CMQRCodeModel *qrModel = [models igObjectAtIndex:i];
            //计算放大后的绿点中心点位置
            CGPoint btnCenter = CGPointApplyAffineTransform(qrModel.center, transform);
            CGPoint btnScreenCenter = CGPointMake(btnCenter.x-originMoveX, btnCenter.y-originMoveY);
            //增加绿点
            CMQRCodeButton *btn = [[CMQRCodeButton alloc] initWithFrame:CGRectMake(btnScreenCenter.x-15, btnScreenCenter.y-15, 30, 30)];
            btn.layer.cornerRadius = 15;
            [btn setImage:[UIImage imageNamed:@"adsv_result_mutable_btn_icon"] forState:(UIControlStateNormal)];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(openMutableCodeWithButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.previewView.mutableCodeView addSubview:btn];
            //心跳动画
            [self heartAnimationWith:btn];
        }
    }
}

-(void)openMutableCodeWithButton:(UIButton *)btn{
    //隐藏多二维码背景view
    [[NSNotificationCenter defaultCenter] postNotificationName:ksdgjageporgNotification object:nil userInfo:@{kCamsadaelsdf:@(NO)}];
    //删除绿点
    if (self.previewView.mutableCodeView.subviews.count > 0){
        for (UIView *subView in self.previewView.mutableCodeView.subviews) {
            if ([subView isKindOfClass:[CMQRCodeButton class]]){
                [subView removeFromSuperview];
            }
        }
    }
    //点击跳转
    NSInteger index = btn.tag-100;
    if (self.qrModels.count > index){
        CMQRCodeModel *qrModel = [self.qrModels igObjectAtIndex:index];
        [self handleCodeString:qrModel.qrCode];
    }
    //恢复transform
    self.previewView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
}

#pragma mark - CMQRCodePreviewViewDelegate
- (void)codeScanningView:(CMQRCodePreviewView *)scanningView didClickedTorchSwitch:(UIButton *)switchButton {
    switchButton.selected = !switchButton.selected;
    
    [CMQRCodeManager switchTorch:switchButton.selected];
    _lightObserverHasCalled = switchButton.selected;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    CIImage *detectImage = [CIImage imageWithData:UIImagePNGRepresentation(pickedImage)];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    CIQRCodeFeature *feature = (CIQRCodeFeature *)[detector featuresInImage:detectImage options:nil].firstObject;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (feature.messageString) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self handleCodeString:feature.messageString];
        }
    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDicRef = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadataDic = (__bridge NSDictionary *)metadataDicRef;
    NSDictionary *exifDic = metadataDic[(__bridge NSString *)kCGImagePropertyExifDictionary];
    CFRelease(metadataDicRef);
    
    CGFloat brightness = [exifDic[(__bridge NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL torchOn = device.torchMode == AVCaptureTorchModeOn;
    BOOL dimmed = brightness < 1.0;
    static BOOL lastDimmed = NO;
    
    if (_lightObserver) {
        if (!_lightObserverHasCalled) {
            _lightObserver(dimmed, torchOn);
            _lightObserverHasCalled = YES;
            lastDimmed = dimmed;
        }
        else if (dimmed != lastDimmed) {
            _lightObserver(dimmed, torchOn);
            lastDimmed = dimmed;
        }
    }
}

#pragma mark - lazy
-(CMQRMutableCodeModel *)mutableModel{
    if (_mutableModel == nil){
        _mutableModel = [[CMQRMutableCodeModel alloc] init];
    }
    return _mutableModel;
}

@end
