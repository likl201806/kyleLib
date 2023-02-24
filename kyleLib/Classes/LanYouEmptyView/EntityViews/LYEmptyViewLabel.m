//
//  LYEmptyViewLabel.m
//  LYEmptyViewBridge
//
//  Created by 符传刚 on 2020/10/30.
//  Copyright © 2020 JGBlazers. All rights reserved.
//

#import "LYEmptyViewLabel.h"

@interface LYEmptyViewLabel ()

/** NSMutableAttributeString的子类 */
@property (nonatomic, strong) NSTextStorage *textStorage;
/** 布局管理者 */
@property (nonatomic, strong) NSLayoutManager *layoutManager;
/** 容器,需要设置容器的大小 */
@property (nonatomic, strong) NSTextContainer *textContainer;

/** 选中的范围 */
@property (nonatomic, assign) NSRange selectRange;

/** 记录用户点击还是松开 */
@property (nonatomic, assign) BOOL isSelect;

/** 是否执行高亮匹配的操作 */
@property (nonatomic, assign) BOOL isNeedToHighlight;

/** 回调 */
@property (nonatomic, copy) void(^clickHandle)(LYEmptyViewLabel *label, NSString *clickString, NSRange clickRange);

@end

@implementation LYEmptyViewLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _highlightColor = [UIColor blueColor];
        _clickHighlightColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return self;
}

- (NSTextStorage *)textStorage {
    if (!_textStorage) {
        _textStorage = [[NSTextStorage alloc] init];
    }
    return _textStorage;
}

- (NSLayoutManager *)layoutManager {
    if (!_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc] init];
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer {
    if (!_textContainer) {
        _textContainer = [[NSTextContainer alloc] init];
    }
    return _textContainer;
}

- (void)onConfigFinish:(void(^)(LYEmptyViewLabel *label, NSString *clickString, NSRange clickRange))clickHandle {
    self.isNeedToHighlight = YES;
    self.clickHandle = clickHandle;
}

