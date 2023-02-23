//
//  LYDecimalNumberTool.m

#import "LYDecimalNumberTool.h"

@implementation LYDecimalNumberTool
+ (float)ly_toFloatWithNumber:(double)num{
    return [[self ly_decimalNumber:num] floatValue];
}

+ (double)ly_toDoubleWithNumber:(double)num {
    return [[self ly_decimalNumber:num] doubleValue];
}

+ (NSString *)ly_toStringWithNumber:(double)num {
    return [[self ly_decimalNumber:num] stringValue];
}

+ (NSDecimalNumber *)ly_decimalNumber:(double)num {
    NSString *numString = [NSString stringWithFormat:@"%lf", num];
    return [NSDecimalNumber decimalNumberWithString:numString];
}

+ (NSDecimalNumber *)ly_decimalNumberWithStr:(NSString *)str {
    return [NSDecimalNumber decimalNumberWithString:str];
}
@end
