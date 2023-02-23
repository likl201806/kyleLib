//
//  CMStateView.h
//

#import <UIKit/UIKit.h>
#import "CMStatableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMStateView : UIView<CMStatableView>

@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailToIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailToTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBtnWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBtnHeightCons;

/// 状态
@property (nonatomic, assign) CMContentState state;
/// 回调
@property (nonatomic, copy) CMStateActionBlock actionCallback;

+ (instancetype)stateView;
+ (instancetype)stateViewWithAction:(CMStateActionBlock)actionCallback;
@end

NS_ASSUME_NONNULL_END
