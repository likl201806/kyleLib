//
//  WMGBaseCell.h
//
    

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WMGBaseCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMGBaseCell : UITableViewCell

// 视图背景视图
@property (nonatomic, strong, nullable) UIView *bgView;

// cell视图分割线定义
@property (nonatomic, strong, nullable) UIView *separatorLine;

// 视图点击等的事件代理回调
@property (nonatomic, weak, nullable) id delegate;

// 视图展示的排版数据
@property (nonatomic, strong, readonly) WMGBaseCellData *cellData;

/**
 * 为视图设置排版数据
 *
 * @param cellData  视图排版数据
 *
 */
- (void)setupCellData:(WMGBaseCellData *)cellData;

@end

NS_ASSUME_NONNULL_END
