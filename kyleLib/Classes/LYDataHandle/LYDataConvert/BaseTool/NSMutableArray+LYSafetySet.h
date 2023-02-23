//
//  NSMutableArray+LYSafetySet.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (LYSafetySet)
-(id)ly_arrSafetyObjAtIndex:(NSUInteger)index;
-(void)ly_arrSafetyAddObj:(id)obj;
-(void)ly_arrSafetyAddObjNORepetition:(id)obj;
-(void)ly_arrSafetyRemoveObj:(id)obj;
@end

NS_ASSUME_NONNULL_END
