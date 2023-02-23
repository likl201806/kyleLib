//
//  NSDictionary+LYDataConvert.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (LYDataConvert)
///字典转json字符串
-(NSString *)ly_dicToJsonStr;
///字典转json字符串
-(NSString *)ly_dicToJsonStrWithOptions:(NSJSONWritingOptions)options;
///字典转jsonData
-(NSData *)ly_dicToJSONData;
///字典转jsonData
-(NSData *)ly_dicToJSONDataWithOptions:(NSJSONWritingOptions)options;
@end

NS_ASSUME_NONNULL_END
