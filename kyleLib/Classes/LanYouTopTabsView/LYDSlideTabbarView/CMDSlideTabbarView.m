//
//  CMDSlideTabbarView.m
//

#import "CMDSlideTabbarView.h"
#import "CMDUtility.h"

@interface CMDSlideTabbarView()

/** 容器View */
@property (nonatomic, strong) UIScrollView *containerView;
/** item数组 */
@property (nonatomic, strong)  NSMutableArray <CMDSlideTabbarItem *>*items;

/** 是否正在移动 正在移动的时候，按钮不能点击 */
@property (nonatomic, assign) BOOL isMoving;

@end

@implementation CMDSlideTabbarView

-(UIScrollView *)containerView{
    if (_containerView == nil){
        _containerView = [[UIScrollView alloc] init];
        _containerView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.scrollsToTop = false;
        [_containerView addSubview:self.moveView];
    }
    return _containerView;
}

-(UIImageView *)moveView{
    if (_moveView == nil){
        _moveView = [[UIImageView alloc] init];
        _moveView.backgroundColor = [UIColor clearColor];
    }
    return _moveView;
}

- (instancetype)initWithFrame:(CGRect)frame
                        argss:(NSArray <CMDSlideTabbarItemArgs *>*)argss {
    self = [super initWithFrame:frame];
    if (self) {
        _originX = 12;
        _moveViewSize = CGSizeMake(0, 3);
        _moveViewMarginToBottom = 12;
        [self addSubview:self.containerView];
        [self setItemsData:argss];
    }
    return self;
}



-(void)setItemsData:(NSArray <CMDSlideTabbarItemArgs *>*)argss{
    self.items = @[].mutableCopy;
    for (int i = 0; i < argss.count; i ++) {
        CMDSlideTabbarItemArgs *args = argss[i];
        CMDSlideTabbarItem *item = [CMDSlideTabbarItem itemWithArgs:args];
        item.isSelect = (i == _selectedIndex);
        item.tag = i;
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)]];
        [_containerView addSubview:item];
        [self.items addObject:item];
    }
}

-(void)reloadSlideViewData:(NSArray <CMDSlideTabbarItemArgs *>*)argss{
    //先删除原来的
    if (_containerView.subviews.count > 0){
        for (UIView *item in _containerView.subviews){
            [item removeFromSuperview];
        }
    }
    if (_items.count > 0){
        [_items removeAllObjects];
    }
    //将moveView添加至containerView
    [self.containerView addSubview:self.moveView];
    //增加刷新后的
    [self setItemsData:argss];
    [self layoutSubviews];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.isMoving = NO;
    if (_selectedIndex == selectedIndex) return;
    if (_selectedIndex >= self.items.count || selectedIndex >= self.items.count) return;
    
    self.items[selectedIndex].isSelect = YES;
    self.items[_selectedIndex].isSelect = NO;
    [self configMoveViewFrameWithProgress:1.0 fromIndex:_selectedIndex toIndex:selectedIndex];
    _selectedIndex = selectedIndex;
}

- (void)setMoveViewSize:(CGSize)moveViewSize {
    _moveViewSize = moveViewSize;
}

- (void)setMoveViewColor:(UIColor *)moveViewColor {
    _moveViewColor = moveViewColor;
    self.moveView.backgroundColor = moveViewColor;
}

/// 更新UI，oldTag
- (void)onResetUIFrameWithFromTag:(NSInteger)fromTag toTag:(NSInteger)toTag isAnim:(BOOL)isAnim {
    
    CMDSlideTabbarItem *oldItem = self.items[fromTag];
    CMDSlideTabbarItem *currentItem = self.items[toTag];
    
    currentItem.isSelect = YES;
    oldItem.isSelect = NO;
    
    [self containerScrollToCenterWidthToTag:toTag];
    
    // 调整bottomLine
    if (self.moveView.hidden == NO) {
        [UIView animateWithDuration:(isAnim ? 0.25 : 0.0) animations:^{
            CGRect moveViewR = self.moveView.frame;
            moveViewR.origin.x = currentItem.frame.origin.x;
            moveViewR.size.width = currentItem.frame.size.width;
            self.moveView.frame = moveViewR;
        } completion:nil];
    }
}

