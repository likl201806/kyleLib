//
//  WMGBaseCellData.m
//
    

#import "WMGBaseCellData.h"

@implementation WMGBaseCellData

- (Class)cellClass
{
    NSString *cell = [NSStringFromClass([self class]) substringWithRange:NSMakeRange(0, NSStringFromClass([self class]).length - 4)];
    return NSClassFromString(cell);
}

@end
