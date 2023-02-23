//
//  CMDSlideTabbarItemArgs.m
//

#import "CMDSlideTabbarItemArgs.h"
#import "LanYouDiscoverCommon.h"

@interface CMDSlideTabbarItemArgs()

@property (nonatomic, copy) NSString *title;
/**  按钮图片数组  */
@property (nonatomic, strong) UIImage *normalImage;
/**  选中时候的图片  */
@property (nonatomic, strong) UIImage *selectImage;

@end

@implementation CMDSlideTabbarItemArgs

+ (instancetype)argsWithTitle:(NSString *)title
                  normalImage:(UIImage * _Nullable)normalImage
                  selectImage:(UIImage * _Nullable)selectImage {
    CMDSlideTabbarItemArgs *request = [[CMDSlideTabbarItemArgs alloc] init];
    request.title = title;
    request.normalImage = normalImage;
    request.selectImage = selectImage;
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleNormalColor = [UIColor blackColor];
        self.titleSelectColor = [UIColor redColor];
        
        self.normalBgColor = [UIColor clearColor];
        self.selectBgColor = [UIColor clearColor];
        
        self.titleNormalFont = kCMDFont(15.0);
        self.titleSelectFont = kCMDFont(15.0);
    }
    return self;
}

@end
