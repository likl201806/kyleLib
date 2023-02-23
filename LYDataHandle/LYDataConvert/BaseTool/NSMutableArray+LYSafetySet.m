//
//  NSMutableArray+LYSafetySet.m

#import "NSMutableArray+LYSafetySet.h"
#import "LYDataHandleLog.h"
@implementation NSMutableArray (LYSafetySet)
-(id)ly_arrSafetyObjAtIndex:(NSUInteger)index{
    if(index < self.count){
        return [self objectAtIndex:index];
    }else{
        LYDataHandleLog(@"数组：%@的索引%lu不存在",self,(unsigned long)index);
        return nil;
    }
}
-(void)ly_arrSafetyAddObj:(id)obj{
    if(obj){
        [self addObject:obj];
    }else{
        LYDataHandleLog(@"加入数组的对象不存在");
    }
}
-(void)ly_arrSafetyAddObjNORepetition:(id)obj{
    if(![self containsObject:obj]){
        [self ly_arrSafetyAddObj:obj];
    }
}

-(void)ly_arrSafetyRemoveObj:(id)obj{
    if([self containsObject:obj]){
        [self removeObject:obj];
    }
}
@end
