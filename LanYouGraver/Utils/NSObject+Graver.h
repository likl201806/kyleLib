//
//  NSObject+Graver.h
//
    

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Graver)
/**
 * 根据指定可以获取对象关联的一个属性
 *
 * @param key 关联对象的key
 *
 * @return key对应的关联对象
 */
- (id)wmg_objectWithAssociatedKey:(void *)key;

/**
 * 给一个对象按照指定策略关联一个对象
 *
 * @param object 待关联对象
 * @param key 关联对象指定的key
 * @param policy 关联策略
 *
 */
- (void)wmg_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy;

@end

NS_ASSUME_NONNULL_END
