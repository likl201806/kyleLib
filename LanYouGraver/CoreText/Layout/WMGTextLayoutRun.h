//
//  WMGTextLayoutRun.h
//
    

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@protocol WMGAttachment;

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextLayoutRun : NSObject

/**
 * 根据文本组件创建一个CTRunDelegateRef，即CoreText可以识别的一个占位
 *
 * @param att WMGAttachment
 *
 */
+ (CTRunDelegateRef)textLayoutRunWithAttachment:(id <WMGAttachment>)att;

@end

NS_ASSUME_NONNULL_END
