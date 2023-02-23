//
//  NSObject+LYToModel.m

#import "NSObject+LYToModel.h"
#import "LYSaveDataType.h"
#import "LYSaveDataConvert.h"
#import "NSObject+LYGetProperty.h"
#import "LYDecimalNumberTool.h"
#import "NSString+LYDataConvert.h"
#import "NSObject+LYSafetySet.h"
#import "NSObject+LYDataConvertRule.h"
#import "NSDictionary+LYSafetySet.h"
#import "NSString+LYRegular.h"
#import "NSObject+LYToJson.h"
#import "NSObject+LYToDic.h"
@implementation NSObject (LYToModel)
+(instancetype)ly_modelWithDic:(NSMutableDictionary *)dic{
    if([LYSaveDataType isFoudationClass:self]){
        return nil;
    }
    Class selfCalss = [self class];
    id modelObj = [[selfCalss alloc]init];
    [self getEnumPropertyNamesCallBack:^(NSString *proName,NSString *proType) {
        NSString *dicKeyProName = [self getReplacedProName:proName];
        id value = [dic ly_dicSafetyReadForKey:dicKeyProName];
        BOOL isinIgnorePros = [[self class] isinIgnorePros:proName];
        if(value != NULL && !isinIgnorePros){
            DataType dataType = [LYSaveDataType ly_dataType:value];
            if(dataType == DataTypeDic){
                NSArray *proTypeArr = [proType componentsSeparatedByString:@","];
                if(proTypeArr.count > 0){
                    NSString *subClassStr = proTypeArr[0];
                    subClassStr = [subClassStr matchStrWithPre:@"\"" sub:@"\""];
                    Class subClass = NSClassFromString(subClassStr);
                    if(subClass){
                        id subModel = [subClass ly_modelWithDic:value];
                        if(subModel){
                            [modelObj ly_objSaftySetValue:subModel forKey:proName];
                        }else{
                            [modelObj ly_objSaftySetValue:value forKey:proName];
                        }
                    }else{
                        id subModel = nil;
                        NSDictionary *inArrModelNameDic = [self getInArrModelNameDic];
                        if(inArrModelNameDic){
                            NSString *subClassStr = [inArrModelNameDic ly_dicSafetyReadForKey:proName];
                            if(subClassStr.length){
                                if(subClassStr){
                                    Class subClass = NSClassFromString(subClassStr);
                                    if(subClass){
                                        subModel = [[subClass class] ly_modelWithDic:value];
                                        
                                    }
                                }
                            }
                        }
                        [modelObj ly_objSaftySetValue:subModel ? subModel :value forKey:proName];
                    }
                }
            }else if(dataType == DataTypeArr){
                NSMutableArray *subMuArr = [NSMutableArray array];
                for (id subObj in value) {
                    DataType subDataType = [LYSaveDataType ly_dataType:subObj];
                    if(subDataType == DataTypeDic){
                        NSDictionary *inArrModelNameDic = [self getInArrModelNameDic];
                        if(inArrModelNameDic){
                            NSString *subClassStr = [inArrModelNameDic ly_dicSafetyReadForKey:proName];
                            if(subClassStr.length){
                                id subModel = subObj;
                                if(subClassStr){
                                    Class subClass = NSClassFromString(subClassStr);
                                    if(subClass){
                                        subModel = [[subClass class] ly_modelWithDic:subObj];
                                    }
                                }
                                [subMuArr addObject:subModel];
                            }else{
                                [subMuArr addObject:subObj];
                            }
                        }else{
                            [subMuArr addObject:subObj];
                        }
                        
                    }else if(subDataType == DataTypeArr){
                        id subModel = [[subObj class] ly_modelWithArr:subObj];
                        [subMuArr addObject:subModel];
                    }else{
                        [subMuArr addObject:subObj];
                    }
                    
                }
                [modelObj ly_objSaftySetValue:subMuArr forKey:proName];
            }else{
                if(dataType == DataTypeNormalObj || dataType == DataTypeStr){
                    if([proType hasPrefix:@"T@\"NSNumber\""]){
                        if(dataType == DataTypeStr && [LYSaveDataType isNumberType:value]){
                            value = [LYDecimalNumberTool ly_decimalNumber:[value doubleValue]];
                            
                            [modelObj ly_objSaftySetValue:@([value doubleValue]) forKey:proName];
                        }else{
                            [modelObj ly_objSaftySetValue:value forKey:proName];
                        }
                        
                    }else if([proType hasPrefix:@"T@"]){
                        value = [LYSaveDataConvert handleValueToMatchModelPropertyTypeWithValue:value type:proType];
                        [modelObj ly_objSaftySetValue:value forKey:proName];
                    }else{
                        value = [LYDecimalNumberTool ly_decimalNumber:[value doubleValue]];
                        [modelObj ly_objSaftySetValue:value forKey:proName];
                    }
                }else{
                    if(dataType == DataTypeFloat || dataType == DataTypeDouble || dataType == DataTypeInt || dataType == DataTypeBool || dataType == DataTypeLong){
                        value = [LYDecimalNumberTool ly_decimalNumber:[value doubleValue]];
                    }
                    value = [LYSaveDataConvert handleValueToMatchModelPropertyTypeWithValue:value type:proType];
                    [modelObj ly_objSaftySetValue:value forKey:proName];
                }
            }
        }
    }];
    return modelObj;
}
+(instancetype)ly_modelWithArr:(NSMutableArray *)arr{
    NSMutableArray *resArr = [NSMutableArray array];
    for (id subObj in arr) {
        DataType subDataType = [LYSaveDataType ly_dataType:subObj];
        id resObj = nil;
        if(subDataType == DataTypeDic){
            resObj = [self ly_modelWithDic:subObj];
        }
        if(subDataType == DataTypeArr){
            resObj = [self ly_modelWithArr:subObj];
        }
        if(resObj){
            [resArr addObject:resObj];
        }
    }
    return resArr;
}
+(id)ly_modelWithObj:(id)obj{
    DataType subDataType = [LYSaveDataType ly_dataType:obj];
    id resObj = nil;
    if([self isKindOfClass:[NSData class]]){
        NSString *jsonStr = [self ly_toJsonStr];
        return [self ly_modelWithObj:jsonStr];
    }
    if(subDataType == DataTypeStr){
        NSString *jsonStr = (NSString *)obj;
        id dicObj = [jsonStr ly_toDic];
        DataType subJsonDataType = [LYSaveDataType ly_dataType:dicObj];
        if(subJsonDataType == DataTypeDic){
            resObj = [self ly_modelWithDic:dicObj];
        }
        if(subJsonDataType == DataTypeArr){
            resObj = [self ly_modelWithArr:dicObj];
        }
    }else{
        if(subDataType == DataTypeDic){
            resObj = [self ly_modelWithDic:obj];
        }
        if(subDataType == DataTypeArr){
            resObj = [self ly_modelWithArr:obj];
        }
    }
    return resObj;
}


+(NSDictionary *)ly_inArrModelName{
    return nil;
}

+(NSDictionary *)ly_replaceProName{
    return nil;
}

+(NSString *)ly_replaceProName121:(NSString *)proName{
    return nil;
}

@end
