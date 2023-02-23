//
//  CMDCacheProtocol.h
//

#import <Foundation/Foundation.h>

@protocol CMDCacheProtocol <NSObject>
- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end
