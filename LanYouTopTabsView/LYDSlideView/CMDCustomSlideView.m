//
//  CMDCustomSlideView.m
//

#import "CMDCustomSlideView.h"

#define kDefaultTabbarBottomSpacing 0
#define kDefaultCacheCount 4

@implementation CMDCustomSlideView {
    CMDSlideView *slideView_;
}

- (void)commonInit{
    self.tabbarBottomSpacing = kDefaultTabbarBottomSpacing;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)setup{
    self.tabbar.delegate = self;
    [self addSubview:self.tabbar];
    
    slideView_ = [[CMDSlideView alloc] initWithFrame:CGRectMake(0, self.tabbar.frame.size.height+self.tabbarBottomSpacing, self.bounds.size.width, self.bounds.size.height-self.tabbar.frame.size.height-self.tabbarBottomSpacing)];
    slideView_.delegate = self;
    slideView_.dataSource = self;
    slideView_.baseViewController = self.baseViewController;
    [self addSubview:slideView_];
}

-(void)reloadSlideData{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutBarAndSlide];
}

#pragma mark - 内部方法
- (void)layoutBarAndSlide{
    self.tabbar.frame = CGRectMake(self.tabbar.frame.origin.x, self.tabbar.frame.origin.y, CGRectGetWidth(self.tabbar.bounds), self.tabbar.frame.size.height);
    slideView_.frame = CGRectMake(0, self.tabbar.frame.size.height+self.tabbarBottomSpacing, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-self.tabbar.frame.size.height-self.tabbarBottomSpacing);
}

- (void)setBaseViewController:(UIViewController *)baseViewController{
    slideView_.baseViewController = baseViewController;
    _baseViewController = baseViewController;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [slideView_ setSelectedIndex:selectedIndex];
    [self.tabbar setSelectedIndex:selectedIndex];
}

- (void)CMDSlideTabbar:(id)sender selectAt:(NSInteger)index{
    [slideView_ setSelectedIndex:index];
}

- (NSInteger)numberOfControllersInCMDSlideView:(CMDSlideView *)sender{
    return [self.delegate numberOfTabsInCMDCustomSlideView:self];
}

- (UIViewController *)CMDSlideView:(CMDSlideView *)sender controllerAt:(NSInteger)index{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)index];
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    else{
        UIViewController *ctrl = [self.delegate CMDCustomSlideView:self controllerAt:index];
        [self.cache setObject:ctrl forKey:key];
        return ctrl;
    }
}

- (void)CMDSlideView:(CMDSlideView *)slide switchingFrom:(NSInteger)oldIndex to:(NSInteger)toIndex percent:(float)percent{
    [self.tabbar switchingFrom:oldIndex to:toIndex percent:percent];
}
- (void)CMDSlideView:(CMDSlideView *)slide didSwitchTo:(NSInteger)index{
    _selectedIndex = index;
    [self.tabbar setSelectedIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CMDCustomSlideView:didSelectedAt:)]) {
        [self.delegate CMDCustomSlideView:self didSelectedAt:index];
    }
}
- (void)CMDSlideView:(CMDSlideView *)slide switchCanceled:(NSInteger)oldIndex{
    [self.tabbar setSelectedIndex:oldIndex];
}

@end
