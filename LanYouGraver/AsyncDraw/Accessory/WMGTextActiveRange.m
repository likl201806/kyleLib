//
//  WMGTextActiveRange.m
//
    

#import "WMGTextActiveRange.h"

@implementation WMGTextActiveRange
@synthesize type = _type, range = _range, text = _text, bindingData = _bindingData;

+ (instancetype)activeRange:(NSRange)range type:(WMGActiveRangeType)type text:(NSString *)text
{
    WMGTextActiveRange *r = [[WMGTextActiveRange alloc] init];
    r.range = range;
    r.type = type;
    r.text = text;
    
    return r;
}

@end
