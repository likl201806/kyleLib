//
//  NSArray+LYDataConvert.m

#import "NSArray+LYDataConvert.h"
#import "LYDataHandleLog.h"
@implementation NSArray (LYDataConvert)
-(NSString *)ly_arrToJsonStr{
    NSData *jsonData = [self ly_arrToJSONData];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSString *)ly_arrToJsonStrWithOptions:(NSJSONWritingOptions)options{
    NSData *jsonData = [self ly_arrToJSONDataWithOptions:options];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSData *)ly_arrToJSONDataWithOptions:(NSJSONWritingOptions)options{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:options
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        LYDataHandleLog(@"数组%@无法转化为Json字符串--error:%@",self,error);
        return nil;
    }
}

-(NSData *)ly_arrToJSONData{
    return [self ly_arrToJSONDataWithOptions:NSJSONWritingPrettyPrinted];
}
@end
