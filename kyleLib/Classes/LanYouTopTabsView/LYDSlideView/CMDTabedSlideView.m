//
//  CMDTabedSlideView.m
//

#import "CMDTabedSlideView.h"
#import "CMDFixedTabbarView.h"
#import "CMDSlideView.h"
#import "CMDLRUCache.h"

#define kDefaultTabbarHeight 34
#define kDefaultTabbarBottomSpacing 0
#define kDefaultCacheCount 4

@implementation CMDTabedbarItem
+ (CMDTabedbarItem *)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    CMDTabedbarItem *item = [[CMDTabedbarItem alloc] init];
    item.title = title;
    item.image = image;
    item.selectedImage = selectedImage;
    
    return item;
}

@end

@interface CMDTabedSlideView()<CMDSlideViewDelegate, CMDSlideViewDataSource> {
    CMDSlideView *slideView_;
    CMDFixedTabbarView *tabbar_;
    CMDLRUCache *ctrlCache_;
}

@end

@implementation CMDTabedSlideView

- (void)commonInit{
    self.tabbarHeight = kDefaultTabbarHeight;
    self.tabbarBottomSpacing = kDefaultTabbarBottomSpacing;
    
    tabbar_ = [[CMDFixedTabbarView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.tabbarHeight)];
    tabbar_.delegate = self;
    [self addSubview:tabbar_];

    slideView_ = [[CMDSlideView alloc] init];
    slideView_.frame = CGRectMake(0, self.tabbarHeight+self.tabbarBottomSpacing, self.bounds.size.width, self.bounds.size.height-self.tabbarHeight-self.tabbarBottomSpacing);
    slideView_.delegate = self;
    slideView_.dataSource = self;
    [self addSubview:slideView_];
    
    ctrlCache_ = [[CMDLRUCache alloc] initWithCount:4];
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

-(void)reloadTabbarData{
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutBarAndSlide];
}

- (void)setIsCanDrawing:(BOOL)isCanDrawing {
    _isCanDrawing = isCanDrawing;
    slideView_.isCanDrawing = isCanDrawing;
}

- (void)layoutBarAndSlide{
    UIView *barView = (UIView *)tabbar_;
    barView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.tabbarHeight);
    slideView_.frame = CGRectMake(0, self.tabbarHeight+self.tabbarBottomSpacing, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-self.tabbarHeight-self.tabbarBottomSpacing);

}

- (void)buildTabbar{
    NSMutableArray *tabbarItems = [NSMutableArray array];
    for (CMDTabedbarItem *item in self.tabbarItems) {
        CMDFixedTabbarViewTabItem *barItem = [[CMDFixedTabbarViewTabItem alloc] init];
        barItem.title = item.title;
        barItem.titleColor = self.tabItemNormalColor;
        barItem.selectedTitleColor = self.tabItemSelectedColor;
        barItem.image = item.image;
        barItem.selectedImage = item.selectedImage;
        
        [tabbarItems addObject:barItem];
    }
    
    tabbar_.tabbarItems = tabbarItems;
    tabbar_.trackColor = self.tabbarTrackColor;
    tabbar_.backgroundImage = self.tabbarBackgroundImage;

}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [slideView_ setSelectedIndex:selectedIndex];
    [tabbar_ setSelectedIndex:selectedIndex];
}

- (void)CMDSlideTabbar:(id)sender selectAt:(NSInteger)index{
    [slideView_ setSelectedIndex:index];
}

- (NSInteger)numberOfControllersInCMDSlideView:(CMDSlideView *)sender{
    return [self.delegate numberOfTabsInCMDTabedSlideView:self];
}

- (UIViewController *)CMDSlideView:(CMDSlideView *)sender controllerAt:(NSInteger)index{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)index];
    if ([ctrlCache_ objectForKey:key]) {
        return [ctrlCache_ objectForKey:key];
    }
    else{
        UIViewController *ctrl = [self.delegate CMDTabedSlideView:self controllerAt:index];
        [ctrlCache_ setObject:ctrl forKey:key];
        return ctrl;
    }
}

- (void)CMDSlideView:(CMDSlideView *)slide switchingFrom:(NSInteger)oldIndex to:(NSInteger)toIndex percent:(float)percent{
    [tabbar_ switchingFrom:oldIndex to:toIndex percent:percent];
    //NSLog(@"oldIndex == %zd, to == %zd", oldIndex, toIndex);
    if (toIndex > 0 && toIndex < self.tabbarItems.count &&_delegate && [_delegate respondsToSelector:@selector(CMDTabedSlideView:movingWithProgress:isToLeft:)]) {
        [_delegate CMDTabedSlideView:self movingWithProgress:percent isToLeft:(oldIndex < toIndex)];
    }
}
- (void)CMDSlideView:(CMDSlideView *)slide didSwitchTo:(NSInteger)index{
    _selectedIndex = index;

    [tabbar_ setSelectedIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CMDTabedSlideView:didSelectedAt:)]) {
        [self.delegate CMDTabedSlideView:self didSelectedAt:index];
    }
}
- (void)CMDSlideView:(CMDSlideView *)slide switchCanceled:(NSInteger)oldIndex{
    [tabbar_ setSelectedIndex:oldIndex];
}

@end
