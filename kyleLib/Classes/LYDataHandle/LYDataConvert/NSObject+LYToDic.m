//
//  NSObject+LYToDic.m

#import "NSObject+LYToDic.h"
#import "LYSaveDataType.h"
#import "NSObject+LYGetProperty.h"
#import "NSObject+LYSafetySet.h"
#import "NSObject+LYDataConvertRule.h"
#import "NSString+LYDataConvert.h"
#import "NSObject+LYToJson.h"
#import "NSDictionary+LYSafetySet.h"
@implementation NSObject (LYToDic)
-(id)ly_toDic{
    DataType dataType = [LYSaveDataType ly_dataType:self];
    if(dataType == DataTypeDic){
        return self;
    }
    if(dataType == DataTypeStr){
        return [((NSString *)self)ly_jsonToDic];
    }
    if(dataType == DataTypeArr){
        NSArray *objArr = [self mutableCopy];
        NSMutableArray *resObjArr = [NSMutableArray array];
        for (id subObj in objArr) {
            id resSubObj = [subObj ly_toDic];
            [resObjArr addObject:resSubObj];
        }
        return resObjArr;
    }else{
        return [self ly_singleObjToDic];
    }
    
}
-(NSDictionary *)ly_singleObjToDic{
    if([self isKindOfClass:[NSData class]]){
        NSString *jsonStr = [self ly_toJsonStr];
        return [jsonStr ly_toDic];
    }
    if([LYSaveDataType isFoudationClass:self]){
        return @{};
    }
    NSMutableDictionary *resDic = [NSMutableDictionary dictionary];
    [[self class] getEnumPropertyNamesCallBack:^(NSString *proName, NSString *proType) {
        id value = [self ly_objSafetyReadForKey:proName];
        proName = [[self class] getReplacedProName:proName];
        BOOL isinIgnorePros = [[self class] isinIgnorePros:proName];
        DataType dataType = [LYSaveDataType ly_dataType:value];
        if(value != NULL && !isinIgnorePros){
            if(dataType == DataTypeStr || [value isKindOfClass:[NSNumber class]]){
                
            }else if(dataType == DataTypeArr){
                NSArray *valueArr = (NSArray *)value;
                NSMutableArray *resValueArr = [NSMutableArray array];
                for (id subObj in valueArr) {
                    DataType dataType = [LYSaveDataType ly_dataType:subObj];
                    id resSubObj = subObj;
                    if(!(dataType == DataTypeStr || [value isKindOfClass:[NSNumber class]])){
                        resSubObj = [subObj ly_toDic];
                    }
                    [resValueArr addObject:resSubObj];
                }
                value = [resValueArr mutableCopy];
            }else{
                value = [value ly_toDic];
            }
            [resDic ly_dicSaftySetValue:value forKey:proName];
        }
    }];
    return resDic;
}

@end
