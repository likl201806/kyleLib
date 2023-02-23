//
//  CMDSlideView.m
//

#import "CMDSlideView.h"
//#import "UIView+CMDCategory.h"
//#import "CMDBaseTableView.h"

#define kPanSwitchOffsetThreshold 50.0f

@interface CMDSlideView()

@property (nonatomic, strong) NSString *direct;
@property (nonatomic, assign) CGPoint startp;

@property (nonatomic, strong) NSString *canpan;

@end

@implementation CMDSlideView {
    NSInteger oldIndex_;
    NSInteger panToIndex_;
    UIPanGestureRecognizer *pan_;
    CGPoint panStartPoint_;
    
    UIViewController *oldCtrl_;
    UIViewController *willCtrl_;
    
    BOOL isSwitching_;
    BOOL isDrawing;
}

- (void)commonInit{
    self.canpan = @"YES";
    oldIndex_ = -1;
    isSwitching_ = NO;
    isDrawing = NO;
    self.isCanDrawing = YES;
    
    pan_ = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self addGestureRecognizer:pan_];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPan) name:@"stopCMDSlideViewPan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPan) name:@"startCMDSlideViewPan" object:nil];
}

-(void)stopPan{
    self.canpan = @"NO";
}

-(void)startPan{
    self.canpan = @"YES";
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addNotification];
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addNotification];
        [self commonInit];
    }
    return self;
}

- (NSInteger)selectedIndex{
    return oldIndex_;
}
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    //选择重复index，方法终止
//    if (selectedIndex == oldIndex_) {
//        return;
//    }
    
    [self switchTo:selectedIndex];
}

- (void)removeOld{
    [self removeCtrl:oldCtrl_];
    [oldCtrl_ endAppearanceTransition];
    oldCtrl_ = nil;
    oldIndex_ = -1;
}
- (void)removeWill{
    [willCtrl_ beginAppearanceTransition:NO animated:NO];
    [self removeCtrl:willCtrl_];
    [willCtrl_ endAppearanceTransition];
    willCtrl_ = nil;
    panToIndex_ = -1;
}
- (void)showAt:(NSInteger)index{
    //选择重复index，方法终止
//    if (index == oldIndex_) {
//        return;
//    }
    
    [self removeOld];
    
    UIViewController *vc = [self.dataSource CMDSlideView:self controllerAt:index];
    vc.view.frame = self.bounds;
    [self addSubview:vc.view];
    oldIndex_ = index;
    oldCtrl_ = vc;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CMDSlideView:didSwitchTo:)]) {
        [self.delegate CMDSlideView:self didSwitchTo:index];
    }
}

- (void)removeCtrl:(UIViewController *)ctrl{
    UIViewController *vc = ctrl;
    [vc.view removeFromSuperview];
}

- (void)switchTo:(NSInteger)index{
    //选择重复index，方法终止
//    if (index == oldIndex_) {
//        return;
//    }
    
    if (isDrawing) return;
    
    if (isSwitching_) {
        return;
    }

    if (oldCtrl_ != nil && oldCtrl_.parentViewController == self.baseViewController) {
        isSwitching_ = YES;
        UIViewController *oldvc = oldCtrl_;
        UIViewController *newvc = [self.dataSource CMDSlideView:self controllerAt:index];
        
        CGRect nowRect = oldvc.view.frame;
        CGRect leftRect = CGRectMake(nowRect.origin.x-nowRect.size.width, nowRect.origin.y, nowRect.size.width, nowRect.size.height);
        CGRect rightRect = CGRectMake(nowRect.origin.x+nowRect.size.width, nowRect.origin.y, nowRect.size.width, nowRect.size.height);
        
        CGRect newStartRect;
        CGRect oldEndRect;
        if (index > oldIndex_) {
            newStartRect = rightRect;
            oldEndRect = leftRect;
        }
        else{
            newStartRect = leftRect;
            oldEndRect = rightRect;
        }
        
        newvc.view.frame = newStartRect;
        
        [self.baseViewController transitionFromViewController:oldvc toViewController:newvc duration:0.4 options:0 animations:^{
            newvc.view.frame = nowRect;
            oldvc.view.frame = oldEndRect;
        } completion:^(BOOL finished) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(CMDSlideView:didSwitchTo:)]) {
                [self.delegate CMDSlideView:self didSwitchTo:index];
            }
            
            isSwitching_ = NO;
        }];
        
        oldIndex_ = index;
        oldCtrl_ = newvc;
    }
    else{
        [self showAt:index];
    }
    
    willCtrl_ = nil;
    panToIndex_ = -1;
}

- (void)repositionForOffsetX:(CGFloat)offsetx{
    float x = 0.0f;
    
    if (panToIndex_ < oldIndex_) {
        x = self.bounds.origin.x - self.bounds.size.width + offsetx;
    }
    else if(panToIndex_ > oldIndex_){
        x = self.bounds.origin.x + self.bounds.size.width + offsetx;
    }
    
    UIViewController *oldvc = oldCtrl_;
    oldvc.view.frame = CGRectMake(self.bounds.origin.x + offsetx, oldvc.view.frame.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    if (panToIndex_ >= 0 && panToIndex_ < [self.dataSource numberOfControllersInCMDSlideView:self]) {
        UIViewController *vc = willCtrl_;
        vc.view.frame = CGRectMake(x, vc.view.frame.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CMDSlideView:switchingFrom:to:percent:)]) {
        [self.delegate CMDSlideView:self switchingFrom:oldIndex_ to:panToIndex_ percent:fabs(offsetx)/self.bounds.size.width];
    }
}

