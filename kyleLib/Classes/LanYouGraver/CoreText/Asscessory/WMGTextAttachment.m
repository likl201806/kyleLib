//
//  WMGTextAttachment.m
//
    

#import "WMGTextAttachment.h"
#import "WMGTextLayoutRun.h"
#import "WMGTextAttachment+Event.h"

NSString * const WMGTextAttachmentAttributeName = @"WMGTextAttachmentAttributeName";
NSString * const WMGTextAttachmentReplacementCharacter = @"\uFFFC";

@interface WMGTextAttachment ()
@property (nonatomic, strong) NSMutableArray *callBacks;
@end

@implementation WMGTextAttachment
@synthesize type = _type, size = _size, edgeInsets = _edgeInsets, contents = _contents, position = _position, length = _length, baselineFontMetrics = _baselineFontMetrics;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _retriveFontMetricsAutomatically = YES;
        _baselineFontMetrics = WMGFontMetricsZero;
        
        _edgeInsets = UIEdgeInsetsMake(0, 1, 0, 1);
        _userInfoPriority = 999;
        _eventPriority = 999;
        _callBacks = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)textAttachmentWithContents:(id)contents type:(WMGAttachmentType)type size:(CGSize)size
{
    WMGTextAttachment *att = [[WMGTextAttachment alloc] init];
    att.contents = contents;
    att.type = type;
    att.size = size;
    
    return att;
}

- (UIEdgeInsets)edgeInsets
{
    if (_retriveFontMetricsAutomatically) {
        CGFloat lineHeight = WMGFontMetricsGetLineHeight(_baselineFontMetrics);
        CGFloat inset = (lineHeight - self.size.height) / 2;
        
        return UIEdgeInsetsMake(inset, _edgeInsets.left, inset, _edgeInsets.right);
    }
    
    return _edgeInsets;
}

- (CGSize)placeholderSize
{
    return CGSizeMake(self.size.width + self.edgeInsets.left + self.edgeInsets.right, self.size.height + self.edgeInsets.top + self.edgeInsets.bottom);
}

#pragma mark - Event

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    _target = target;
    _selector = action;
    
    _responseEvent = (_target && _selector) && [_target respondsToSelector:_selector];
}

- (void)registerClickBlock:(void (^)(void))callBack {
    if (!callBack) {
        return;
    }
    [_callBacks addObject:callBack];
}

- (void)handleEvent:(id)sender
{
    if (_target && _selector) {
        if ([_target respondsToSelector:_selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_target performSelector:_selector withObject:sender];
#pragma clang diagnostic pop
        }
    }
    if (_callBacks.count) {
        for (void (^callBack)(void) in _callBacks) {
            if (callBack) {
                callBack();
            }
        }
    }
}

@end

@implementation NSAttributedString (GTextAttachment)

- (void)wmg_enumerateTextAttachmentsWithBlock:(void (^)(WMGTextAttachment *, NSRange, BOOL *))block
{
    [self wmg_enumerateTextAttachmentsWithOptions:0 block:block];
}

- (void)wmg_enumerateTextAttachmentsWithOptions:(NSAttributedStringEnumerationOptions)options block:(void (^)(WMGTextAttachment *, NSRange, BOOL *))block
{
    if (!block) return;
    
    [self enumerateAttribute:WMGTextAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:options usingBlock:^(WMGTextAttachment * attachment, NSRange range, BOOL *stop) {
        if (attachment && [attachment isKindOfClass:[WMGTextAttachment class]]) {
            block(attachment, range, stop);
        }
    }];
}

+ (instancetype)wmg_attributedStringWithTextAttachment:(WMGTextAttachment *)attachment
{
    return [self wmg_attributedStringWithTextAttachment:attachment attributes:@{}];
}

+ (instancetype)wmg_attributedStringWithTextAttachment:(WMGTextAttachment *)attachment attributes:(NSDictionary *)attributes
{
    // Core Text ??????runDelegate??????????????????attachment??????????????????
    CTRunDelegateRef runDelegate = [WMGTextLayoutRun textLayoutRunWithAttachment:attachment];
    // ??????CTRunDelegateRef ??? ??????????????? ??????????????????*???????????????????????????????????????
    NSMutableDictionary *placeholderAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [placeholderAttributes addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)runDelegate, (NSString*)kCTRunDelegateAttributeName, [UIColor clearColor].CGColor,(NSString*)kCTForegroundColorAttributeName, attachment, WMGTextAttachmentAttributeName, nil]];
    CFRelease(runDelegate);
    
    // ???????????????????????????[??????]??????????????????????????????????????????CTRunDelegateRef????????????
    NSString *str = WMGTextAttachmentReplacementCharacter;
    NSAttributedString *result = [[[self class] alloc] initWithString:str attributes:placeholderAttributes];
    
    return result;
}

@end
