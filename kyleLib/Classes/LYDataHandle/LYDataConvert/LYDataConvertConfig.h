//
//  LYDataConvertConfig.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    LYDataValueAutoConvertModeEmpty = 0x00,// 当json/字典的value类型与model不一致时，model中对应value将被赋值为空，如NSArray，将被赋值为@[]
    LYDataValueAutoConvertModeNil = 0x01,// 当json/字典的value类型与model不一致时，model中对应value将被赋值为nil
    LYDataValueAutoConvertModeOrg = 0x02,// 当json/字典的value类型与model不一致时，model中对应value将被赋值为原json/字典的value
    
}LYDataValueAutoConvertMode;

@interface LYDataConvertConfig : NSObject
/// 当json/字典的value类型与model不一致时处理模式，默认为LYDataValueAutoConvertModeEmpty
@property(nonatomic,assign) LYDataValueAutoConvertMode ly_dataValueAutoConvertMode;
@end

NS_ASSUME_NONNULL_END
