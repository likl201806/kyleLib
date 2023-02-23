//
//  NSObject+LYDataConvertRule.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DeclarationProtocol <NSObject>
#pragma mark LYDataConvert相关
+(void)ly_inArrModelName;
+(void)ly_ignorePros;
+(void)ly_replaceProName;
+(NSString *)ly_replaceProName121:(NSString *)proName;
+(BOOL)isinIgnorePros:(NSString *)proStr;
#pragma mark LYDataStore相关
+ (NSDictionary *)ly_tbConfig;
@end
@interface NSObject (LYDataConvertRule)
+(NSDictionary *)getInArrModelNameDic;
+(NSDictionary *)getReplaceProNameDic;
+(NSString *)getReplacedProName:(NSString *)proName;
@end

NS_ASSUME_NONNULL_END