- (void)setIsNeedToHighlight:(BOOL)isNeedToHighlight {
    _isNeedToHighlight =isNeedToHighlight;
    
    [self prepareTextSystem];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (self.isNeedToHighlight) {
        [self prepareText];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    if (self.isNeedToHighlight) {
        [self prepareText];
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    if (self.isNeedToHighlight) {
        [self prepareText];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    if (self.isNeedToHighlight) {
        [self prepareText];
    }
}

- (void)setHighlightRangs:(NSArray<LYEmptyViewLabelRange *> *)highlightRangs {
    _highlightRangs = highlightRangs;
    if (self.isNeedToHighlight) {
        [self prepareText];
    }
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    if (self.isNeedToHighlight) {
        [self prepareText];
    }
}

- (void)setClickHighlightColor:(UIColor *)clickHighlightColor {
    _clickHighlightColor = clickHighlightColor;
    if (self.isNeedToHighlight) {
        [self prepareText];
    }
}

/// 准备文本系统
- (void)prepareTextSystem {
    // 0.准备文本
    [self prepareText];
    
    // 1.将布局添加到storeage中
    [self.textStorage addLayoutManager:self.layoutManager];
    
    // 2.将容器添加到布局中
    [self.layoutManager addTextContainer:self.textContainer];
    
    // 3.让label可以和用户交互
    self.userInteractionEnabled = YES;
    
    // 4.设置间距为0
    self.textContainer.lineFragmentPadding = 0;
}

/// 准备文本
- (void)prepareText {
    // 1.准备字符串
    NSAttributedString *attrString;
    if (self.attributedText) {
        attrString = self.attributedText;
    } else if (self.text) {
        attrString = [[NSAttributedString alloc] initWithString:self.text];
    } else {
        attrString = [[NSAttributedString alloc] initWithString:@""];
    }

    self.selectRange = NSMakeRange(0, 0);

    // 2.设置换行模型
    NSMutableAttributedString *attrStringM = [self addLineBreak:attrString];
    [attrStringM addAttributes:@{NSFontAttributeName : self.font} range:NSMakeRange(0, attrStringM.length)];

    // 3.设置textStorage的内容
    [self.textStorage setAttributedString:attrStringM];
    
    // 4.匹配高亮
    if (self.highlightRangs) {
        for (LYEmptyViewLabelRange *range in self.highlightRangs) {
            NSInteger totalLength = self.textStorage.string.length;
            if (range.loc < totalLength) {
                if (range.loc + range.len > totalLength) {
                    range.len = totalLength - range.loc;
                }
                [self.textStorage addAttributes:@{NSForegroundColorAttributeName: self.highlightColor} range:NSMakeRange(range.loc, range.len)];
            } else {
                NSLog(@"loc == %zd, len == %zd，这个范围已经超出了边际", range.loc, range.len);
            }
        }
    }
    [self setNeedsDisplay];
}

- (NSRange)getSelectRange:(CGPoint)selectedPoint {
    if (!self.isNeedToHighlight) {
        return NSMakeRange(0, 0);
    }
    if (self.textStorage.length == 0) {
        return NSMakeRange(0, 0);
    }
    
    NSInteger index = [self.layoutManager glyphIndexForPoint:selectedPoint inTextContainer:self.textContainer];
    
    for (LYEmptyViewLabelRange *range in self.highlightRangs) {
        if (index > range.loc && index < range.loc + range.len) {
            [self setNeedsDisplay];
            return NSMakeRange(range.loc, range.len);
        }
    }
    return NSMakeRange(0, 0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isNeedToHighlight) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    // 0.记录点击
    self.isSelect = YES;
    
    // 1.获取用户点击的点
    CGPoint selectedPoint = [[touches anyObject] locationInView:self];
    
    // 2.获取该点所在的字符串的range
    self.selectRange = [self getSelectRange:selectedPoint];
    
    // 3.是否处理了事件
    if (self.selectRange.length == 0) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectRange.length == 0 || !self.isNeedToHighlight) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    // 0.记录松开
    self.isSelect = NO;
    
    // 2.重新绘制
    [self setNeedsDisplay];
    
    // 3.取出内容
    NSString *contentText =[self.textStorage.string substringWithRange:self.selectRange];
    
    // 3.回调
    !self.clickHandle ?: self.clickHandle(self, contentText, self.selectRange);
}

- (void)drawTextInRect:(CGRect)rect {
    if (!self.isNeedToHighlight) {
        [super drawTextInRect:rect];
        return;
    }
    
    // 1.绘制背景
    if (self.selectRange.length > 0) {
        // 2.0.确定颜色
        UIColor *selectColor = self.isSelect ? self.clickHighlightColor : [UIColor clearColor];
        // 2.1.设置颜色
        [self.textStorage addAttributes:@{NSBackgroundColorAttributeName: selectColor} range:self.selectRange];
        // 2.2.绘制背景
        [self.layoutManager drawBackgroundForGlyphRange:self.selectRange atPoint:CGPointMake(0, 0)];
    }
    
    // 2.绘制字形
    // 需要绘制的范围
    NSRange range = NSMakeRange(0, self.textStorage.length);
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}

/// 如果用户没有设置lineBreak,则所有内容会绘制到同一行中,因此需要主动设置
- (NSMutableAttributedString *)addLineBreak:(NSAttributedString *)attrString {
    
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
    
    if (attrStringM.length == 0) return attrStringM;
    
    NSRange range = NSMakeRange(0, 0);
    NSMutableDictionary *attributes = [attrStringM attributesAtIndex:0 effectiveRange:&range].mutableCopy;
    NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
    
    if (paragraphStyle && [paragraphStyle isKindOfClass:[NSMutableParagraphStyle class]]) {
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
        [attrStringM setAttributes:attributes range:range];
    }
    return attrStringM;
}

#pragma mark: <---------- UI排列 ---------->
/// UI排列
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.size = self.frame.size;
}

@end

@implementation LYEmptyViewLabelRange

+ (instancetype)createForLoc:(NSInteger)loc len:(NSInteger)len {
    LYEmptyViewLabelRange *range = [[LYEmptyViewLabelRange alloc] init];
    range.loc = MAX(loc, 0);
    range.len = MAX(len, 0);
    return range;
}

@end
