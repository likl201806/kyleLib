//
//  NSString+LYDataConvert.m

#import "NSString+LYDataConvert.h"
#import "LYDataHandleLog.h"
@implementation NSString (LYDataConvert)
//json字符串转字典
-(id)ly_jsonToDic{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [self ly_toDocWithData:jsonData];
}
-(id)ly_toDocWithData:(NSData *)jsonData{
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                            options:NSJSONReadingAllowFragments
                                                      error:nil];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        LYDataHandleLog(@"Json解析出错---%@",self);
        return nil;
    }
}

-(NSString *)strToHump{
    if(!self.length) return self;
    NSMutableString *muStr = [NSMutableString stringWithString:self];
    while([muStr containsString:@"_"]) {
        NSRange range = [muStr rangeOfString:@"_"];
        if(range.location + 1 < [muStr length]) {
            char c = [muStr characterAtIndex:range.location + 1];
            [muStr replaceCharactersInRange:NSMakeRange(range.location, range.length+1)withString:[[NSString stringWithFormat:@"%c",c]uppercaseString]];
        }
    }
    return muStr;
}
-(NSString *)strToUnderLine{
    if(!self.length) return self;
    NSMutableString *muStr = [NSMutableString string];
    for (int i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cStr = [NSString stringWithFormat:@"%c", c];
        NSString *cLowerStr = [cStr lowercaseString];
        if ([cStr isEqualToString:cLowerStr]) {
            [muStr appendString:cLowerStr];
        }else{
            [muStr appendString:@"_"];
            [muStr appendString:cLowerStr];
        }
    }
    return muStr;
}
@end
