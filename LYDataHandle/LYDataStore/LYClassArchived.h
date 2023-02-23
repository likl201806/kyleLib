//
//  LYClassArchived.h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define LYClassArchivedImplementation \
-(void)encodeWithCoder:(NSCoder *)enCoder{\
u_int count;\
objc_property_t *properties  = class_copyPropertyList([self class],&count);\
for(int i = 0;i < count;i++){\
    const char *propertyNameChar = property_getName(properties[i]);\
    NSString *propertyNameStr = [NSString stringWithUTF8String: propertyNameChar];\
    if([enCoder respondsToSelector:@selector(encodeObject:forKey:)]){\
        id obj = [self valueForKeyPath:propertyNameStr];\
        if([obj respondsToSelector:@selector(encodeWithCoder:)]){\
            [enCoder encodeObject:obj forKey:propertyNameStr];\
        }\
        \
    }\
\
}\
free(properties);\
\
}\
-(id)initWithCoder:(NSCoder *)decoder{\
    if(self = [super init]){\
        u_int count;\
        objc_property_t *properties  = class_copyPropertyList([self class],&count);\
        for(int i = 0;i < count;i++){\
            const char *propertyNameChar = property_getName(properties[i]);\
            NSString *propertyNameStr = [NSString stringWithUTF8String: propertyNameChar];\
            if([decoder respondsToSelector:@selector(decodeObjectForKey:)]){\
                id obj = [decoder decodeObjectForKey:propertyNameStr];\
                if([obj respondsToSelector:@selector(initWithCoder:)]){\
                    [self setValue:obj forKeyPath:propertyNameStr];\
                }\
            }\
        }\
        free(properties);\
    }\
    return  self;\
}

NS_ASSUME_NONNULL_BEGIN

@interface LYClassArchived : NSObject <NSCoding>
-(void)encodeWithCoder:(NSCoder *)enCoder;
-(id)initWithCoder:(NSCoder *)decoder;
@end

NS_ASSUME_NONNULL_END
