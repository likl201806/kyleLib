//
//  NSObject+LYDataConvertRule.m

#import "NSObject+LYDataConvertRule.h"
#import "NSDictionary+LYSafetySet.h"
@implementation NSObject (LYDataConvertRule)
+(NSDictionary *)getInArrModelNameDic{
    if([self respondsToSelector:@selector(ly_inArrModelName)]){
        NSDictionary *inArrModelNameDic = [self performSelector:@selector(ly_inArrModelName)];
        return inArrModelNameDic;
    }
    return nil;
}
+(NSDictionary *)getReplaceProNameDic{
    if([self respondsToSelector:@selector(ly_replaceProName)]){
        NSDictionary *replaceProNameDic = [self performSelector:@selector(ly_replaceProName)];
        return replaceProNameDic;
    }
    return nil;
}
+(NSString *)getReplacedProName:(NSString *)proName{
    NSDictionary *replaceProNameDic = [self getReplaceProNameDic];
    if(replaceProNameDic){
        NSString *repKey = [replaceProNameDic ly_dicSafetyReadForKey:proName];
        if(repKey.length){
            return repKey;
        }
    }
    if([self respondsToSelector:@selector(ly_replaceProName121:)]){
        NSString *replacedProStr = [self performSelector:@selector(ly_replaceProName121:) withObject:proName];
        if(replacedProStr.length){
            return replacedProStr;
        }
    }
    return proName;
}

+(NSArray *)getIgnorePros{
    if([self respondsToSelector:@selector(ly_ignorePros)]){
        NSArray *ignorePros = [self performSelector:@selector(ly_ignorePros)];
        return ignorePros;
    }
    return nil;
}

+(BOOL)isinIgnorePros:(NSString *)proStr{
    NSArray *ignoreProsArr = [self getIgnorePros];
    if(!ignoreProsArr.count){
        return NO;
    }
    return [ignoreProsArr containsObject:proStr];
}
@end
