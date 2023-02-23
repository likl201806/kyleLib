//
//  CMDSlideTabbarItem.m
//

#import "CMDSlideTabbarItem.h"
#import "LanYouDiscoverCommon.h"

@interface CMDSlideTabbarItem()

/** 文字的默认的size */
@property (nonatomic, assign) CGSize titleNormalSize;

/** 文字的选中的size */
@property (nonatomic, assign) CGSize titleSelectSize;

@end

@implementation CMDSlideTabbarItem

+ (instancetype)itemWithArgs:(CMDSlideTabbarItemArgs *)args {
    CMDSlideTabbarItem *item = [[CMDSlideTabbarItem alloc] initWithFrame:CGRectZero args:args];
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame args:(CMDSlideTabbarItemArgs *)args {
    self = [super initWithFrame:frame];
    if (self) {
        self.args = args;
        
        self.userInteractionEnabled = YES;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kCMDFont(15.0);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = args.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *iconV = [[UIImageView alloc] init];
        iconV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:iconV];
        self.iconV = iconV;
    }
    return self;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.titleLabel.font = isSelect ? self.args.titleSelectFont : self.args.titleNormalFont;
    self.titleLabel.textColor = isSelect ? self.args.titleSelectColor : self.args.titleNormalColor;
    self.iconV.image = isSelect ? self.args.selectImage : self.args.normalImage;
    self.backgroundColor = isSelect ? self.args.selectBgColor : self.args.normalBgColor;
    
    [self layoutSubviews];
}

#pragma mark: <================ 系统方法 ================>
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleNormalSize = [self.args.title boundingRectWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: self.args.titleNormalFont} context:nil].size;
    
    self.titleSelectSize = [self.args.title boundingRectWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: self.args.titleSelectFont} context:nil].size;
    
    CGFloat contentW = 0;
    BOOL haveImg = NO;
    
    CGFloat titleLabelW = self.isSelect ? self.titleSelectSize.width : self.titleNormalSize.width;
    CGFloat titleLabelH = self.frame.size.height;
    
    CGFloat iconVW = 0;
    CGFloat iconTitleMargin = 0;
    if (self.isSelect == YES){
        if (self.args.selectImage){
            iconVW = 22;
            iconTitleMargin = 7.5;
            haveImg = YES;
        }
    }else{
        if (self.args.normalImage){
            iconVW = 22;
            iconTitleMargin = 7.5;
            haveImg = YES;
        }
    }
    
    contentW = iconVW+iconTitleMargin+titleLabelW;
    
    self.iconV.frame = CGRectMake(self.frame.size.width / 2 - contentW / 2, 0.5*(self.bounds.size.height-iconVW), iconVW, iconVW);
    if (haveImg == YES){
        self.titleLabel.frame = CGRectMake(self.frame.size.width / 2 - contentW / 2 + iconVW + iconTitleMargin, 0, titleLabelW, titleLabelH);
    }else{
        self.titleLabel.frame = CGRectMake(self.frame.size.width / 2 - titleLabelW / 2, 0, titleLabelW, titleLabelH);
    }
}

@end
