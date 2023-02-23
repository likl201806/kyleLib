//
//  LYSQLResult.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYSQLResult : NSObject
@property(nonatomic,assign)BOOL success;
@property(nonatomic,strong)NSArray *resData;
@property(nonatomic,assign)char *error;
@end

NS_ASSUME_NONNULL_END
