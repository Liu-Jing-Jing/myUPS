//
//  UIColor+HW.h
//  HWScrollBar
//
//  Created by sxmaps_w on 2017/6/22.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HW)

//16进制转化RGB
+ (UIColor *)colorWithHexString:(NSString *)string;

//随即色
+ (UIColor *)randomColor;

@end
