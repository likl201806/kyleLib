//
//  NSString+LYRegular.h

#import <Foundation/Foundation.h>

@interface NSString (LYRegular)
-(NSString *)regularWithPattern:(NSString *)pattern;
-(NSArray *)regularsWithPattern:(NSString *)pattern;
-(NSString *)matchStrWithPre:(NSString *)pre sub:(NSString *)sub;
-(NSArray *)matchsStrWithPre:(NSString *)pre sub:(NSString *)sub;
-(NSString *)removeAllElement:(NSString *)element;
-(NSString *)removeAllElements:(NSArray *)elements;
@end
