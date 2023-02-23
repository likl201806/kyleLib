//
//  NSObject+Graver.m
//
    

#import "NSObject+Graver.h"

@implementation NSObject (Graver)

- (id)wmg_objectWithAssociatedKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)wmg_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self, key, object, policy);
}

@end
