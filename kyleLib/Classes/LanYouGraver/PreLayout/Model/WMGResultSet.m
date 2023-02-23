//
//  WMGResultSet.m
//
    

#import "WMGResultSet.h"
#import "WMGraverMacroDefine.h"

@interface WMGResultSet ()
@property (nonatomic, strong, readwrite) NSMutableArray <NSMutableArray <WMGBusinessModel *> *> *items;
@end

@implementation WMGResultSet

- (id)init{
    self = [super init];
    
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)reset{
    _hasMore = NO;
    _pageSize = 0;
    _currentPage = 0;
    [_items removeAllObjects];
}

- (void)addItem:(id)item{
    if (item) {
        [_items addObject:item];
    }
}

- (void)addItems:(NSArray *)items{
    if (!IsArrEmpty(items)) {
        [_items addObjectsFromArray:items];
    }
}

- (void)deleteItem:(id)item{
    if (item) {
        [_items removeObject:item];
    }
}

@end
