//
//  NSArray+LYDataConvert.h



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSArray (LYDataConvert)
///字典数组转json字符串
-(NSString *)ly_arrToJsonStr;
///字典数组转json字符串
-(NSString *)ly_arrToJsonStrWithOptions:(NSJSONWritingOptions)options;
///字典数组转jsonData
-(NSData *)ly_arrToJSONData;
///字典数组转jsonData
-(NSData *)ly_arrToJSONDataWithOptions:(NSJSONWritingOptions)options;
@end


