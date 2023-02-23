//
//  LYDataConvert.m

#import "LYSaveDataConvert.h"
#import "LYDecimalNumberTool.h"
#import "LYSaveDataType.h"
@implementation LYSaveDataConvert
+ (instancetype)shareInstance{
    static LYSaveDataConvert * s_instance_dj_singleton = nil ;
    if (s_instance_dj_singleton == nil) {
        s_instance_dj_singleton = [[LYSaveDataConvert alloc] init];
    }
    return (LYSaveDataConvert *)s_instance_dj_singleton;
}
- (NSMutableDictionary *)allPropertyDic{
    if(_allPropertyDic){
        _allPropertyDic = [NSMutableDictionary dictionary];
    }
    return _allPropertyDic;
}

+ (id)handleValueToMatchModelPropertyTypeWithValue:(id)value type:(NSString *)proType{
    LYDataValueAutoConvertMode dataValueAutoConvertMode = [LYSaveDataConvert shareInstance].ly_dataConvertConfig.ly_dataValueAutoConvertMode;
    if([proType hasPrefix:@"T@\"NSString\""]){
        if([value isKindOfClass:[NSString class]]){
            return value;
        }
        if([value isKindOfClass:[NSNumber class]]){
            return [NSString stringWithFormat:@"%@",value];
        }
        switch (dataValueAutoConvertMode) {
            case LYDataValueAutoConvertModeEmpty:{
                return @"";
                break;
            }
            case LYDataValueAutoConvertModeNil:{
                return nil;
                break;
            }
            case LYDataValueAutoConvertModeOrg:{
                return value;
                break;
            }
            default:
                break;
        }
        return nil;
    }
    if([proType hasPrefix:@"T@\"NSArray\""]){
        if([value isKindOfClass:[NSArray class]]){
            return value;
        }
        switch (dataValueAutoConvertMode) {
            case LYDataValueAutoConvertModeEmpty:{
                return @[];
                break;
            }
            case LYDataValueAutoConvertModeNil:{
                return nil;
                break;
            }
            case LYDataValueAutoConvertModeOrg:{
                return value;
                break;
            }
            default:
                break;
        }
        return nil;
    }
    if([proType hasPrefix:@"T@\"NSMutableArray\""]){
        if([value isKindOfClass:[NSArray class]]){
            return [NSMutableArray arrayWithArray:value];
        }
        switch (dataValueAutoConvertMode) {
            case LYDataValueAutoConvertModeEmpty:{
                return [NSMutableArray array];
                break;
            }
            case LYDataValueAutoConvertModeNil:{
                return nil;
                break;
            }
            case LYDataValueAutoConvertModeOrg:{
                return value;
                break;
            }
            default:
                break;
        }
        return nil;
    }
    if([proType hasPrefix:@"T@"]){
        NSRange typeRange = [proType rangeOfString:@"\".*?\"" options:NSRegularExpressionSearch];
        if(typeRange.location != NSNotFound){
            NSString *resTypeStr = [proType substringWithRange:typeRange];
            resTypeStr = [resTypeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            Class cls = NSClassFromString(resTypeStr);
            if(cls && [value isKindOfClass:cls]){
                return value;
            }
            switch (dataValueAutoConvertMode) {
                case LYDataValueAutoConvertModeEmpty:{
                    if(cls){
                        return [cls new];
                    }
                    break;
                }
                case LYDataValueAutoConvertModeNil:{
                    return nil;
                    break;
                }
                case LYDataValueAutoConvertModeOrg:{
                    return value;
                    break;
                }
                default:
                    break;
            }
            return nil;
        }
        
    }
    if([value isKindOfClass:[NSString class]]){
        BOOL isNumberType = [LYSaveDataType isNumberType:value];
        if(isNumberType){
            if(![proType hasPrefix:@"T@"]){
                if([proType hasPrefix:@"TB"]||
                   [proType hasPrefix:@"Tc"]||
                   [proType hasPrefix:@"Tl"]||
                   [proType hasPrefix:@"Tq"]||
                   [proType hasPrefix:@"TC"]||
                   [proType hasPrefix:@"TI"]||
                   [proType hasPrefix:@"TS"]||
                   [proType hasPrefix:@"TL"]||
                   [proType hasPrefix:@"TQ"]||
                   [proType hasPrefix:@"Tf"]||
                   [proType hasPrefix:@"Td"]){
                   return [LYDecimalNumberTool ly_decimalNumberWithStr:value];
                }
            }
        }
    }
    return value;
}

- (LYDataConvertConfig *)ly_dataConvertConfig{
    if(!_ly_dataConvertConfig){
        _ly_dataConvertConfig = [[LYDataConvertConfig alloc]init];
    }
    return _ly_dataConvertConfig;
}

@end
