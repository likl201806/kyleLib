//
//  WMGBaseCell.m
//
    

#import "WMGBaseCell.h"
#import "WMGraverMacroDefine.h"
@interface WMGBaseCell ()
@property (nonatomic, strong, readwrite) WMGBaseCellData *cellData;
@end

@implementation WMGBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = WMGHEXCOLOR(0xe4e4e4);
        [self.contentView addSubview:_separatorLine];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.accessibilityIdentifier = NSStringFromClass([self class]);
    }
    return self;
}

- (void)setupCellData:(WMGBaseCellData *)cellData{
    _bgView.frame = CGRectMake(0, 0, cellData.cellWidth, cellData.cellHeight);
    _separatorLine.hidden = (cellData.separatorStyle == WMGCellSeparatorLineStyleNone);
    [self.contentView bringSubviewToFront:_separatorLine];
    
    switch (cellData.separatorStyle) {
        case WMGCellSeparatorLineStyleLeftPadding:{
            _separatorLine.frame = CGRectMake(15, cellData.cellHeight - 1/[UIScreen mainScreen].scale, cellData.cellWidth - 15, 1/[UIScreen mainScreen].scale);
        }
            break;
        case WMGCellSeparatorLineStyleRightPadding:{
            _separatorLine.frame = CGRectMake(0, cellData.cellHeight - 1/[UIScreen mainScreen].scale, cellData.cellWidth - 15, 1/[UIScreen mainScreen].scale);
        }
            break;
        case WMGCellSeparatorLineStyleNonePadding:{
            _separatorLine.frame = CGRectMake(0, cellData.cellHeight - 1/[UIScreen mainScreen].scale, cellData.cellWidth, 1/[UIScreen mainScreen].scale);
        }
            break;
            
        default:
            break;
    }
    
    _cellData = cellData;
}

@end
