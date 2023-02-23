//
//  NSDictionary+LYDataConvert.m

#import "NSDictionary+LYDataConvert.h"
#import "LYDataHandleLog.h"
@implementation NSDictionary (LYDataConvert)

-(NSString *)ly_dicToJsonStrWithOptions:(NSJSONWritingOptions)options{
    NSData *jsonData = [self ly_dicToJSONDataWithOptions:options];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSString *)ly_dicToJsonStr{
    NSData *jsonData = [self ly_dicToJSONData];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSData *)ly_dicToJSONDataWithOptions:(NSJSONWritingOptions)options{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:options
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        LYDataHandleLog(@"字典%@无法转化为Json字符串--error:%@",self,error);
        return nil;
    }
}

-(NSData *)ly_dicToJSONData{
    return [self ly_dicToJSONDataWithOptions:NSJSONWritingPrettyPrinted];
}
@end
