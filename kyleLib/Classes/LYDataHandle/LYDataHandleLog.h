//
//  LYDataHandleLog.h
//

#ifndef LYDataHandleLog_h
#define LYDataHandleLog_h
#define LYDocPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define DbPath [LYDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[NSBundle mainBundle].bundleIdentifier]]
#ifdef DEBUG
#define LYDataHandleLog(FORMAT, ...) fprintf(stderr,"------------------------- LYDataHandleLog -------------------------\n编译时间:%s\n文件名:%s\n方法名:%s\n行号:%d\n打印信息:%s\n\n", __TIME__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__,__LINE__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define LYDataHandleLog(FORMAT, ...) nil
#endif

#endif /* LYDataHandleLog_h */
