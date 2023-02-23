//
//  WMGTextDrawer+Coordinate.m
//
    

#import "WMGTextDrawer+Coordinate.h"

@implementation WMGTextDrawer (Coordinate)

- (CGPoint)convertPointFromLayout:(CGPoint)point offsetPoint:(CGPoint)offsetPoint
{
    point.x += offsetPoint.x;
    point.y += offsetPoint.y;
    return point;
}

- (CGPoint)convertPointToLayout:(CGPoint)point offsetPoint:(CGPoint)offsetPoint
{
    point.x -= offsetPoint.x;
    point.y -= offsetPoint.y;
    return point;
}

- (CGRect)convertRectFromLayout:(CGRect)rect offsetPoint:(CGPoint)offsetPoint
{
    if (CGRectIsNull(rect)) {
        return rect;
    }
    
    rect.origin = [self convertPointFromLayout:rect.origin offsetPoint:offsetPoint];
    return rect;
}

- (CGRect)convertRectToLayout:(CGRect)rect offsetPoint:(CGPoint)offsetPoint
{
    if (CGRectIsNull(rect)) {
        return rect;
    }
    
    rect.origin = [self convertPointToLayout:rect.origin offsetPoint:offsetPoint];
    return rect;
}

@end
