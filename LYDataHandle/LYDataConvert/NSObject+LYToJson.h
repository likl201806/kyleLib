//
//  NSObject+LYToJson.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LYToJson)
///任意类型转Json字符串
-(NSString *)ly_toJsonStr;
///任意类型转Json字符串
-(NSString *)ly_toJsonStrWithOptions:(NSJSONWritingOptions)options;
///任意类型转keyValue的形式：name=123&dec=test
-(NSString*)ly_kvStr;
///任意类型转JsonData
-(NSData *)ly_toJsonData;
///任意类型转JsonData
-(NSData *)ly_toJsonDataWithOptions:(NSJSONWritingOptions)options;
@end

NS_ASSUME_NONNULL_END
