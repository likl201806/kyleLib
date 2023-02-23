//
//  MBProgressHUD+Touch.m
//  LanYouProgressHUD
//
//  Created by leqing222 on 2021/9/23.
//

#import "MBProgressHUD+Touch.h"
#import <objc/runtime.h>

@implementation MBProgressHUD (Touch)

static char enableThroughRectKey;
- (void)setLy_enableThroughRect:(CGRect)ly_enableThroughRect {
    objc_setAssociatedObject(self, &enableThroughRectKey, [NSValue valueWithCGRect:ly_enableThroughRect], OBJC_ASSOCIATION_RETAIN);
}
 
- (CGRect)ly_enableThroughRect {
    return [objc_getAssociatedObject(self, &enableThroughRectKey) CGRectValue];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectEqualToRect(self.ly_enableThroughRect, CGRectZero)) {
        return YES;
    }
    
    if (CGRectContainsPoint(self.ly_enableThroughRect, point)) {
        return NO;
    }
    
    return YES;
}

@end
