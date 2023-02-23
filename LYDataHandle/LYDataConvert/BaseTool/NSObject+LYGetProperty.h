//
//  NSObject+LYGetProperty.h

#import <Foundation/Foundation.h>
typedef void(^kEnumEventHandler) (NSString *proName,NSString *proType);
@interface NSObject (LYGetProperty)
+(void)getEnumPropertyNamesCallBack:(kEnumEventHandler)_result;
+(NSMutableArray *)getAllPropertyNames;
@end
