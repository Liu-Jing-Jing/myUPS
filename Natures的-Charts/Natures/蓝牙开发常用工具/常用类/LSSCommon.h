//
//  LSSCommon.h
//
//  Created by sjty on 16/2/29.
//  Copyright © 2016年 sjty. All rights reserved.
//

#ifndef LSSCommon_h
#define LSSCommon_h

//Baby if show log 是否打印日志，默认1：打印 ，0：不打印
#define KBABY_IS_SHOW_LOG 1
//Baby log
#define BabyLog(fmt, ...) if(KBABY_IS_SHOW_LOG) { NSLog(fmt,##__VA_ARGS__); }


#define LSSAPPWidth ([UIScreen mainScreen].bounds.size.width)
//手机高度
#define LSSAppHeight ([UIScreen mainScreen].bounds.size.height)

//状态栏高度
#define LSSStautsBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)


#define SizeScale (LSSAPPWidth != 414 ? 1:1.2)
#define kFont(value) [UIFont systemFontOfSize:value * SizeScale]

#define color(r,g,b)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]


#define PI 3.14159265358979323846




#endif /* LSSCommon_h */
