//
//  WMGAsyncDrawLayer.m
//
    

#import "WMGAsyncDrawLayer.h"

@implementation WMGAsyncDrawLayer

- (void)increaseDrawingCount
{
    _drawingCount = (_drawingCount + 1) % 10000;
}

- (void)setNeedsDisplay
{
    [self increaseDrawingCount];
    [super setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)r
{
    [self increaseDrawingCount];
    [super setNeedsDisplayInRect:r];
}

- (BOOL)isAsyncDrawsCurrentContent
{
    switch (_drawingPolicy)
    {
        case WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged:
            return _contentsChangedAfterLastAsyncDrawing;
        case WMGViewDrawingPolicyAsynchronouslyDraw:
            return YES;
        case WMGViewDrawingPolicySynchronouslyDraw:
        default:
            return NO;
    }
}


@end