- (void)containerScrollToCenterWidthToTag:(NSInteger)toTag {
    
    if (self.containerView.contentSize.width <= self.frame.size.width) {
        return;
    }
    
    // 1.获取获取目标的Label
    CMDSlideTabbarItem *item = self.items[toTag];
    
    // 2.计算和中间位置的偏移量
    CGFloat offSetX = item.center.x - self.frame.size.width * 0.5;
    if (offSetX < 0) offSetX = 0;
    
    CGFloat maxOffset = self.containerView.contentSize.width - self.frame.size.width;
    if (offSetX > maxOffset) offSetX = maxOffset;
    
    // 3.滚动UIScrollView
    [self.containerView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

#pragma mark: <---------- CMDSlideTabbarProtocol ---------->
- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent {
    self.isMoving = YES;
    if (self.isCloseAutoChange) return;
    
    if (toIndex >= 0 && toIndex < self.items.count) {
        
        CMDSlideTabbarItem *fromItem = self.items[fromIndex];
        CMDSlideTabbarItem *toItem = self.items[toIndex];
        
        fromItem.titleLabel.textColor = [CMDUtility getColorOfPercent:percent between:fromItem.args.titleNormalColor and:fromItem.args.titleSelectColor];
        toItem.titleLabel.textColor = [CMDUtility getColorOfPercent:percent between:toItem.args.titleSelectColor and:toItem.args.titleNormalColor];

        [self configMoveViewFrameWithProgress:percent fromIndex:fromIndex toIndex:toIndex];
    }
}

- (void)configMoveViewFrameWithProgress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    CMDSlideTabbarItem *fromItem = self.items[fromIndex];
    CMDSlideTabbarItem *toItem = self.items[toIndex];
    
    CGFloat moveViewH =  self.moveViewSize.height;
    CGFloat moveViewY = self.frame.size.height - moveViewH - self.moveViewMarginToBottom;
    
    CGFloat fromMoveViewW = 0;
    if (self.moveViewSize.width == 0) {
        fromMoveViewW = fromItem.titleLabel.frame.size.width;
    } else if (self.moveViewSize.width == 1) {
        fromMoveViewW = fromItem.frame.size.width;
    } else {
        fromMoveViewW = self.moveViewSize.width;
    }
    CGFloat moveViewFromX = fromItem.frame.origin.x + (fromItem.frame.size.width - fromMoveViewW) / 2;
    
    if (fromIndex == toIndex) {
        self.moveView.frame = CGRectMake(moveViewFromX, moveViewY, fromMoveViewW, moveViewH);
    } else {
        
        CGFloat toMoveViewW = 0;
        if (self.moveViewSize.width == 0) {
            toMoveViewW = toItem.titleLabel.frame.size.width;
        } else if (self.moveViewSize.width == 1) {
            toMoveViewW = toItem.frame.size.width;
        } else {
            toMoveViewW = self.moveViewSize.width;
        }

        CGFloat moveViewToX = toItem.frame.origin.x + (toItem.frame.size.width - toMoveViewW) / 2;
        if (progress >= 1) {
            [UIView animateWithDuration:0.15 animations:^{
                self.moveView.frame = CGRectMake(moveViewToX, moveViewY, toMoveViewW, moveViewH);
            }];
        } else {
            self.moveView.frame = CGRectMake((moveViewFromX + (moveViewToX - moveViewFromX) * progress), moveViewY, fromMoveViewW + (toMoveViewW - fromMoveViewW) * progress, moveViewH);
        }
    }
    
    if (progress >= 1) {
        [self containerScrollToCenterWidthToTag:toIndex];
    }
}

#pragma mark: <================ 系统方法 ================>
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat height = self.frame.size.height;

    self.containerView.frame = self.bounds;

    CGFloat itemY = 0;
    CGFloat itemH = height;
    CGFloat curItemX = 0;
    for (int i = 0; i < self.items.count; i ++) {
        CMDSlideTabbarItem *item = self.items[i];
        CGFloat itemW = item.args.itemWidth;
        item.frame = CGRectMake(_originX+curItemX, itemY, itemW, itemH);
        curItemX += itemW;
    }

    self.containerView.contentSize = CGSizeMake(CGRectGetMaxX(self.items.lastObject.frame), 0);
    
    // 计算moveView的frame
    [self configMoveViewFrameWithProgress:1.0 fromIndex:self.selectedIndex toIndex:self.selectedIndex];
}

#pragma mark: <---------- 点击事件 ---------->
- (void)itemClick:(UITapGestureRecognizer *)tapGes {
    if (self.isMoving) {
        return;
    }

    NSInteger itemTag = tapGes.view.tag;
    // 1.点击相同的item就返回
    if (self.selectedIndex == itemTag) return;
    
    // 3.切换文字的颜色
    self.items[itemTag].isSelect = YES;
    self.items[_selectedIndex].isSelect = NO;
    // 更新UI布局
    [self configMoveViewFrameWithProgress:1.0 fromIndex:_selectedIndex toIndex:itemTag];

    _selectedIndex = itemTag;

    self.isMoving = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(CMDSlideTabbar:selectAt:)]) {
        [_delegate CMDSlideTabbar:self selectAt:itemTag];
    }
}

@end
