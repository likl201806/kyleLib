//
//  CMStateView.m
//

#import "CMStateView.h"
//#import <LanYouProjectModule/LanYouHeader.h>


@interface CMStateView ()
/// 图标集合
@property (nonatomic, strong) NSMutableDictionary *icons;
/// 标题集合
@property (nonatomic, strong) NSMutableDictionary *titles;
/// 详情集合
@property (nonatomic, strong) NSMutableDictionary *details;
/// 按钮标题集合
@property (nonatomic, strong) NSMutableDictionary *actions;
/// 富文本标题集合
@property (nonatomic, strong) NSMutableDictionary *attributedTitles;
/// 富文本详情集合
@property (nonatomic, strong) NSMutableDictionary *attributedDetails;
/// 富文本按钮标题集合
@property (nonatomic, strong) NSMutableDictionary *attributedActions;

@end

@implementation CMStateView

+ (instancetype)stateView {
    CMStateView *stateView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    [stateView defaultConfig];
    return stateView;
}

+ (instancetype)stateViewWithAction:(CMStateActionBlock)actionCallback {
    CMStateView *stateView = [CMStateView stateView];
    stateView.actionCallback = actionCallback;
    return stateView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.actionBtn.layer.cornerRadius = CGRectGetHeight(self.actionBtn.frame) * 0.5;
}

- (void)onSkinChange {
    [self setState:_state];
}

- (NSMutableDictionary *)icons {
    if (_icons == nil) {
        _icons = [[NSMutableDictionary alloc] init];
    }
    return _icons;
}

- (NSMutableDictionary *)titles {
    if (_titles == nil) {
        _titles = [[NSMutableDictionary alloc] init];
    }
    return _titles;
}

- (NSMutableDictionary *)details {
    if (_details == nil) {
        _details = [[NSMutableDictionary alloc] init];
    }
    return _details;
}

- (NSMutableDictionary *)actions {
    if (_actions == nil) {
        _actions = [[NSMutableDictionary alloc] init];
    }
    return _actions;
}

- (NSMutableDictionary *)attributedTitles {
    if (_attributedTitles == nil) {
        _attributedTitles = [[NSMutableDictionary alloc] init];
    }
    return _attributedTitles;
}

- (NSMutableDictionary *)attributedDetails {
    if (_attributedDetails == nil) {
        _attributedDetails = [[NSMutableDictionary alloc] init];
    }
    return _attributedDetails;
}

- (NSMutableDictionary *)attributedActions {
    if (_attributedActions == nil) {
        _attributedActions = [[NSMutableDictionary alloc] init];
    }
    return _attributedActions;
}

- (void)defaultConfig {
    UIImage *errorImage = [UIImage imageNamed:@"icon_cotnent_load_fail"];
    [self setIcon:errorImage forState:CMContentStateError];
    
    UIImage *failImage = [UIImage imageNamed:@"icon_cotnent_load_fail"];
    [self setIcon:failImage forState:CMContentStateLoadFail];
    self.iconImageView.image = self.icons[@(self.state)];
    
    [self setTitle:@"亲，网络不给力哦" forState:CMContentStateError];
    [self setDetail:@"请检查网络设置或点击刷新进行重试" forState:CMContentStateError];
    [self setAction:@"刷新" forState:CMContentStateError];
    
    [self setTitle:@"亲，加载内容失败了哦" forState:CMContentStateLoadFail];
    [self setDetail:@"请点击刷新进行重试或稍后再试" forState:CMContentStateLoadFail];
    [self setAction:@"刷新" forState:CMContentStateLoadFail];

}

- (IBAction)tapRefresh:(id)sender {
    if (self.actionCallback) {
        self.actionCallback(sender);
    }
}

/// 设置标题
/// @param title 标题
/// @param state 状态
- (void)setTitle:(NSString *)title forState:(CMContentState)state {
    self.titles[@(state)] = title;
}

/// 设置详情
/// @param detail 详情
/// @param state 状态
- (void)setDetail:(NSString *)detail forState:(CMContentState)state {
    self.details[@(state)] = detail;
}

/// 设置按钮标题
/// @param action 按钮
/// @param state 状态
- (void)setAction:(NSString *)action forState:(CMContentState)state {
    self.actions[@(state)] = action;
}

/// 设置按钮标题
/// @param icon 按钮
/// @param state 状态
- (void)setIcon:(UIImage *)icon forState:(CMContentState)state {
    self.icons[@(state)] = icon;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle forState:(UIControlState)state {
    self.attributedTitles[@(state)] = attributedTitle;
}

- (void)setAttributedDetail:(NSAttributedString *)attributedDetail forState:(UIControlState)state {
    self.attributedDetails[@(state)] = attributedDetail;
}

- (void)setAttributedAction:(NSAttributedString *)attributedAction forState:(UIControlState)state {
    self.attributedActions[@(state)] = attributedAction;
}

- (void)setState:(CMContentState)state {
    _state = state;
    
    // 隐藏状态
    if (CMContentStateHide == state) {
        self.hidden = YES;
        return;
    }
    
    // 非隐藏状态
    self.hidden = NO;
    
    //设置图标
    self.iconImageView.image = self.icons[@(state)];
    
    //设置标题
    NSString *title = self.titles[@(state)];
    self.titleLab.text = title;
    
    NSAttributedString *attributedTitle = self.attributedTitles[@(state)];
    if (attributedTitle != nil || title == nil) {
        self.titleLab.attributedText = attributedTitle;
    }
    
    //详情
    NSString *detail = self.details[@(state)];
    self.detailLab.text = detail;
    
    NSAttributedString *attributedDetail = self.attributedDetails[@(state)];
    if (attributedDetail != nil || detail == nil) {
        self.detailLab.attributedText = attributedDetail;
    }
    
    //设置标题
    NSString *action = self.actions[@(state)];
    [self.actionBtn setTitle:action forState:UIControlStateNormal];
    
    NSAttributedString *attributedAction = self.attributedActions[@(state)];
    if (attributedAction != nil || action == nil) {
        [self.actionBtn setAttributedTitle:attributedAction forState:UIControlStateNormal];
    }
    
    self.actionBtn.hidden = (action == nil && attributedAction == nil);
    
    //设置约束优先级，当标题为空时，详情距离icon约束优先更高
    self.detailToIcon.priority = title == nil ? 750: 250;
    self.detailToTitle.priority = title == nil ? 250: 750;
}
@end
