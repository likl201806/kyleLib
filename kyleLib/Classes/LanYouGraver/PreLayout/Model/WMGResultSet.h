//
//  WMGResultSet.h
//
    

#import <Foundation/Foundation.h>

@class WMGBusinessModel;

NS_ASSUME_NONNULL_BEGIN

@interface WMGResultSet : NSObject

// 列表业务数据
@property (nonatomic, readonly) NSMutableArray <NSMutableArray <WMGBusinessModel *> *> *items;

// 当涉及分页机制时，其代表总页数
@property (nonatomic, assign) NSUInteger pageSize;

// 表示当前处于第几页
@property (nonatomic, assign) NSUInteger currentPage;

// 表示是否还有分页数据, 通常情况下  hasMore = (currentPage = pageSize - 1)
@property (nonatomic, assign) BOOL hasMore;

/**
 * 重置所有业务数据，一般情况下由预排版内部负责调用
 *
 */
- (void)reset;

/**
 * 添加一条数据，一般情况下由engine负责调用
 *
 * @param item 一条业务数据
 *
 */
- (void)addItem:(WMGBusinessModel *)item;

/**
 * 添加一批业务数据，一般情况下由WMGBaseViewModel负责调用
 *
 * @param items  业务数据
 *
 */
- (void)addItems:(NSArray <WMGBusinessModel *> *)items;

/**
 * 删除一条业务数据
 *
 * @param item  业务数据
 *
 */
- (void)deleteItem:(WMGBusinessModel *)item;
@end

NS_ASSUME_NONNULL_END
