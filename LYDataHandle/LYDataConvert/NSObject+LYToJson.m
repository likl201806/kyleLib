//
//  NSObject+LYToJson.m

#import "NSObject+LYToJson.h"
#import "NSDictionary+LYDataConvert.h"
#import "NSArray+LYDataConvert.h"
#import "NSData+LYDataConvert.h"
#import "LYSaveDataType.h"
#import "NSObject+LYToDic.h"
#import "NSDictionary+LYSafetySet.h"
#import "NSString+LYRegular.h"

@implementation NSObject (LYToJson)

-(NSString *)ly_toJsonStrWithOptions:(NSJSONWritingOptions)options{
    NSString *resJsonStr = nil;
    if([self isKindOfClass:[NSData class]]){
        return [((NSData *)self) ly_dataToJsonStr];
    }
    DataType dataType = [LYSaveDataType ly_dataType:self];
    if(dataType == DataTypeDic){
        resJsonStr = [((NSDictionary *)self) ly_dicToJsonStr];
    }else if(dataType == DataTypeArr){
        NSMutableArray *dicsArr = [NSMutableArray array];
        for (id subObj in (NSArray *)self) {
            DataType subDataType = [LYSaveDataType ly_dataType:subObj];
            if(!(subDataType == DataTypeDic)){
                id subDicObj = [subObj ly_toDic];
                [dicsArr addObject:subDicObj];
            }else{
                [dicsArr addObject:subObj];
            }
        }
        resJsonStr = [dicsArr ly_arrToJsonStrWithOptions:options];
    }else if(dataType == DataTypeStr){
        resJsonStr = (NSString *)self;
    }else{
        id resDic = [self ly_toDic];
        resJsonStr = [resDic ly_dicToJsonStrWithOptions:options];
    }
    return resJsonStr;
}

-(NSString *)ly_toJsonStr{
    return [self ly_toJsonStrWithOptions:NSJSONWritingPrettyPrinted];
}

-(NSString*)ly_kvStr{
    id res = [self ly_toDic];
    
    if([res isKindOfClass:[NSArray class]]){
        NSString *sumStr = @"";
        for (NSDictionary *subDic in res) {
            sumStr = [sumStr stringByAppendingString:[NSString stringWithFormat:@"%@&",[self perKvStrWithDic:subDic]]];
        }
        if(sumStr.length){
            sumStr = [sumStr substringToIndex:sumStr.length - 1];
        }
        return sumStr;
    }
    return [self perKvStrWithDic:(NSDictionary *)res];
}
-(NSString *)perKvStrWithDic:(NSDictionary *)resDic{
    NSArray *sortedKeys = [[resDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSString *sumStr = @"";
    for (NSString *key in sortedKeys) {
        NSObject *value = [resDic ly_dicSafetyReadForKey:key];
        if(value){
            NSString *valueStr = [NSString stringWithFormat:@"%@",value];
            valueStr = [valueStr removeAllElements:@[@"\r",@"\n",@"\t",@" "]];
            sumStr = [sumStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,valueStr]];
        }
    }
    sumStr = sumStr.length ? [sumStr substringToIndex:sumStr.length - 1] : sumStr;
    return sumStr;
}
-(NSData *)ly_toJsonDataWithOptions:(NSJSONWritingOptions)options{
    NSData *jsonData;
    if([self isKindOfClass:[NSData class]]){
        return (NSData *)self;
    }
    DataType dataType = [LYSaveDataType ly_dataType:self];
    if(dataType == DataTypeDic){
        jsonData = [((NSDictionary *)self) ly_dicToJSONDataWithOptions:options];
    }else if(dataType == DataTypeArr){
        id fObj = ((NSArray *)self).firstObject;
        if(fObj && [fObj isKindOfClass:[NSDictionary class]]){
            jsonData = [((NSArray *)self) ly_arrToJSONDataWithOptions:options];
        }else{
            jsonData = [[self ly_toJsonStr]dataUsingEncoding:NSUTF8StringEncoding];
        }
    }else if(dataType == DataTypeStr){
        jsonData = [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        jsonData = [[self ly_toJsonStr]dataUsingEncoding:NSUTF8StringEncoding];
    }
    return jsonData;
}
-(NSData *)ly_toJsonData{
    return [self ly_toJsonDataWithOptions:NSJSONWritingPrettyPrinted];
}
@end
