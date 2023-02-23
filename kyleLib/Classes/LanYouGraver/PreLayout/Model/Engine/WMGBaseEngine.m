//
//  WMGBaseEngine.m
//
    

#import "WMGBaseEngine.h"
#import "WMGresultSet.h"
#import "WMGBusinessModel.h"

@implementation WMGBaseEngine

- (id)init{
    self = [super init];
    if (self) {
        _resultSet = [[WMGResultSet alloc] init];
        _loadState = WMGEngineLoadStateUnload;
    }
    
    return self;
}

- (void)reloadDataWithParams:(NSDictionary *)params completion:(WMGEngineLoadCompletion)completion{
    // override to subclass
}

- (void)loadMoreDataWithParams:(NSDictionary *)params completion:(WMGEngineLoadCompletion)completion{
    // override to subclass
}

- (void)insertDataWithParams:(NSDictionary *)params withIndex:(NSUInteger)insertIndex completion:(WMGEngineLoadCompletion)completion{
    // override to subclass
}

- (void)addItem:(WMGBusinessModel *)item{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

- (void)insertItem:(WMGBusinessModel *)item atIndex:(NSUInteger)index{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

- (void)deleteItem:(WMGBusinessModel *)item{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

- (void)deleteAllItems{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

@end
