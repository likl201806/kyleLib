//
//  NSData+LYDataConvert.m
//

#import "NSData+LYDataConvert.h"

@implementation NSData (LYDataConvert)
-(NSString *)ly_dataToJsonStr{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
@end
