//
//  LYDecimalNumberTool.h
//  精度处理

#import <Foundation/Foundation.h>

@interface LYDecimalNumberTool : NSObject
///利用DecimalNumber将double转为float
+ (float)ly_toFloatWithNumber:(double)num;
///利用DecimalNumber将double转为double
+ (double)ly_toDoubleWithNumber:(double)num;
///利用DecimalNumber将double转为string
+ (NSString *)ly_toStringWithNumber:(double)num;
///利用DecimalNumber将double转为NSDecimalNumber
+ (NSDecimalNumber *)ly_decimalNumber:(double)num;
///利用DecimalNumber将str转为NSDecimalNumber
+ (NSDecimalNumber *)ly_decimalNumberWithStr:(NSString *)str;
@end
