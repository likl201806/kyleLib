//
//  NSString+LYDataConvert.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LYDataConvert)
///json转字典
-(id)ly_jsonToDic;
///下划线转驼峰
-(NSString *)strToHump;
///驼峰转下划线
-(NSString *)strToUnderLine;
@end

NS_ASSUME_NONNULL_END
