//
//  WMGTextActiveRange.h
//
    

#import <Foundation/Foundation.h>
#import "WMGActiveRange.h"

@interface WMGTextActiveRange : NSObject<WMGActiveRange>

/**
 * 创建一个激活区，框架内部使用
 *
 * @param range 激活区对应的range
 * @param type 激活区类型
 * @param text 如果是非WMGActiveRangeTypeAttachment类型的指定才有意义
 *
 * @return 激活区
 */
+ (instancetype)activeRange:(NSRange)range type:(WMGActiveRangeType)type text:(NSString *)text;

@end
