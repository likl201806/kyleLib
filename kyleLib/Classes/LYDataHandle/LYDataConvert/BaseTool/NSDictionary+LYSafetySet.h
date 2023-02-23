//
//  NSDictionary+LYSafetySet.h

#import <Foundation/Foundation.h>

@interface NSDictionary (LYSafetySet)
-(id)ly_dicSafetyReadForKey:(NSString *)key;
-(void)ly_dicSaftySetValue:(id)value forKey:(NSString *)key;
@end
