//
//  WMGFontMetrics.m
//
    

#import "WMGFontMetrics.h"

const WMGFontMetrics WMGFontMetricsZero = {0, 0, 0};
const WMGFontMetrics WMGFontMetricsNull = {NSNotFound, NSNotFound, NSNotFound};

static WMGFontMetrics WMGCachedFontMetrics[13];

WMGFontMetrics WMGFontDefaultMetrics(NSInteger pointSize)
{
    if (pointSize < 8 || pointSize > 20)
    {
        UIFont *font = [UIFont systemFontOfSize:pointSize];
        return WMGFontMetricsMakeFromUIFont(font);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            for (NSInteger i = 0; i < 13; i++) {
                NSUInteger pointSize = i + 8;
                UIFont * font = [UIFont systemFontOfSize:pointSize];
                WMGCachedFontMetrics[i] = WMGFontMetricsMakeFromUIFont(font);
            }
        }
    });
    
    return WMGCachedFontMetrics[pointSize - 8];
}

