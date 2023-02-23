//
//  LanYouAlert.m
//
#import "LanYouAlert.h"


#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define VIEW_WIDTH CGRectGetWidth(self.view.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)
#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, CMBackgroundStyle) {
    /** 背景样式 模糊 */
    CMBackgroundStyleBlur,
    /** 背景样式 半透明 */
    CMBackgroundStyleTranslucent,
};

@interface LanYouAlertConfigModel ()

@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelItemArray;
@property (nonatomic , strong ) NSMutableDictionary *modelItemInsetsInfo;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelShadowOpacity;
@property (nonatomic , assign ) CGFloat modelShadowRadius;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;
@property (nonatomic , assign ) CGFloat modelWindowLevel;
@property (nonatomic , assign ) NSInteger modelQueuePriority;

@property (nonatomic , assign ) UIColor *modelShadowColor;
@property (nonatomic , strong ) UIColor *modelHeaderColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickHeaderClose;
@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsShouldAutorotate;
@property (nonatomic , assign ) BOOL modelIsQueue;
@property (nonatomic , assign ) BOOL modelIsContinueQueueDisplay;
@property (nonatomic , assign ) BOOL modelIsAvoidKeyboard;
/// 是否支持滑动
@property (nonatomic , assign ) BOOL modelScrollEnabled;
/// 是否开启底部安全区域
@property (nonatomic,  assign ) BOOL modelSafeAreaBottom;
/// modelContainerRectCorner
@property (nonatomic, assign) UIRectCorner modelContainerRectCorner;
/// cornerRadii
@property (nonatomic, assign) CGSize modelCornerRadii;



@property (nonatomic , assign ) CGSize modelShadowOffset;
///
@property (nonatomic , assign) CGSize modelAlertActionBorderSize;

@property (nonatomic , assign ) CGPoint modelAlertCenterOffset;
@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , copy ) NSString *modelIdentifier;

@property (nonatomic , copy ) CGFloat (^modelMaxWidthBlock)(CMScreenOrientationType);
@property (nonatomic , copy ) CGFloat (^modelMaxHeightBlock)(CMScreenOrientationType);

@property (nonatomic , copy ) void(^modelOpenAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void(^modelCloseAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void (^modelFinishConfig)(void);
@property (nonatomic , copy ) BOOL (^modelShouldClose)(void);
@property (nonatomic , copy ) BOOL (^modelShouldActionClickClose)(NSInteger);
@property (nonatomic , copy ) void (^modelCloseComplete)(void);
@property (nonatomic , copy ) void (^modelBackClickComplete)(void);
@property (nonatomic , copy ) void (^modelAlertBGIVBlock)(UIImageView *imageView);

@property (nonatomic , assign ) CMBackgroundStyle modelBackgroundStyle;
@property (nonatomic , assign ) CMAnimationStyle modelOpenAnimationStyle;
@property (nonatomic , assign ) CMAnimationStyle modelCloseAnimationStyle;
@property (nonatomic , assign ) CMAlertActionBorderStyle modelAlertActionBorderStyle;

@property (nonatomic , assign ) UIStatusBarStyle modelStatusBarStyle;
@property (nonatomic , assign ) UIBlurEffectStyle modelBackgroundBlurEffectStyle;
@property (nonatomic , assign ) UIInterfaceOrientationMask modelSupportedInterfaceOrientations;

@property (nonatomic , strong ) UIColor *modelActionSheetBackgroundColor;
@property (nonatomic , strong ) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic , assign ) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;
@end

@implementation LanYouAlertConfigModel

- (void)dealloc{
    
    _modelActionArray = nil;
    _modelItemArray = nil;
    _modelItemInsetsInfo = nil;
}

- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        currentVC = rootVC;
    }
    return currentVC;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        
        _modelCornerRadius = 10.0f; //默认圆角半径
        _modelShadowOpacity = 0.0f; //默认阴影不透明度
        _modelShadowRadius = 0.0f; //默认阴影半径
        _modelShadowOffset = CGSizeMake(0.0f, 0.0f); //默认阴影偏移
        _modelHeaderInsets = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.1f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        _modelWindowLevel = UIWindowLevelNormal;
        _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
        _modelIdentifier = @"normal";
        UIViewController *vc = [self getCurrentVC];
        _modelStatusBarStyle = vc ? vc.preferredStatusBarStyle : UIStatusBarStyleLightContent;
        
        _modelCornerRadii = CGSizeZero;
        _modelContainerRectCorner = UIRectCornerAllCorners;
        _modelActionSheetBackgroundColor = [UIColor clearColor]; //默认actionsheet背景颜色
        _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
        _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
        _modelShadowColor = [UIColor blackColor]; //默认阴影颜色
        _modelHeaderColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1/1.0]; //默认颜色
        _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
        
        _modelIsClickBackgroundClose = NO; //默认点击背景不关闭
        _modelIsShouldAutorotate = YES; //默认支持自动旋转
        _modelIsQueue = NO; //默认不加入队列
        _modelIsContinueQueueDisplay = YES; //默认继续队列显示
        _modelIsAvoidKeyboard = YES; //默认闪避键盘
        _modelScrollEnabled = NO;//弹窗是否可以滑动
        _modelBackgroundStyle = CMBackgroundStyleTranslucent; //默认为半透明背景样式
        
        _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
        _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
        
        __weak typeof(self) weakSelf = self;
        
        _modelOpenAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelOpenAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        _modelCloseAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelCloseAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        _modelShouldClose = ^{
            return YES;
        };
        
        _modelShouldActionClickClose = ^(NSInteger index){
            return YES;
        };
    }
    return self;
}