- (void)backToOldWithOffset:(CGFloat)offsetx{
    NSTimeInterval animatedTime = 0;
    animatedTime = 0.3;
    isDrawing = NO;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self repositionForOffsetX:0];
    } completion:^(BOOL finished) {
        if (panToIndex_ >= 0 && panToIndex_ < [self.dataSource numberOfControllersInCMDSlideView:self] && panToIndex_ != oldIndex_) {
            [oldCtrl_ beginAppearanceTransition:YES animated:NO];
            [self removeWill];
            [oldCtrl_ endAppearanceTransition];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(CMDSlideView:switchCanceled:)]) {
            [self.delegate CMDSlideView:self switchCanceled:oldIndex_];
        }
    }];
}
- (void)panHandler:(UIPanGestureRecognizer *)pan{
    if (!self.isCanDrawing) return;
    if (oldIndex_ < 0) {
        return;
    }
    isDrawing = YES;
    CGPoint point = [pan translationInView:self];
    CGPoint curP = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        panStartPoint_ = point;
        self.startp = curP;
        [oldCtrl_ beginAppearanceTransition:NO animated:YES];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        if ([self.canpan isEqual:@"NO"]){
            return;
        }
        if (self.direct == nil || [self.direct isEqual:@""]){
            //防止上下两层view一起滑动
            if (fabs(curP.x-self.startp.x) > fabs(curP.y-self.startp.y)){
                self.direct = @"x";
            }else{
                self.direct = @"y";
            }
        }
        if (self.direct != nil && ![self.direct isEqual:@""]){
            if ([self.direct isEqual:@"x"]){ //横向
                [[NSNotificationCenter defaultCenter] postNotificationName:@"xDirectNotification" object:nil userInfo:@{@"status":@"changed"}];
            }else{ //纵向
                [[NSNotificationCenter defaultCenter] postNotificationName:@"yDirectNotification" object:nil userInfo:@{@"status":@"changed"}];
                return;
            }
        }
        
        
        NSInteger panToIndex = -1;
        float offsetx = point.x - panStartPoint_.x;
        
        if (offsetx > 0) {
            panToIndex = oldIndex_ - 1;
        }
        else if(offsetx < 0){
            panToIndex = oldIndex_ + 1;
        }
        
        // fix bug #5
        if (panToIndex != panToIndex_) {
            if (willCtrl_) {
                [self removeWill];
            }
        }
        
        if (panToIndex < 0 || panToIndex >= [self.dataSource numberOfControllersInCMDSlideView:self]) {
            panToIndex_ = panToIndex;
            [self repositionForOffsetX:offsetx/2.0f];
        }
        else{
            if (panToIndex != panToIndex_) {
                willCtrl_ = [self.dataSource CMDSlideView:self controllerAt:panToIndex];
                [willCtrl_ beginAppearanceTransition:YES animated:YES];
                [self addSubview:willCtrl_.view];

                panToIndex_ = panToIndex;
            }
            [self repositionForOffsetX:offsetx];
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded){
        if ([self.canpan isEqual:@"NO"]){
            return;
        }
        self.direct = @"";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xDirectNotification" object:nil userInfo:@{@"status":@"end"}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"yDirectNotification" object:nil userInfo:@{@"status":@"end"}];
        
        float offsetx = point.x - panStartPoint_.x;
        
        if (panToIndex_ >= 0 && panToIndex_ < [self.dataSource numberOfControllersInCMDSlideView:self] && panToIndex_ != oldIndex_) {
            if (fabs(offsetx) > kPanSwitchOffsetThreshold) {
                NSTimeInterval animatedTime = 0;
                animatedTime = fabs(self.frame.size.width - fabs(offsetx)) / self.frame.size.width * 0.4;
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView animateWithDuration:animatedTime animations:^{
                    [self repositionForOffsetX:offsetx > 0 ? self.bounds.size.width : -self.bounds.size.width];
                } completion:^(BOOL finished) {
                    [self removeOld];
                    
                    if (panToIndex_ >= 0 && panToIndex_ < [self.dataSource numberOfControllersInCMDSlideView:self]) {
                        [willCtrl_ endAppearanceTransition];
                        oldIndex_ = panToIndex_;
                        oldCtrl_ = willCtrl_;
                        willCtrl_ = nil;
                        panToIndex_ = -1;
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(CMDSlideView:didSwitchTo:)]) {
                        [self.delegate CMDSlideView:self didSwitchTo:oldIndex_];
                    }
                    isDrawing = NO;
                }];
            }
            else{
                [self backToOldWithOffset:offsetx];
            }
        }
        else{
            [self backToOldWithOffset:offsetx];
        }
    }
}

@end
