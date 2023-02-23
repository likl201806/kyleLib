//
//  NSObject+LYToModel.h
//  model赋值

#import <Foundation/Foundation.h>

@interface NSObject (LYToModel)
///字典转模型
+(instancetype)ly_modelWithDic:(NSMutableDictionary *)dic;
///任意类型转模型
+(id)ly_modelWithObj:(id)obj;

+(NSDictionary *)ly_inArrModelName;
+(NSDictionary *)ly_replaceProName;
+(NSString *)ly_replaceProName121:(NSString *)proName;
@end
