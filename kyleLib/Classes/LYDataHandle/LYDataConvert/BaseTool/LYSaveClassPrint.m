//
//  LYClassPrint.m

#import "LYSaveClassPrint.h"
#import "NSObject+LYToJson.h"
@implementation LYSaveClassPrint
- (NSString *)description {
    return [self ly_toJsonStr];
}

@end
