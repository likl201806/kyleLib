//
//  CMQRCodePreviewView.m
//

#import "CMQRCodePreviewView.h"

@interface CMQRCodePreviewView ()

//扫码框layer
@property (nonatomic, strong) CAShapeLayer *rectLayer;
//扫码框四个拐角layer
@property (nonatomic, strong) CAShapeLayer *cornerLayer;
//扫描线
@property (nonatomic, strong) CAShapeLayer *lineLayer;
//扫描组合动画
@property (nonatomic, strong) CAAnimationGroup *lineAnimationGroup;
//loading（菊花）
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
//电筒
@property (nonatomic, strong) UIButton *torchSwithButton;
//提示label
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation CMQRCodePreviewView

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [[CMQRCodePreviewView alloc] initWithFrame:frame rectFrame:CGRectZero lineFrame:CGRectZero cornerColor:[UIColor whiteColor] lineColor:[UIColor clearColor]];
}

- (instancetype)initWithFrame:(CGRect)frame rectFrame:(CGRect)rectFrame lineFrame:(CGRect)lineFrame cornerColor:(UIColor *)cornerColor lineColor:(UIColor *)lineColor{
    self = [super initWithFrame:frame];
    
    if (self) {
        if (CGRectEqualToRect(rectFrame, CGRectZero)) {
            CGFloat rectSide = fminf(self.layer.bounds.size.width, self.layer.bounds.size.height) * 2 / 3;
            rectFrame = CGRectMake((self.layer.bounds.size.width - rectSide) / 2, (self.layer.bounds.size.height - rectSide) / 2, rectSide, rectSide);
        }
        if (CGRectEqualToRect(lineFrame, CGRectZero)) {
            CGFloat lineRectSide = fminf(self.layer.bounds.size.width, self.layer.bounds.size.height) * 2 / 3;
            lineFrame = CGRectMake((self.layer.bounds.size.width - lineRectSide) / 2, (self.layer.bounds.size.height - lineRectSide) / 2, lineRectSide, lineRectSide);
        }
        if (CGColorEqualToColor(lineColor.CGColor, [UIColor clearColor].CGColor)) {
            lineColor = [UIColor whiteColor];
        }
        
        // 根据自定义的rectFrame画矩形框（扫码框）
        [self.layer masksToBounds];
        [self clipsToBounds];
        
        CGFloat lineWidth = 0.5;
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:(CGRect){lineWidth / 2, lineWidth / 2, rectFrame.size.width - lineWidth, rectFrame.size.height - lineWidth}];
        _rectLayer = [CAShapeLayer layer];
        _rectLayer.fillColor = [UIColor clearColor].CGColor;
        _rectLayer.strokeColor = cornerColor.CGColor;
        _rectLayer.path = rectPath.CGPath;
        _rectLayer.lineWidth = lineWidth;
        _rectLayer.frame = rectFrame;
        [self.layer addSublayer:_rectLayer];
        
        // 根据rectFrame创建矩形拐角路径
        CGFloat cornerWidth = 2.0;
        CGFloat cornerLength = fminf(rectFrame.size.width, rectFrame.size.height) / 12;
        UIBezierPath *cornerPath = [UIBezierPath bezierPath];
        // 左上角
        [cornerPath moveToPoint:(CGPoint){cornerWidth / 2, .0}];
        [cornerPath addLineToPoint:(CGPoint){cornerWidth / 2, cornerLength}];
        [cornerPath moveToPoint:(CGPoint){.0, cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){cornerLength, cornerWidth / 2}];
        // 右上角
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width, cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerLength, cornerWidth / 2}];
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, .0}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, cornerLength}];
        // 右下角
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, rectFrame.size.height}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, rectFrame.size.height - cornerLength}];
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width, rectFrame.size.height - cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerLength, rectFrame.size.height - cornerWidth / 2}];
        // 左下角
        [cornerPath moveToPoint:(CGPoint){.0, rectFrame.size.height - cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){cornerLength, rectFrame.size.height - cornerWidth / 2}];
        [cornerPath moveToPoint:(CGPoint){cornerWidth / 2, rectFrame.size.height}];
        [cornerPath addLineToPoint:(CGPoint){cornerWidth / 2, rectFrame.size.height - cornerLength}];
        
        // 根据矩形拐角路径画矩形拐角
        _cornerLayer = [CAShapeLayer layer];
        _cornerLayer.frame = rectFrame;
        _cornerLayer.path = cornerPath.CGPath;
        _cornerLayer.lineWidth = cornerPath.lineWidth;
        _cornerLayer.strokeColor = cornerColor.CGColor;
        [self.layer addSublayer:_cornerLayer];
        
        // 遮罩+镂空
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
        /**bezierPathByReversingPath
         通过该方法反转一条路径, 并不会修改该路径的样子，它仅仅是修改了绘制的方向。
         return: 返回一个新的 UIBezierPath 对象, 形状和原来路径的形状一样，但是绘制的方向相反.
         */
        UIBezierPath *subPath = [[UIBezierPath bezierPathWithRect:rectFrame] bezierPathByReversingPath];
        [maskPath appendPath:subPath];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor colorWithWhite:.0 alpha:.6].CGColor;
        maskLayer.path = maskPath.CGPath;
        [self.layer addSublayer:maskLayer];
        
        // 根据rectFrame画扫描线
        CGRect theLineFrame = (CGRect){lineFrame.origin.x, lineFrame.origin.y, lineFrame.size.width, 51};
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.frame = theLineFrame;
        _lineLayer.contents = (id)[UIImage imageNamed:@"fdgj_owe_image"].CGImage;
        _lineLayer.hidden = YES;
        [self.layer addSublayer:_lineLayer];
        
        // 扫描线组合动画
        _lineAnimationGroup = [CAAnimationGroup animation];
        _lineAnimationGroup.repeatCount = CGFLOAT_MAX;
        _lineAnimationGroup.autoreverses = NO;
        _lineAnimationGroup.duration = 2.0;
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
        animation1.fromValue = [NSValue valueWithCGPoint:(CGPoint){_lineLayer.frame.origin.x + _lineLayer.frame.size.width / 2, lineFrame.origin.y + _lineLayer.frame.size.height}];
        animation1.toValue = [NSValue valueWithCGPoint:(CGPoint){_lineLayer.frame.origin.x + _lineLayer.frame.size.width / 2, lineFrame.origin.y + lineFrame.size.height - _lineLayer.frame.size.height}];
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation2.fromValue = @(1.0);
        animation2.toValue = @(0.0);
        animation2.beginTime = 1.0;
        [_lineAnimationGroup setAnimations:[NSArray arrayWithObjects:animation1, animation2, nil]];
        
        // 手电筒开关
        _torchSwithButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _torchSwithButton.frame = CGRectMake(0.5*(IGScreenW-26), IGScreenH-IGSafetyH-189.5-39.5, 26, 39.5);
        _torchSwithButton.center = CGPointMake(CGRectGetMidX(rectFrame), CGRectGetMaxY(rectFrame) - CGRectGetMidY(_torchSwithButton.bounds));
        _torchSwithButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_torchSwithButton setImage:[UIImage imageNamed:@"sdosdf_sdijl_sdfoi_icon"] forState:(UIControlStateNormal)];
        [_torchSwithButton setImage:[UIImage imageNamed:@"dfwiue_sgksdf_wejk_icon"] forState:(UIControlStateSelected)];
        [_torchSwithButton addTarget:self action:@selector(torchSwitchClicked:) forControlEvents:UIControlEventTouchUpInside];
        _torchSwithButton.tintColor = lineColor;
        [self addSubview:_torchSwithButton];
        
        // 提示语label
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:13.0];
        _tipsLabel.text = @"将二维码/条形码放入框内即可自动扫描";
        _tipsLabel.numberOfLines = 0;
        [_tipsLabel sizeToFit];
        _tipsLabel.center = CGPointMake(CGRectGetMidX(rectFrame), CGRectGetMaxY(rectFrame) + CGRectGetMidY(_tipsLabel.bounds)+ 12.0);
        [self addSubview:_tipsLabel];
        
        // 等待指示view
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:rectFrame];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
        
        /**多二维码相关*/
        [self addSubview:self.mutableCodeView];  //多二维码绿点装载view
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _torchSwithButton.frame = CGRectMake(0.5*(IGScreenW-26), IGScreenH-IGSafetyH-189.5-39.5, 26, 39.5);
    _mutableCodeView.frame = self.bounds;
}

