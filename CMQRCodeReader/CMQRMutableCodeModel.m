//
//  CMQRMutableCodeModel.m
//  CamQRScanner
//
//   on 2022/8/1.
//

#import "CMQRMutableCodeModel.h"

const NSInteger oneCycleScanTime = 20;

@interface CMQRMutableCodeModel()

//当前已扫描次数
@property (nonatomic, assign) NSInteger curIndex;
//当前扫描系列最高二维码个数
@property (nonatomic, assign) NSInteger maxCodeCount;
//当前扫描系列最高二维码个数对应次数
@property (nonatomic, assign) NSInteger maxCountIndex;
//是否已经放大
@property (nonatomic, assign) BOOL haveMagnify;

@end

@implementation CMQRMutableCodeModel

/**
 更新扫描次数与个数
 */
-(void)updateScanDataWithCodeCount:(NSInteger)codeCount magnify:(void(^)(void))magnify completed:(void(^)(void))completed{
    self.curIndex += 1;
    if (self.curIndex >= oneCycleScanTime){  //到了次数
        [self clearScanData];
        if (completed){
            completed();
        }
    }else{
        if (codeCount >= self.maxCodeCount){
            self.maxCountIndex += 1;
            self.maxCodeCount = codeCount;
        }
        if (self.maxCountIndex > 1 && self.haveMagnify == NO){
            self.haveMagnify = YES;
            if (magnify){
                magnify();
            }
        }
        if (self.maxCountIndex > 2 && self.haveMagnify == YES){
            [self clearScanData];
            if (completed){
                completed();
            }
        }
    }
}

/**
 清空扫描数据
 */
-(void)clearScanData{
    self.curIndex = 0;
    self.maxCodeCount = 0;
    self.maxCountIndex = 0;
    self.haveMagnify = NO;
}

@end
