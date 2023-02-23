//
//  NSDictionary+LYSafetySet.m

#import "NSDictionary+LYSafetySet.h"

@implementation NSDictionary (LYSafetySet)
-(id)ly_dicSafetyReadForKey:(NSString *)key{
    id returnObj = nil;
    if([self.allKeys containsObject:key]){
        returnObj = [self valueForKey:key];
    }else{
        //LYDataHandleLog(@"字典Value获取失败，对象中不包含属性:%@",key);
    }
    return returnObj;
}
-(void)ly_dicSaftySetValue:(id)value forKey:(NSString *)key{
    [self setValue:value forKey:key];
}

@end
