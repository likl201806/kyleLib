//
//  WMGMixedView.h
//
    

#import "WMGCanvasControl.h"
#import "WMMutableAttributedItem.h"

typedef NS_ENUM(NSUInteger, WMGTextVerticalAlignment) {
    WMGTextVerticalAlignmentTop,
    WMGTextVerticalAlignmentCenter,
    WMGTextVerticalAlignmentBottom,
    WMGTextVerticalAlignmentCenterCompatibility,
};

typedef NS_ENUM(NSUInteger, WMGTextHorizontalAlignment) {
    WMGTextHorizontalAlignmentLeft,
    WMGTextHorizontalAlignmentCenter,
    WMGTextHorizontalAlignmentRight,
};

@interface WMGMixedView : WMGCanvasControl

// 水平对齐方式
@property (nonatomic, assign) WMGTextHorizontalAlignment horizontalAlignment;

// 垂直对齐方式
@property (nonatomic, assign) WMGTextVerticalAlignment verticalAlignment;

// 行数，default is 0
@property (nonatomic, assign) NSUInteger numerOfLines;

// 待绘制内容
@property (nonatomic, strong) WMMutableAttributedItem *attributedItem;

@end
