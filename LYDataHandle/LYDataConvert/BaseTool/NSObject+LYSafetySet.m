//
//  NSObject+LYSafetySet.m

#import "NSObject+LYSafetySet.h"
#import "NSObject+LYGetProperty.h"
#import "LYDataHandleLog.h"
#import "LYSaveDataConvert.h"
@implementation NSObject (LYSafetySet)
-(id)ly_objSafetyReadForKey:(NSString *)key{
    ///因为模型取值此时不存在找不到key的情况，因此直接返回
    return [self valueForKey:key];
    id returnObj = nil;
    NSArray *proNamesArr = [[self class] getAllPropertyNames];
    if([proNamesArr containsObject:key]){
        returnObj = [self valueForKey:key];
    }else{
        LYDataHandleLog(@"对象Value获取失败，对象中不包含属性:%@",key);
    }
    return returnObj;
}
-(void)ly_objSaftySetValue:(id)value forKey:(NSString *)key{
    if([LYSaveDataConvert shareInstance].ly_dataConvertSetterBlock){
        id resValue = [LYSaveDataConvert shareInstance].ly_dataConvertSetterBlock(key,value,self);
        value = resValue;
    }
    if(value && ![value isKindOfClass:[NSNull class]]){
        [self setValue:value forKey:key];
    }
}

@end
