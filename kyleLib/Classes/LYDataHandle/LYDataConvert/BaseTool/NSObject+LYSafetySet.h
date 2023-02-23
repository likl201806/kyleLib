//
//  NSObject+LYSafetySet.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LYSafetySet)
-(id)ly_objSafetyReadForKey:(NSString *)key;
-(void)ly_objSaftySetValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
