//
//  WMGTextLayout+Coordinate.m
//
    

#import "WMGTextLayout+Coordinate.h"

@implementation WMGTextLayout (Coordinate)

- (CGPoint)wmg_CTPointFromUIPoint:(CGPoint)point
{
    point.y = self.size.height - point.y;
    return point;
}

- (CGPoint)wmg_UIPointFromCTPoint:(CGPoint)point
{
    point.y = self.size.height - point.y;
    return point;
}

- (CGRect)wmg_CTRectFromUIRect:(CGRect)rect
{
    rect.origin = [self wmg_CTPointFromUIPoint:rect.origin];
    rect.origin.y -= rect.size.height;
    return rect;
}

- (CGRect)wmg_UIRectFromCTRect:(CGRect)rect
{
    rect.origin = [self wmg_UIPointFromCTPoint:rect.origin];
    rect.origin.y -= rect.size.height;
    return rect;
}

@end
