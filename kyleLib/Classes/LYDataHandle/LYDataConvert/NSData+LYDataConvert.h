//
//  NSData+LYDataConvert.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LYDataConvert)
///data转json字符串
-(NSString *)ly_dataToJsonStr;
@end

NS_ASSUME_NONNULL_END
