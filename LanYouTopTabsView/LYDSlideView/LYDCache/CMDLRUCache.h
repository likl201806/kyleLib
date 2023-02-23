//
//  CMDLRUCache.h
//

#import <Foundation/Foundation.h>
#import "CMDCacheProtocol.h"

@interface CMDLRUCache : NSObject<CMDCacheProtocol>

- (id)initWithCount:(NSInteger)count;

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
@end