- (void)didAddSubview:(UIView *)subview {
    if (subview == _indicatorView) {
        [_indicatorView startAnimating];
    }
}

#pragma mark - Public functions
- (CGRect)rectFrame {
    return _rectLayer.frame;
}

- (void)startScanning {
    
    _lineLayer.hidden = NO;
    [_lineLayer addAnimation:_lineAnimationGroup forKey:@"lineAnimation"];
}

- (void)stopScanning {
    
    _lineLayer.hidden = YES;
    [_lineLayer removeAnimationForKey:@"lineAnimation"];
}

- (void)startIndicating {
    [_indicatorView stopAnimating];
}

- (void)stopIndicating {
    [_indicatorView stopAnimating];
}

- (void)showTorchSwitch {
    _torchSwithButton.hidden = NO;
    _torchSwithButton.alpha = .0;
    [UIView animateWithDuration:.25 animations:^{
        self.torchSwithButton.alpha = 1.0;
    }];
}

- (void)hideTorchSwitch {
    [UIView animateWithDuration:.1 animations:^{
        self.torchSwithButton.alpha = .0;
    } completion:^(BOOL finished) {
        self.torchSwithButton.hidden = YES;
    }];
}

#pragma mark - Action functions
- (void)torchSwitchClicked:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(codeScanningView:didClickedTorchSwitch:)]) {
        [_delegate codeScanningView:self didClickedTorchSwitch:button];
    }
}

#pragma mark lazy
-(BSCMainCameraMutableCodeView *)mutableCodeView{
    if (_mutableCodeView == nil){
        _mutableCodeView = [[BSCMainCameraMutableCodeView alloc] init];
        _mutableCodeView.backgroundColor = [UIColor ig_colorWithHexString:@"#000000" alpha:0.5];
        _mutableCodeView.hidden = YES;
    }
    return _mutableCodeView;
}

@end
