//
//  WMGVisionObject.h
//
    

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN
/*
 视觉元素的抽象, 在Graver框架中，对所有视觉元素进行抽象，即每个视觉元素都由其位置、大小、内容唯一决定
 */
@interface WMGVisionObject : NSObject

// 视觉元素的位置、大小
@property (nonatomic, assign) CGRect frame;

// 视觉元素的展示内容，多数情况下，value即是WMMutableAttributedItem
@property (nonatomic, strong, nullable) id value;
@end

NS_ASSUME_NONNULL_END
