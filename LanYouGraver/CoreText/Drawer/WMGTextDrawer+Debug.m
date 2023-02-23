//
//  WMGTextDrawer+Debug.m
//
    

#import "WMGTextDrawer+Debug.h"
#import <UIKit/UIKit.h>
#import "WMGTextDrawer+Coordinate.h"
#import "WMGTextDrawer+Private.h"
#import "WMGTextLayoutFrame.h"
#import "WMGTextLayoutLine.h"

static BOOL WMGTextDrawerDebugModeEnabled = NO;

@implementation WMGTextDrawer (Debug)

+ (void)debugModeSetEverythingNeedsDisplayForView:(UIView *)view
{
    [view setNeedsDisplay];
    
    if ([view respondsToSelector:@selector(displayLayer:)])
    {
        [view displayLayer:view.layer];
    }
    
    for (UIView * subview in view.subviews)
    {
        [self debugModeSetEverythingNeedsDisplayForView:subview];
    }
}

+ (void)debugModeSetEverythingNeedsDisplay
{
    NSArray * windows = [UIApplication sharedApplication].windows;
    
    for (UIWindow * window in windows)
    {
        [self debugModeSetEverythingNeedsDisplayForView:window];
    }
}

+ (BOOL)debugModeEnabled
{
    return WMGTextDrawerDebugModeEnabled;
}

+ (void)setDebugModeEnabled:(BOOL)enabled
{
    WMGTextDrawerDebugModeEnabled = enabled;
    [self debugModeSetEverythingNeedsDisplay];
    [CATransaction flush];
}

+ (void)enableDebugMode
{
    [self setDebugModeEnabled:YES];
}

+ (void)disableDebugMode
{
    [self setDebugModeEnabled:NO];
}

- (void)debugModeDrawLineFramesWithLayoutFrame:(WMGTextLayoutFrame *)layoutFrame context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGContextSetAlpha(ctx, 0.1);
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextFillRect(ctx, self.frame);
    
    NSArray *lines = layoutFrame.arrayLines;
    
    CGFloat lineWidth = 1 / [UIScreen mainScreen].scale;
    
    [lines enumerateObjectsUsingBlock:^(WMGTextLayoutLine *line, NSUInteger idx, BOOL *stop) {
        CGRect rect = line.lineRect;
        rect = [self convertRectFromLayout:rect offsetPoint:self.drawOrigin];
        
        CGContextSaveGState(ctx);
        
        CGContextSetAlpha(ctx, 0.3);
        CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
        CGContextFillRect(ctx, rect);
        
        CGRect baselineRect = CGRectMake(0, 0, rect.size.width, lineWidth);
        baselineRect.origin = [self convertPointFromLayout:line.baselineOrigin offsetPoint:self.drawOrigin];
        
        CGContextSetAlpha(ctx, 0.6);
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextFillRect(ctx, baselineRect);
        
        CGContextRestoreGState(ctx);
    }];
    
    CGContextRestoreGState(ctx);
}


@end
