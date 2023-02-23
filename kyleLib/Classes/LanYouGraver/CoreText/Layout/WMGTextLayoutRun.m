//
//  WMGTextLayoutRun.m
//
    

#import "WMGTextLayoutRun.h"
#import "WMGAttachment.h"

@implementation WMGTextLayoutRun

+ (CTRunDelegateRef)textLayoutRunWithAttachment:(id<WMGAttachment>)att
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = wmg_embeddedObjectDeallocCallback;
    callbacks.getAscent = wmg_embeddedObjectGetAscentCallback;
    callbacks.getDescent = wmg_embeddedObjectGetDescentCallback;
    callbacks.getWidth = wmg_embeddedObjectGetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (void *)CFBridgingRetain(att));
}

void wmg_embeddedObjectDeallocCallback(void* context)
{
    CFBridgingRelease(context);
}

CGFloat wmg_embeddedObjectGetAscentCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachment)])
    {
        return [(__bridge id <WMGAttachment>)context baselineFontMetrics].ascent;
    }
    return 20;
}

CGFloat wmg_embeddedObjectGetDescentCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachment)])
    {
        return [(__bridge id <WMGAttachment>)context baselineFontMetrics].descent;
    }
    return 5;
}

CGFloat wmg_embeddedObjectGetWidthCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachment)])
    {
        return [(__bridge id <WMGAttachment>)context placeholderSize].width;
    }
    return 25;
}

@end