- (CMConfigToString)CMTitle{
    
    return ^(NSString *str){
        
        return self.CMAddTitle(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}


- (CMConfigToString)CMContent{
    
    return ^(NSString *str){
        
        return  self.CMAddContent(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}

- (CMConfigToView)CMCustomView{
    
    return ^(UIView *view){
        
        return self.CMAddCustomView(^(CMCustomView *custom) {
            
            custom.view = view;
        });
        
    };
    
}

- (CMConfigToStringAndBlock)CMAction{
    
    return ^(NSString *title , void(^block)(void)){
        
        return self.CMAddAction(^(CMAction *action) {
            
            action.type = CMActionTypeDefault;
            
            action.title = title;
            
            action.clickBlock = block;
        });
        
    };
    
}

- (CMConfigToStringAndBlock)CMCancelAction{
    
    return ^(NSString *title , void(^block)(void)){
        
        return self.CMAddAction(^(CMAction *action) {
            
            action.type = CMActionTypeCancel;
            
            action.title = title;
            
            action.font = [UIFont boldSystemFontOfSize:18.0f];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (CMConfigToStringAndBlock)CMDestructiveAction{
    
    return ^(NSString *title , void(^block)(void)){
        
        return self.CMAddAction(^(CMAction *action) {
            
            action.type = CMActionTypeDestructive;
            
            action.title = title;
            
            action.titleColor = [UIColor redColor];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (CMConfigToConfigLabel)CMAddTitle{
    
    return ^(void(^block)(UILabel *)){
        
        return self.CMAddItem(^(CMItem *item) {
            
            item.type = CMItemTypeTitle;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (CMConfigToConfigLabel)CMAddContent{
    
    return ^(void(^block)(UILabel *)){
        
        return self.CMAddItem(^(CMItem *item) {
            
            item.type = CMItemTypeContent;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (CMConfigToCustomView)CMAddCustomView{
    
    return ^(void(^block)(CMCustomView *custom)){
        
        return self.CMAddItem(^(CMItem *item) {
            
            item.type = CMItemTypeCustomView;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}
- (CMConfigToImageView)CMAddAlertBGImageView {
    return ^(void(^block)(UIImageView *)){
        self.modelAlertBGIVBlock = block;
        return self;
    };
}
- (CMConfigToItem)CMAddItem{
    
    return ^(void(^block)(CMItem *)){
        
        if (block) [self.modelItemArray addObject:block];
        
        return self;
    };
    
}

- (CMConfigToAction)CMAddAction{
    
    return ^(void(^block)(CMAction *)){
        
        if (block) [self.modelActionArray addObject:block];
        
        return self;
    };
    
}

- (CMConfigToActions)CMAddActions {
    __weak __typeof(self)weakSelf = self;
    return ^(NSArray <void(^)(CMAction *)> *actions) {
        if (actions && [actions isKindOfClass:[NSArray class]] && actions.count > 0) {
            [self.modelActionArray addObjectsFromArray:actions];
        }
        return weakSelf;
    };
}


- (CMConfigToEdgeInsets)CMHeaderInsets{
    
    return ^(UIEdgeInsets insets){
        
        if (insets.top < 0) insets.top = 0;
        
        if (insets.left < 0) insets.left = 0;
        
        if (insets.bottom < 0) insets.bottom = 0;
        
        if (insets.right < 0) insets.right = 0;
        
        self.modelHeaderInsets = insets;
        
        return self;
    };
    
}

- (CMConfigToEdgeInsets)CMItemInsets{
    
    return ^(UIEdgeInsets insets){
        
        if (self.modelItemArray.count) {
            
            if (insets.top < 0) insets.top = 0;
            
            if (insets.left < 0) insets.left = 0;
            
            if (insets.bottom < 0) insets.bottom = 0;
            
            if (insets.right < 0) insets.right = 0;
            
            [self.modelItemInsetsInfo setObject: [NSValue valueWithUIEdgeInsets:insets]
                                         forKey:@(self.modelItemArray.count - 1)];
            
        } else {
            
            NSAssert(YES, @"请在添加的某一项后面设置间距");
        }
        
        return self;
    };
    
}

- (CMConfigToFloat)CMMaxWidth{
    
    return ^(CGFloat number){
        
        return self.CMConfigMaxWidth(^CGFloat(CMScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (CMConfigToFloat)CMMaxHeight{
    
    return ^(CGFloat number){
        
        return self.CMConfigMaxHeight(^CGFloat(CMScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (CMConfigToFloatBlock)CMConfigMaxWidth{
    
    return ^(CGFloat(^block)(CMScreenOrientationType type)){
        
        if (block) self.modelMaxWidthBlock = block;
        
        return self;
    };
    
}

- (CMConfigToFloatBlock)CMConfigMaxHeight{
    
    return ^(CGFloat(^block)(CMScreenOrientationType type)){
        
        if (block) self.modelMaxHeightBlock = block;
        
        return self;
    };
    
}

- (CMConfigToFloat)CMCornerRadius{
    
    return ^(CGFloat number){
        
        self.modelCornerRadius = number;
        
        return self;
    };
    
}

- (CMConfigToFloat)CMOpenAnimationDuration{
    
    return ^(CGFloat number){
        
        self.modelOpenAnimationDuration = number;
        
        return self;
    };
    
}

- (CMConfigToFloat)CMCloseAnimationDuration{
    
    return ^(CGFloat number){
        
        self.modelCloseAnimationDuration = number;
        
        return self;
    };
    
}

- (CMConfigToColor)CMHeaderColor{
    
    return ^(UIColor *color){
        
        self.modelHeaderColor = color;
        
        return self;
    };
    
}

- (CMConfigToColor)CMBackGroundColor{
    
    return ^(UIColor *color){
        
        self.modelBackgroundColor = color;
        
        return self;
    };
    
}

- (CMConfigToFloat)CMBackgroundStyleTranslucent{
    
    return ^(CGFloat number){
        
        self.modelBackgroundStyle = CMBackgroundStyleTranslucent;
        
        self.modelBackgroundStyleColorAlpha = number;
        
        return self;
    };
    
}

- (CMConfigToBlurEffectStyle)CMBackgroundStyleBlur{
    
    return ^(UIBlurEffectStyle style){
        
        self.modelBackgroundStyle = CMBackgroundStyleBlur;
        
        self.modelBackgroundBlurEffectStyle = style;
        
        return self;
    };
    
}

- (CMConfigToBool)CMClickHeaderClose{
    
    return ^(BOOL is){
        
        self.modelIsClickHeaderClose = is;
        
        return self;
    };
    
}

- (CMConfigToBool)CMClickBackgroundClose{
    
    return ^(BOOL is){
        
        self.modelIsClickBackgroundClose = is;
        
        return self;
    };
    
}

- (CMConfigToBool)CMScrollEnabled {
    return ^(BOOL is){
           
           self.modelScrollEnabled = is;
           
           return self;
       };
}

- (CMConfigToSize)CMShadowOffset{
    
    return ^(CGSize size){
        
        self.modelShadowOffset = size;
        
        return self;
    };
}

- (CMConfigToFloat)CMShadowOpacity{
    
    return ^(CGFloat number){
        
        self.modelShadowOpacity = number;
        
        return self;
    };
    
}

- (CMConfigToFloat)CMShadowRadius{
    
    return ^(CGFloat number){
        
        self.modelShadowRadius = number;
        
        return self;
    };
    
}

- (CMConfigToColor)CMShadowColor{
    
    return ^(UIColor *color){
        
        self.modelShadowColor = color;
        
        return self;
    };
    
}

- (CMConfigToString)CMIdentifier{
    
    return ^(NSString *string){
        
        self.modelIdentifier = string;
        
        return self;
    };
    
}

- (CMConfigToBool)CMQueue{
    
    return ^(BOOL is){
        
        self.modelIsQueue = is;
        
        return self;
    };
    
}

- (CMConfigToInteger)CMPriority{
    
    return ^(NSInteger number){
        
        self.modelQueuePriority = number > 0 ? number : 0;
        
        return self;
    };
    
}

- (CMConfigToBool)CMContinueQueueDisplay{
    
    return ^(BOOL is){
        
        self.modelIsContinueQueueDisplay = is;
        
        return self;
    };
    
}

- (CMConfigToFloat)CMWindowLevel{
    
    return ^(CGFloat number){
        
        self.modelWindowLevel = number;
        
        return self;
    };
    
}

- (CMConfigToBool)CMShouldAutorotate{
    
    return ^(BOOL is){
        
        self.modelIsShouldAutorotate = is;
        
        return self;
    };
    
}

- (CMConfigToInterfaceOrientationMask)CMSupportedInterfaceOrientations{
    
    return ^(UIInterfaceOrientationMask mask){
        
        self.modelSupportedInterfaceOrientations = mask;
        
        return self;
    };
    
}

- (CMConfigToBlockAndBlock)CMOpenAnimationConfig{
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        self.modelOpenAnimationConfigBlock = block;
        
        return self;
    };
    
}

- (CMConfigToBlockAndBlock)CMCloseAnimationConfig{
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        self.modelCloseAnimationConfigBlock = block;
        
        return self;
    };
    
}

- (CMConfigToAnimationStyle)CMOpenAnimationStyle{
    
    return ^(CMAnimationStyle style){
        
        self.modelOpenAnimationStyle = style;
        
        return self;
    };
    
}

- (CMConfigToAnimationStyle)CMCloseAnimationStyle{
    
    return ^(CMAnimationStyle style){
        
        self.modelCloseAnimationStyle = style;
        
        return self;
    };
    
}

- (CMConfigToStatusBarStyle)CMStatusBarStyle{
    
    return ^(UIStatusBarStyle style){
        
        self.modelStatusBarStyle = style;
        
        return self;
    };
    
}
- (CMConfigToAlertActionBorderStyle)CMAlertActionBorderStyle {
    
    return ^(CMAlertActionBorderStyle style) {
        
         self.modelAlertActionBorderStyle = style;
        
        return self;
    };
}

- (CMConfig)CMShow{
    
    return ^{
        
        if (self.modelFinishConfig) self.modelFinishConfig();
        
        return self;
    };
    
}
- (CMConfigToContainerRectCorner)CMContainerCorner {
    return  ^(UIRectCorner corner,CGSize cornerRadii) {
        self.modelContainerRectCorner = corner;
        self.modelCornerRadii = cornerRadii;
        return self;
    };
}
#pragma mark Alert Config

- (CMConfigToConfigTextField)CMAddTextField{
    
    return ^(void (^block)(UITextField *)){
        
        return self.CMAddItem(^(CMItem *item) {
            
            item.type = CMItemTypeTextField;
            
            item.insets = UIEdgeInsetsMake(10, 0, 10, 0);
            
            item.block = block;
        });
        
    };
    
}
    
- (CMConfigToPoint)CMAlertCenterOffset {
    
    return ^(CGPoint offset){
        
        self.modelAlertCenterOffset = offset;
        
        return self;
    };
    
}


- (CMConfigToSize)CMAlertActionBorderSize{
    
    return ^(CGSize size){
        
        self.modelAlertActionBorderSize = size;
        
        return self;
    };
}
- (CMConfigToBool)CMAvoidKeyboard{
    
    return ^(BOOL is){
        
        self.modelIsAvoidKeyboard = is;
        
        return self;
    };
    
}

#pragma mark ActionSheet Config

- (CMConfigToFloat)CMActionSheetCancelActionSpaceWidth{
    
    return ^(CGFloat number){
        
        self.modelActionSheetCancelActionSpaceWidth = number;
        
        return self;
    };
    
}

- (CMConfigToColor)CMActionSheetCancelActionSpaceColor{
    
    return ^(UIColor *color){
        
        self.modelActionSheetCancelActionSpaceColor = color;
        
        return self;
    };
    
}

- (CMConfigToFloat)CMActionSheetBottomMargin{
    
    return ^(CGFloat number){
        
        self.modelActionSheetBottomMargin = number;
        
        return self;
    };
    
}

- (CMConfigToColor)CMActionSheetBackgroundColor{
    
    return ^(UIColor *color){
        
        self.modelActionSheetBackgroundColor = color;
        
        return self;
    };
    
}

- (CMConfigToBlockReturnBool)cmShouldClose{
    
    return ^(BOOL (^block)(void)){
        
        self.modelShouldClose = block;
        
        return self;
    };
    
}

- (CMConfigToBlockIntegerReturnBool)cmShouldActionClickClose{
    
    return ^(BOOL (^block)(NSInteger index)){
        
        self.modelShouldActionClickClose = block;
        
        return self;
    };
    
}

- (CMConfigToBlock)CMCloseComplete{
    
    return ^(void (^block)(void)){
        
        self.modelCloseComplete = block;
        
        return self;
    };
    
}
- (CMConfigToBackClickBlock)CMBackClickComplete {
    
    return ^(void (^block)(void)){
        
        self.modelBackClickComplete = block;
        
        return self;
    };
    
}

- (CMConfigToBool)CMOpenSafeAreaBottom{
    
    return ^(BOOL is){
        
        self.modelSafeAreaBottom = is;
        
        return self;
    };
    
}
#pragma mark LazyLoading

- (NSMutableArray *)modelActionArray{
    
    if (!_modelActionArray) _modelActionArray = [NSMutableArray array];
    
    return _modelActionArray;
}

- (NSMutableArray *)modelItemArray{
    
    if (!_modelItemArray) _modelItemArray = [NSMutableArray array];
    
    return _modelItemArray;
}

- (NSMutableDictionary *)modelItemInsetsInfo{
    
    if (!_modelItemInsetsInfo) _modelItemInsetsInfo = [NSMutableDictionary dictionary];
    
    return _modelItemInsetsInfo;
}

@end

@interface LanYouAlert ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) LanYouAlertWindow *cmWindow;

@property (nonatomic , strong ) NSMutableArray <LanYouAlertConfig *>*queueArray;

@property (nonatomic , strong ) LanYouAlertBaseController *viewController;

@end

@protocol IGAlertProtocol <NSObject>

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

@end

@implementation LanYouAlert

+ (LanYouAlert *)shareManager{
    
    static LanYouAlert *alertManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alertManager = [[LanYouAlert alloc] init];
    });
    
    return alertManager;
}

+ (LanYouAlertConfig *)alert{
    
    LanYouAlertConfig *config = [[LanYouAlertConfig alloc] init];
    
    config.type = LanYouAlertTypeAlert;
    
    return config;
}

+ (LanYouAlertConfig *)actionsheet{
    
    LanYouAlertConfig *config = [[LanYouAlertConfig alloc] init];
    
    config.type = CMAlertTypeActionSheet;
    
    config.config.CMClickBackgroundClose(YES);
    
    return config;
}

+ (LanYouAlertWindow *)getAlertWindow{
    
    return [LanYouAlert shareManager].cmWindow;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [LanYouAlert shareManager].mainWindow = window;
}

+ (void)continueQueueDisplay{
    
    if ([LanYouAlert shareManager].queueArray.count) [LanYouAlert shareManager].queueArray.lastObject.config.modelFinishConfig();
}

+ (void)clearQueue{
    
    [[LanYouAlert shareManager].queueArray removeAllObjects];
}

+ (void)closeWithIdentifier:(NSString *)identifier completionBlock:(void (^ _Nullable)(void))completionBlock{
    [self closeWithIdentifier:identifier force:NO completionBlock:completionBlock];
}

+ (void)closeWithIdentifier:(NSString *)identifier force:(BOOL)force completionBlock:(void (^)(void))completionBlock{
    
    if ([LanYouAlert shareManager].queueArray.count) {
        
        BOOL isLast = false;
        
        NSUInteger count = [LanYouAlert shareManager].queueArray.count;
        
        NSMutableIndexSet *indexs = [[NSMutableIndexSet alloc] init];
        
        for (NSUInteger i = 0; i < count; i++) {
            
            LanYouAlertConfig *config = [LanYouAlert shareManager].queueArray[i];
            
            LanYouAlertConfigModel *model = config.config;
            
            if (model.modelIdentifier != nil && [identifier isEqualToString: model.modelIdentifier]) {
                
                if (i == count - 1 && [[LanYouAlert shareManager] viewController]) {
                    if (force) {
                        model.modelShouldClose = ^{ return YES; };
                    }
                    
                    isLast = true;
                    
                } else {
                    
                    [indexs addIndex:i];
                }
            }
        }
        
        [[LanYouAlert shareManager].queueArray removeObjectsAtIndexes:indexs];
        
        if (isLast) {
        
            [LanYouAlert closeWithCompletionBlock:completionBlock];
        
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }
}

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([LanYouAlert shareManager].queueArray.count) {
        
        LanYouAlertConfig *item = [LanYouAlert shareManager].queueArray.lastObject;
        
        if ([item respondsToSelector:@selector(closeWithCompletionBlock:)]) [item performSelector:@selector(closeWithCompletionBlock:) withObject:completionBlock];
    }
    
}

#pragma mark LazyLoading

- (NSMutableArray <LanYouAlertConfig *>*)queueArray{
    
    if (!_queueArray) _queueArray = [NSMutableArray array];
    
    return _queueArray;
}

- (LanYouAlertWindow *)cmWindow{
    
    if (!_cmWindow) {
        
        _cmWindow = [[LanYouAlertWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _cmWindow.rootViewController = [[UIViewController alloc] init];
        
        _cmWindow.backgroundColor = [UIColor clearColor];
        
        _cmWindow.windowLevel = UIWindowLevelAlert;
        
        _cmWindow.hidden = YES;
    }
    
    return _cmWindow;
}

@end

@implementation LanYouAlertWindow

@end

@interface CMItem ()

@property (nonatomic , copy ) void (^updateBlock)(CMItem *);

@end

@implementation CMItem

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface CMAction ()

@property (nonatomic , copy ) void (^updateBlock)(CMAction *);
/// 是否显示按钮中间的短线
@property (nonatomic , assign ) BOOL isShowMiddleLine;

@property (nonatomic, assign) CGSize borderSize;
@end

@implementation CMAction

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface CMItemView : UIView

@property (nonatomic , strong ) CMItem *item;

+ (CMItemView *)view;

@end

@implementation CMItemView

+ (CMItemView *)view{
    
    return [[CMItemView alloc] init];
}

@end

@interface CMItemLabel : UILabel

@property (nonatomic , strong ) CMItem *item;

@property (nonatomic , copy ) void (^textChangedBlock)(void);

+ (CMItemLabel *)label;

@end

@implementation CMItemLabel

+ (CMItemLabel *)label{
    
    return [[CMItemLabel alloc] init];
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    [super setAttributedText:attributedText];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    
    [super setNumberOfLines:numberOfLines];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

@end

@interface CMItemTextField : UITextField

@property (nonatomic , strong ) CMItem *item;

+ (CMItemTextField *)textField;

@end

@implementation CMItemTextField

+ (CMItemTextField *)textField{
    
    return [[CMItemTextField alloc] init];
}

@end
#pragma mark - CMActionButton
@interface CMActionButton : UIButton

@property (nonatomic , strong ) CMAction *action;

@property (nonatomic , copy ) void (^heightChangedBlock)(void);

+ (CMActionButton *)button;

@end

@interface CMActionButton ()

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) CGFloat borderWidth;

@property (nonatomic , strong ) CALayer *topLayer;

@property (nonatomic , strong ) CALayer *bottomLayer;

@property (nonatomic , strong ) CALayer *leftLayer;

@property (nonatomic , strong ) CALayer *rightLayer;

@end

@implementation CMActionButton

+ (CMActionButton *)button{
    
    return [CMActionButton buttonWithType:UIButtonTypeCustom];;
}

- (void)setAction:(CMAction *)action{
    
    _action = action;
    
    self.clipsToBounds = YES;
    
    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.attributedTitle) [self setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
    
    if (action.attributedHighlight) [self setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];
    
    if (action.font) [self.titleLabel setFont:action.font];
    
    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.highlightColor) [self setTitleColor:action.highlightColor forState:UIControlStateHighlighted];
    
    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundHighlightColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];
    
    if (action.backgroundImage) [self setBackgroundImage:action.backgroundImage forState:UIControlStateNormal];
    
    if (action.backgroundHighlightImage) [self setBackgroundImage:action.backgroundHighlightImage forState:UIControlStateHighlighted];
    
    if (action.borderColor) [self setBorderColor:action.borderColor];
    
    if (action.borderWidth > 0) [self setBorderWidth:action.borderWidth < DEFAULTBORDERWIDTH ? DEFAULTBORDERWIDTH : action.borderWidth]; else [self setBorderWidth:0.0f];
    
    if (action.image) [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];
    
    if (action.height) [self setActionHeight:action.height];
    
    if (action.cornerRadius) [self.layer setCornerRadius:action.cornerRadius];
    
    [self setImageEdgeInsets:action.imageEdgeInsets];
    
    [self setTitleEdgeInsets:action.titleEdgeInsets];
    
    if (action.borderPosition & CMActionBorderPositionTop &&
        action.borderPosition & CMActionBorderPositionBottom &&
        action.borderPosition & CMActionBorderPositionLeft &&
        action.borderPosition & CMActionBorderPositionRight) {
        
        self.layer.borderWidth = action.borderWidth;
        
        self.layer.borderColor = action.borderColor.CGColor;
        
        [self removeTopBorder];
        
        [self removeBottomBorder];
        
        [self removeLeftBorder];
        
        [self removeRightBorder];
        
    } else {
        
        self.layer.borderWidth = 0.0f;
        
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (action.borderPosition & CMActionBorderPositionTop) [self addTopBorder]; else [self removeTopBorder];
        
        if (action.borderPosition & CMActionBorderPositionBottom) [self addBottomBorder]; else [self removeBottomBorder];
        
        if (action.borderPosition & CMActionBorderPositionLeft) [self addLeftBorder]; else [self removeLeftBorder];
        
        if (action.borderPosition & CMActionBorderPositionRight) [self addRightBorder]; else [self removeRightBorder];
    }
    
    __weak typeof(self) weakSelf = self;
    
    action.updateBlock = ^(CMAction *act) {
        
        if (weakSelf) weakSelf.action = act;
    };
    
}

- (CGFloat)actionHeight{
    
    return self.frame.size.height;
}

- (void)setActionHeight:(CGFloat)height{
    
    BOOL isChange = [self actionHeight] == height ? NO : YES;
    
    CGRect buttonFrame = self.frame;
    
    buttonFrame.size.height = height;
    
    self.frame = buttonFrame;
    
    if (isChange) {
        
        if (self.heightChangedBlock) self.heightChangedBlock();
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_topLayer) _topLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.borderWidth);
    
    if (_bottomLayer) _bottomLayer.frame = CGRectMake(0, self.frame.size.height - self.borderWidth, self.frame.size.width, self.borderWidth);
    
    if (_leftLayer) _leftLayer.frame = CGRectMake(0, 0, self.borderWidth, self.frame.size.height);
    
    if (_rightLayer) {
        if (self.action.isShowMiddleLine) {
            if (!CGSizeEqualToSize(self.action.borderSize, CGSizeZero)) {
                CGFloat borderWidth = self.action.borderSize.width;
                CGFloat borderHeight = self.action.borderSize.height;
                if (borderHeight > self.frame.size.height) {
                    borderHeight = self.frame.size.width;
                }
                _rightLayer.frame = CGRectMake(self.frame.size.width - borderWidth, (self.frame.size.height - borderHeight) * 0.5, borderWidth, borderHeight);
            }else {
                _rightLayer.frame = CGRectMake(self.frame.size.width - self.borderWidth, (self.frame.size.height - 18) * 0.5, self.borderWidth, 18);
            }
        }else {
            _rightLayer.frame = CGRectMake(self.frame.size.width - self.borderWidth, 0, self.borderWidth, self.frame.size.height);
        }
    }
}

- (void)addTopBorder{
    
    [self.layer addSublayer:self.topLayer];
}

- (void)addBottomBorder{
    
    [self.layer addSublayer:self.bottomLayer];
}

- (void)addLeftBorder{
    
    [self.layer addSublayer:self.leftLayer];
}

- (void)addRightBorder{
    
    [self.layer addSublayer:self.rightLayer];
}

- (void)removeTopBorder{
    
    if (_topLayer) [_topLayer removeFromSuperlayer]; _topLayer = nil;
}

- (void)removeBottomBorder{
    
    if (_bottomLayer) [_bottomLayer removeFromSuperlayer]; _bottomLayer = nil;
}

- (void)removeLeftBorder{
    
    if (_leftLayer) [_leftLayer removeFromSuperlayer]; _leftLayer = nil;
}

- (void)removeRightBorder{
    
    if (_rightLayer) [_rightLayer removeFromSuperlayer]; _rightLayer = nil;
}

- (CALayer *)createLayer{
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = self.borderColor.CGColor;
    
    return layer;
}

- (CALayer *)topLayer{
    
    if (!_topLayer) _topLayer = [self createLayer];
    
    return _topLayer;
}

- (CALayer *)bottomLayer{
    
    if (!_bottomLayer) _bottomLayer = [self createLayer];
    
    return _bottomLayer;
}

- (CALayer *)leftLayer{
    
    if (!_leftLayer) _leftLayer = [self createLayer];
    
    return _leftLayer;
}

- (CALayer *)rightLayer{
    
    if (!_rightLayer) _rightLayer = [self createLayer];
    
    return _rightLayer;
}

- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
#pragma mark - CMCustomView
@interface CMCustomView ()

@property (nonatomic , strong ) CMItem *item;

@property (nonatomic , strong ) UIView *container;

@property (nonatomic , assign ) CGSize size;

@property (nonatomic , copy ) void (^sizeChangedBlock)(void);

@end

@implementation CMCustomView

- (instancetype)init{
    self = [super init];
    if (self) {
        _positionType = CMCustomViewPositionTypeCenter;
    }
    return self;
}

- (void)dealloc{
    self.view = nil;
    
    if (_container) {
        
        [_container removeObserver:self forKeyPath:@"frame"];
        [_container removeObserver:self forKeyPath:@"bounds"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    UIView *view = (UIView *)object;
    
    if ([view isEqual:self.container] && self.isAutoWidth) {
        
        if ([keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"bounds"]) {
            
            for (UIView *subView in view.subviews) {
                CGRect temp = subView.frame;
                temp.size.width = view.bounds.size.width;
                subView.frame = temp;
            }
        }
    }
    
    if ([view isEqual:self.view]) {
        
        if ([keyPath isEqualToString:@"frame"]) {

            if (self.isAutoWidth) {
                self.size = CGSizeMake(view.frame.size.width, self.size.height);
            }

            if (!CGSizeEqualToSize(self.size, view.frame.size)) {

                self.size = view.frame.size;

                [self updateContainerFrame:view];

                if (self.sizeChangedBlock) self.sizeChangedBlock();
            }
        }
        
        if ([keyPath isEqualToString:@"bounds"]) {
            
            if (self.isAutoWidth) {
                self.size = CGSizeMake(view.bounds.size.width, self.size.height);
            }
            
            if (!CGSizeEqualToSize(self.size, view.bounds.size)) {
                
                self.size = view.bounds.size;
                
                [self updateContainerFrame:view];
                
                if (self.sizeChangedBlock) self.sizeChangedBlock();
            }
        }
    }
    
    
    [CATransaction commit];
}

- (void)updateContainerFrame:(UIView *)view {
    
    view.frame = view.bounds;
    
    self.container.bounds = view.bounds;
}

- (UIView *)container{
   
    if (!_container) {
        
        _container = [[UIView alloc] initWithFrame:CGRectZero];
        
        _container.backgroundColor = UIColor.clearColor;
        
        _container.clipsToBounds = true;
        
        [_container addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
        [_container addObserver: self forKeyPath: @"bounds" options: NSKeyValueObservingOptionNew context: nil];
    }
    
    return _container;
}

- (void)setView:(UIView *)view{
    
    if (_view) {
        [_view removeFromSuperview];
        
        [_view removeObserver:self forKeyPath:@"frame"];
        [_view removeObserver:self forKeyPath:@"bounds"];
    }
    
    _view = view;
    
    if (_view) {
        [view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
        [view addObserver: self forKeyPath: @"bounds" options: NSKeyValueObservingOptionNew context: nil];
        
        [view layoutIfNeeded];
        [view layoutSubviews];
        
        _size = view.frame.size;
        
        [self updateContainerFrame:view];
        
        [self.container addSubview:view];
        
        if (view.translatesAutoresizingMaskIntoConstraints == NO) {
            NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.container
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1
                                                                            constant:0];
            [self.container addConstraint:constraintX];
            NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.container
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1
                                                                            constant:0];
            [self.container addConstraint:constraintY];
            
        }
    }
}

@end

@interface LanYouAlertBaseController ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong ) LanYouAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIVisualEffectView *backgroundVisualEffectView;

@property (nonatomic , assign ) CMScreenOrientationType orientationType;

@property (nonatomic , strong ) CMCustomView *customView;

@property (nonatomic , assign ) BOOL isShowing;

@property (nonatomic , assign ) BOOL isClosing;

@property (nonatomic , copy ) void (^openFinishBlock)(void);

@property (nonatomic , copy ) void (^closeFinishBlock)(void);

@end

@implementation LanYouAlertBaseController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _backgroundVisualEffectView = nil;
    
    _customView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.config.modelBackgroundStyle == CMBackgroundStyleBlur) {
        
        self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        
        self.backgroundVisualEffectView.frame = self.view.frame;
        
        [self.view addSubview:self.backgroundVisualEffectView];
    }
    
    self.view.backgroundColor = [self.config.modelBackgroundColor colorWithAlphaComponent:0.0f];
    
    self.orientationType = VIEW_HEIGHT > VIEW_WIDTH ? CMScreenOrientationTypeVertical : CMScreenOrientationTypeHorizontal;
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (self.backgroundVisualEffectView) self.backgroundVisualEffectView.frame = self.view.frame;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.orientationType = size.height > size.width ? CMScreenOrientationTypeVertical : CMScreenOrientationTypeHorizontal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    if (self.config.modelIsClickBackgroundClose) {
        [self closeAnimationsWithCompletionBlock:nil];
    }else if(self.config.modelBackClickComplete) {
         self.config.modelBackClickComplete();
    }
    
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [self.currentKeyWindow endEditing:YES];
    
    [self.view setUserInteractionEnabled:NO];
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [[LanYouAlert shareManager].cmWindow endEditing:YES];
}

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [LanYouAlert shareManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![LanYouAlert shareManager].mainWindow) [LanYouAlert shareManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

#pragma mark - 旋转

- (BOOL)shouldAutorotate{
    
    return self.config.modelIsShouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.config.modelSupportedInterfaceOrientations;
}

#pragma mark - 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return self.config.modelStatusBarStyle;
}

@end

#pragma mark - Alert

@interface LanYouAlertViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <id>*alertItemArray;

@property (nonatomic , strong ) NSMutableArray <CMActionButton *>*alertActionArray;

@end

@implementation LanYouAlertViewController
{
    CGRect keyboardFrame;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    _alertView = nil;
    
    _alertItemArray = nil;
    
    _alertActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configNotification];
    
    [self configAlert];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    
    if (self.config.modelIsAvoidKeyboard) {
        
        double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        isShowingKeyboard = keyboardFrame.origin.y < kScreenH;
        
        [UIView beginAnimations:@"keyboardWillChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
        [self updateAlertLayout];
        
        [UIView commitAnimations];
    }
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateAlertLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateAlertLayout];
}

- (void)updateAlertLayout{
    
    [self updateAlertLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateAlertLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    CGPoint offset = self.config.modelAlertCenterOffset;
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (isShowingKeyboard) {
        
        if (keyboardFrame.size.height) {
            
            CGFloat alertViewHeight = [self updateAlertItemsLayout];
            
            CGFloat keyboardY = keyboardFrame.origin.y;
            
            CGRect alertViewFrame = self.alertView.frame;
            
            CGFloat tempAlertViewHeight = keyboardY - alertViewHeight < 20 ? keyboardY - 20 : alertViewHeight;
            
            CGFloat tempAlertViewY = keyboardY - tempAlertViewHeight - 10;
            
            CGFloat originalAlertViewY = (viewHeight - alertViewFrame.size.height) * 0.5f + offset.y;
            
            alertViewFrame.size.height = tempAlertViewHeight;
            
            alertViewFrame.size.width = alertViewMaxWidth;
            
            self.alertView.frame = alertViewFrame;
            UIImageView *alertBGIV = self.alertView.subviews.firstObject;
            if ([alertBGIV isKindOfClass:UIImageView.class] && alertBGIV.tag == 9999) {
                alertBGIV.frame = alertViewFrame;
            }
            CGRect containerFrame = self.containerView.frame;
            
            containerFrame.size.width = alertViewFrame.size.width;
            
            containerFrame.size.height = alertViewFrame.size.height;
            
            containerFrame.origin.x = (viewWidth - alertViewFrame.size.width) * 0.5f + offset.x;
            
            containerFrame.origin.y = tempAlertViewY < originalAlertViewY ? tempAlertViewY : originalAlertViewY;
            
            if (version.doubleValue >= 9.0 && version.doubleValue < 10) {
                if (self.containerView.frame.origin.x == 0) {
                    self.containerView.frame = containerFrame;
                }
            } else {
                self.containerView.frame = containerFrame;
            }

            [self.alertView scrollRectToVisible:[self findFirstResponder:self.alertView].frame animated:YES];
        }
        
    } else {
        
        CGFloat alertViewHeight = [self updateAlertItemsLayout];
        
        alertViewMaxHeight -= ABS(offset.y);
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.width = alertViewMaxWidth;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        self.alertView.frame = alertViewFrame;
        UIImageView *alertBGIV = self.alertView.subviews.firstObject;
        if ([alertBGIV isKindOfClass:UIImageView.class] && alertBGIV.tag == 9999) {
            alertBGIV.frame = alertViewFrame;
        }
        
        CGRect containerFrame = self.containerView.frame;
        
        containerFrame.size.width = alertViewFrame.size.width;
        
        containerFrame.size.height = alertViewFrame.size.height;
        
        containerFrame.origin.x = (viewWidth - alertViewMaxWidth) * 0.5f + offset.x;
        
        containerFrame.origin.y = (viewHeight - alertViewFrame.size.height) * 0.5f + offset.y;
        
//        NSLog(@"-------------> %@",NSStringFromCGRect(self.containerView.frame));
        if (version.doubleValue >= 9.0 && version.doubleValue < 10) {
            if (self.containerView.frame.origin.x == 0) {
                self.containerView.frame = containerFrame;
            }
        } else {
            self.containerView.frame = containerFrame;
        }
        
    }
}

- (CGFloat)updateAlertItemsLayout{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    __block CGFloat alertViewHeight = 0.0f;
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) alertViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            CMItemView *view = (CMItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = alertViewHeight + view.item.insets.top;
            
            viewFrame.size.width = alertViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            alertViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:CMCustomView.class]) {
            
            CMCustomView *custom = (CMCustomView *)item;
            CGRect vFrame = custom.view.frame;
            vFrame.origin = CGPointZero;
            custom.view.frame = vFrame;

            CGRect viewFrame = custom.container.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = CMCustomViewPositionTypeCenter;
                
                viewFrame.size.width = alertViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                case CMCustomViewPositionTypeCenter:
                    viewFrame.origin.x = (alertViewMaxWidth - viewFrame.size.width) * 0.5f;
                    break;
                    
                case CMCustomViewPositionTypeLeft:
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    break;
                
                case CMCustomViewPositionTypeRight:
                    viewFrame.origin.x = alertViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = alertViewHeight + custom.item.insets.top;
            
            custom.container.frame = viewFrame;

            alertViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.alertItemArray.lastObject) alertViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (CMActionButton *button in self.alertActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = alertViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = alertViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        alertViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    if (self.alertActionArray.count == 2) {
        
        CMActionButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject : self.alertActionArray.lastObject;
        
        CMActionButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject : self.alertActionArray.firstObject;
       
        UIEdgeInsets buttonAInsets = buttonA.action.insets;
        
        UIEdgeInsets buttonBInsets = buttonB.action.insets;
        
        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame) + buttonAInsets.top + buttonAInsets.bottom;
        
        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame) + buttonBInsets.top + buttonBInsets.bottom;
        
        //CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minY = (buttonA.frame.origin.y - buttonAInsets.top) > (buttonB.frame.origin.y - buttonBInsets.top) ? (buttonB.frame.origin.y - buttonBInsets.top) : (buttonA.frame.origin.y - buttonAInsets.top);
        
        buttonA.frame = CGRectMake(buttonAInsets.left, minY + buttonAInsets.top, (alertViewMaxWidth / 2) - buttonAInsets.left - buttonAInsets.right, buttonA.frame.size.height);
        
        buttonB.frame = CGRectMake((alertViewMaxWidth / 2) + buttonBInsets.left, minY + buttonBInsets.top, (alertViewMaxWidth / 2) - buttonBInsets.left - buttonBInsets.right, buttonB.frame.size.height);
        
        alertViewHeight -= minHeight;
    }
    
    self.alertView.contentSize = CGSizeMake(alertViewMaxWidth, alertViewHeight);
    
    [CATransaction commit];
    
    return alertViewHeight;
}

- (void)configAlert{
    
    __weak typeof(self) weakSelf = self;
    
    self.containerView = [[UIView alloc] init];
    
    [self.view addSubview: self.containerView];
    
    [self.containerView addSubview: self.alertView];
    
    self.containerView.layer.shadowOffset = self.config.modelShadowOffset;
    
    self.containerView.layer.shadowRadius = self.config.modelShadowRadius;
    
    self.containerView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    self.containerView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    UIImageView *alertBGIV = [[UIImageView alloc] init];
    alertBGIV.userInteractionEnabled = YES;
    alertBGIV.tag = 9999;
    if (self.config.modelAlertBGIVBlock) {
        self.config.modelAlertBGIVBlock(alertBGIV);
        [self.alertView insertSubview:alertBGIV atIndex:0];
    }
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^itemBlock)(CMItem *) = obj;
        
        CMItem *item = [[CMItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case CMItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                CMItemLabel *label = [CMItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case CMItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                CMItemLabel *label = [CMItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case CMItemTypeCustomView:
            {
                void(^block)(CMCustomView *) = item.block;
                
                CMCustomView *custom = [[CMCustomView alloc] init];
                
                block(custom);
                
                [self.alertView addSubview:custom.container];
                
                [self.alertItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case CMItemTypeTextField:
            {
                CMItemTextField *textField = [CMItemTextField textField];
                
                textField.frame = CGRectMake(0, 0, 0, 40.0f);
                
                [self.alertView addSubview:textField];
                
                [self.alertItemArray addObject:textField];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                void(^block)(UITextField *textField) = item.block;
                
                if (block) block(textField);
                
                textField.item = item;
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    [self.config.modelActionArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^block)(CMAction *action) = item;
        
        CMAction *action = [[CMAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:16.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        
        if (!action.backgroundColor) action.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9/1.0];// self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;

        if (self.config.modelActionArray.count == 2) {
            if (self.config.modelAlertActionBorderStyle == CMAlertActionBorderStyleAll) {
                action.isShowMiddleLine = NO;
                if (!action.borderPosition) action.borderPosition = (idx == 0) ? CMActionBorderPositionTop | CMActionBorderPositionRight : CMActionBorderPositionTop;
            }else if (self.config.modelAlertActionBorderStyle == CMAlertActionBorderStyleTopMiddle) {
                action.isShowMiddleLine = YES;
                if (!CGSizeEqualToSize(self.config.modelAlertActionBorderSize, CGSizeZero)) {
                    action.borderSize = self.config.modelAlertActionBorderSize;
                }
                action.borderPosition = (idx == 0) ? CMActionBorderPositionTop | CMActionBorderPositionRight : CMActionBorderPositionTop;
            }else {
                action.isShowMiddleLine = YES;
                if (idx == 0) {
                    action.borderPosition = CMActionBorderPositionRight;
                    if (!CGSizeEqualToSize(self.config.modelAlertActionBorderSize, CGSizeZero)) {
                        action.borderSize = self.config.modelAlertActionBorderSize;
                    }
                }
            }
        }else {
            if (!action.borderPosition) action.borderPosition = CMActionBorderPositionTop;
        }
        
        if (!action.height) action.height = 45.0f;
        
        CMActionButton *button = [CMActionButton button];
        
        button.action = action;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
        
        [self.alertActionArray addObject:button];
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateAlertLayout];
        };
        
    }];
    
    // 更新布局
    
    [self updateAlertLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) [weakSelf updateAlertLayout];
    }];
    
}

- (void)buttonAction:(CMActionButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    switch (sender.action.type) {
            
        case CMActionTypeDefault:
            
            isClose = sender.action.isClickNotClose ? NO : YES;
            
            break;
            
        case CMActionTypeCancel:
            
            isClose = sender.action.isClickNotClose ? NO : YES;;
            
            break;
            
        case CMActionTypeDestructive:
            
            isClose = sender.action.isClickNotClose ? NO : YES;;
            
            break;
            
        default:
            break;
    }
    
    clickBlock = sender.action.clickBlock;
    
    NSInteger index = [self.alertActionArray indexOfObject:sender];
    
    if (isClose) {
        
        if (self.config.modelShouldActionClickClose && !self.config.modelShouldActionClickClose(index)) return;
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == CMBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            
        } else if (weakSelf.config.modelBackgroundStyle == CMBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    if (self.config.modelShouldClose && !self.config.modelShouldClose()) return;
    
    self.isClosing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == CMBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelBackgroundStyle == CMBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.alpha = 0.0f;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationNone) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark Tool

- (UIView *)findFirstResponder:(UIView *)view{
    
    if (view.isFirstResponder) return view;
    
    for (UIView *subView in view.subviews) {
        
        UIView *firstResponder = [self findFirstResponder:subView];
        
        if (firstResponder) return firstResponder;
    }
    
    return nil;
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.alertView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIScrollView *)alertView{
    
    if (!_alertView) {
        
        _alertView = [[UIScrollView alloc] init];
        
        _alertView.backgroundColor = self.config.modelHeaderColor;
        
        _alertView.directionalLockEnabled = YES;
        
        _alertView.scrollEnabled = self.config.modelScrollEnabled;
        
        _alertView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_alertView addGestureRecognizer:tap];
    }
    
    return _alertView;
}

- (NSMutableArray *)alertItemArray{
    
    if (!_alertItemArray) _alertItemArray = [NSMutableArray array];
    
    return _alertItemArray;
}

- (NSMutableArray <CMActionButton *>*)alertActionArray{
    
    if (!_alertActionArray) _alertActionArray = [NSMutableArray array];
    
    return _alertActionArray;
}

@end

#pragma mark - ActionSheet

@interface LanYouActionSheetViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *actionSheetView;

@property (nonatomic , strong ) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic , strong ) NSMutableArray <CMActionButton *>*actionSheetActionArray;

@property (nonatomic , strong ) UIView *actionSheetCancelActionSpaceView;

@property (nonatomic , strong ) CMActionButton *actionSheetCancelAction;

@end

@implementation LanYouActionSheetViewController
{
    BOOL isShowed;
}

- (void)dealloc{
    
    _actionSheetView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configActionSheet];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateActionSheetLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateActionSheetLayout];
}

- (void)updateActionSheetLayout{
    
    [self updateActionSheetLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateActionSheetLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    __block CGFloat actionSheetViewHeight = 0.0f;
    
    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) actionSheetViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            CMItemView *view = (CMItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = actionSheetViewHeight + view.item.insets.top;
            
            viewFrame.size.width = actionSheetViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            actionSheetViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:CMCustomView.class]) {
            
            CMCustomView *custom = (CMCustomView *)item;
            
            CGRect viewFrame = custom.container.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = CMCustomViewPositionTypeCenter;
                
                viewFrame.size.width = actionSheetViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case CMCustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (actionSheetViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case CMCustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case CMCustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = actionSheetViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = actionSheetViewHeight + custom.item.insets.top;
            
            custom.container.frame = viewFrame;
            
            actionSheetViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (CMActionButton *button in self.actionSheetActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = actionSheetViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = actionSheetViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    self.actionSheetView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionSheetViewHeight);
    
    [CATransaction commit];
    
    CGFloat cancelActionTotalHeight = self.actionSheetCancelAction ? self.actionSheetCancelAction.actionHeight + self.config.modelActionSheetCancelActionSpaceWidth : 0.0f;
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight - cancelActionTotalHeight ? actionSheetViewMaxHeight - cancelActionTotalHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect spaceFrame = self.actionSheetCancelActionSpaceView.frame;
        
        spaceFrame.origin.x = actionSheetViewFrame.origin.x;
        
        spaceFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height;
        
        spaceFrame.size.width = actionSheetViewMaxWidth;
        
        spaceFrame.size.height = self.config.modelActionSheetCancelActionSpaceWidth;
        
        self.actionSheetCancelActionSpaceView.frame = spaceFrame;
        
        CGRect buttonFrame = self.actionSheetCancelAction.frame;
        
        buttonFrame.origin.x = actionSheetViewFrame.origin.x;
        
        buttonFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height + spaceFrame.size.height;
        
        buttonFrame.size.width = actionSheetViewMaxWidth;
        
        self.actionSheetCancelAction.frame = buttonFrame;
    }
    
    CGRect containerFrame = self.containerView.frame;
    
    containerFrame.size.width = viewWidth;
    
    containerFrame.size.height = actionSheetViewFrame.size.height + cancelActionTotalHeight + self.config.modelActionSheetBottomMargin + (self.config.modelSafeAreaBottom == YES ? VIEWSAFEAREAINSETS(self.view).bottom : 0);
    
    containerFrame.origin.x = 0;
    
    if (isShowed) {
        
        containerFrame.origin.y = viewHeight - containerFrame.size.height;
        
    } else {
        
        containerFrame.origin.y = viewHeight;
    }
    
    self.containerView.frame = containerFrame;
    if (!CGSizeEqualToSize(self.config.modelCornerRadii, CGSizeZero) ) {
        [self.containerView layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners:self.config.modelContainerRectCorner cornerRadii:self.config.modelCornerRadii];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.containerView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.containerView.layer.mask = maskLayer;
    }
}

- (void)configActionSheet{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    [self.containerView addSubview: self.actionSheetView];
    
    self.containerView.backgroundColor = self.config.modelActionSheetBackgroundColor;
    
    self.containerView.layer.shadowOffset = self.config.modelShadowOffset;
    
    self.containerView.layer.shadowRadius = self.config.modelShadowRadius;
    
    self.containerView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    self.containerView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    self.actionSheetView.layer.cornerRadius = self.config.modelCornerRadius;
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^itemBlock)(CMItem *) = obj;
        
        CMItem *item = [[CMItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
            case CMItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                CMItemLabel *label = [CMItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case CMItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                CMItemLabel *label = [CMItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor grayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case CMItemTypeCustomView:
            {
                void(^block)(CMCustomView *) = item.block;
                
                CMCustomView *custom = [[CMCustomView alloc] init];
                
                block(custom);
                
                [self.actionSheetView addSubview:custom.container];
                
                [self.actionSheetItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
            default:
                break;
        }
        
    }];
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(CMAction *action) = item;
        
        CMAction *action = [[CMAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:16.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        
        if (!action.backgroundColor) action.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9/1.0];//self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.86 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.height) action.height = 57.0f;
        
        CMActionButton *button = [CMActionButton button];
        
        switch (action.type) {
            case CMActionTypeCancel:
            {
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                button.layer.cornerRadius = self.config.modelCornerRadius;
                
                button.backgroundColor = action.backgroundColor;
                
                [self.containerView addSubview:button];
                
                self.actionSheetCancelAction = button;
                
                self.actionSheetCancelActionSpaceView = [[UIView alloc] init];
                
                self.actionSheetCancelActionSpaceView.backgroundColor = self.config.modelActionSheetCancelActionSpaceColor;
                
                [self.containerView addSubview:self.actionSheetCancelActionSpaceView];
            }
                break;
                
            default:
            {
                if (!action.borderPosition) action.borderPosition = CMActionBorderPositionTop;
                
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.actionSheetView addSubview:button];
                
                [self.actionSheetActionArray addObject:button];
            }
                break;
        }
        
        button.action = action;
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateActionSheetLayout];
        };
    }
    
    // 更新布局
    
    [self updateActionSheetLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) [weakSelf updateActionSheetLayout];
    }];
    
}

- (void)buttonAction:(CMActionButton *)sender{
    
    BOOL isClose = NO;
    NSInteger index = 0;
    void (^clickBlock)(void) = nil;
    
    switch (sender.action.type) {
        case CMActionTypeDefault:
            
            isClose = sender.action.isClickNotClose ? NO : YES;
            
            index = [self.actionSheetActionArray indexOfObject:sender];
            
            break;
            
        case CMActionTypeCancel:
            
            isClose = sender.action.isClickNotClose ? NO : YES;;
            
            index = self.actionSheetActionArray.count;
            
            break;
            
        case CMActionTypeDestructive:
            
            isClose = sender.action.isClickNotClose ? NO : YES;;
            
            index = [self.actionSheetActionArray indexOfObject:sender];
            
            break;
            
        default:
            break;
    }
    
    clickBlock = sender.action.clickBlock;
    
    if (isClose) {
        
        if (self.config.modelShouldActionClickClose && !self.config.modelShouldActionClickClose(index)) return;
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    isShowed = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & CMAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & CMAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case CMBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
            }
                break;
                
            case CMBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.config.modelBackgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight - containerFrame.size.height;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    if (self.config.modelShouldClose && !self.config.modelShouldClose()) return;
    
    self.isClosing = YES;
    
    isShowed = NO;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case CMBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.alpha = 0.0f;
            }
                break;
                
            case CMBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationNone) {
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & CMAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.actionSheetView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIView *)actionSheetView{
    
    if (!_actionSheetView) {
        
        _actionSheetView = [[UIScrollView alloc] init];
        
        _actionSheetView.backgroundColor = self.config.modelHeaderColor;
        
        _actionSheetView.directionalLockEnabled = YES;
        
        _actionSheetView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_actionSheetView addGestureRecognizer:tap];
    }
    
    return _actionSheetView;
}

- (NSMutableArray <id>*)actionSheetItemArray{
    
    if (!_actionSheetItemArray) _actionSheetItemArray = [NSMutableArray array];
    
    return _actionSheetItemArray;
}

- (NSMutableArray <CMActionButton *>*)actionSheetActionArray{
    
    if (!_actionSheetActionArray) _actionSheetActionArray = [NSMutableArray array];
    
    return _actionSheetActionArray;
}

@end

@interface LanYouAlertConfig ()

@end

@implementation LanYouAlertConfig

- (void)dealloc{
    
    _config = nil;
}

- (nonnull instancetype)init{
    self = [super init];
    
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        
        self.config.modelFinishConfig = ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (!strongSelf) return;
            
            if ([LanYouAlert shareManager].queueArray.count) {
                
                LanYouAlertConfig *last = [LanYouAlert shareManager].queueArray.lastObject;
                
                if (!strongSelf.config.modelIsQueue && last.config.modelQueuePriority > strongSelf.config.modelQueuePriority) return;
                
                if (!last.config.modelIsQueue && last.config.modelQueuePriority <= strongSelf.config.modelQueuePriority) [[LanYouAlert shareManager].queueArray removeObject:last];
                
                if (![[LanYouAlert shareManager].queueArray containsObject:strongSelf]) {
                    
                    [[LanYouAlert shareManager].queueArray addObject:strongSelf];
                    
                    [[LanYouAlert shareManager].queueArray sortUsingComparator:^NSComparisonResult(LanYouAlertConfig *configA, LanYouAlertConfig *configB) {
                        
                        return configA.config.modelQueuePriority > configB.config.modelQueuePriority ? NSOrderedDescending
                        : configA.config.modelQueuePriority == configB.config.modelQueuePriority ? NSOrderedSame : NSOrderedAscending;
                    }];
                    
                }
                
                if ([LanYouAlert shareManager].queueArray.lastObject == strongSelf) [strongSelf show];
                
            } else {
                
                [strongSelf show];
                
                [[LanYouAlert shareManager].queueArray addObject:strongSelf];
            }
            
        };
        
    }
    
    return self;
}

- (void)setType:(LanYouAlertType)type{
    
    _type = type;
    
    // 处理默认值
    
    switch (type) {
            
        case LanYouAlertTypeAlert:
        
            self.config
            .CMConfigMaxWidth(^CGFloat(CMScreenOrientationType type) {
            
                return 280.0f;
            })
            .CMConfigMaxHeight(^CGFloat(CMScreenOrientationType type) {
            
                return kScreenH - 40.0f - VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).bottom;
            })
            .CMOpenAnimationStyle(CMAnimationStyleOrientationNone | CMAnimationStyleFade | CMAnimationStyleZoomEnlarge)
            .CMCloseAnimationStyle(CMAnimationStyleOrientationNone | CMAnimationStyleFade | CMAnimationStyleZoomShrink);
        
            break;
            
        case CMAlertTypeActionSheet:{
            
        self.config
            .CMConfigMaxWidth(^CGFloat(CMScreenOrientationType type) {
                
                return type == CMScreenOrientationTypeHorizontal ? kScreenH - VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).bottom - 20.0f : kScreenW - VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).left - VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).right - 20.0f;
            })
            .CMConfigMaxHeight(^CGFloat(CMScreenOrientationType type) {
                
                return kScreenH - 40.0f - VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).top - (self.config.modelSafeAreaBottom == YES ? VIEWSAFEAREAINSETS([LanYouAlert getAlertWindow]).bottom : 0);
            })
            .CMOpenAnimationStyle(CMAnimationStyleOrientationBottom)
            .CMCloseAnimationStyle(CMAnimationStyleOrientationBottom);
    }
            break;
            
        default:
            break;
    }
    
}

- (void)show{
    
    switch (self.type) {
            
        case LanYouAlertTypeAlert:
        
            [LanYouAlert shareManager].viewController = [[LanYouAlertViewController alloc] init];
            
            break;
            
        case CMAlertTypeActionSheet:
        
            [LanYouAlert shareManager].viewController = [[LanYouActionSheetViewController alloc] init];
            
            break;
            
        default:
            break;
    }
    
    if (![LanYouAlert shareManager].viewController) return;
    
    [LanYouAlert shareManager].viewController.config = self.config;
    
    [LanYouAlert shareManager].cmWindow.rootViewController = [LanYouAlert shareManager].viewController;
    
    [LanYouAlert shareManager].cmWindow.windowLevel = self.config.modelWindowLevel;
    
    [LanYouAlert shareManager].cmWindow.hidden = NO;
    
    [[LanYouAlert shareManager].cmWindow makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    [LanYouAlert shareManager].viewController.openFinishBlock = ^{
        
    };
    
    [LanYouAlert shareManager].viewController.closeFinishBlock = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return;
        
        if ([LanYouAlert shareManager].queueArray.lastObject == strongSelf) {
            
            [LanYouAlert shareManager].cmWindow.hidden = YES;
            
            [[LanYouAlert shareManager].cmWindow resignKeyWindow];
            
            [LanYouAlert shareManager].cmWindow.rootViewController = nil;
            
            [LanYouAlert shareManager].viewController = nil;
            
            [[LanYouAlert shareManager].queueArray removeObject:strongSelf];
            
            if (strongSelf.config.modelIsContinueQueueDisplay) [LanYouAlert continueQueueDisplay];
            
        } else {
            
            [[LanYouAlert shareManager].queueArray removeObject:strongSelf];
        }
        
        if (strongSelf.config.modelCloseComplete) strongSelf.config.modelCloseComplete();
    };
    
}

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([LanYouAlert shareManager].viewController) [[LanYouAlert shareManager].viewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark - LazyLoading

- (LanYouAlertConfigModel *)config{
    
    if (!_config) _config = [[LanYouAlertConfigModel alloc] init];
    
    return _config;
}

@end
