//
//  UIColor+HW.m
//  HWScrollBar
//
//  Created by sxmaps_w on 2017/6/22.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "UIColor+HW.h"

@implementation UIColor (HW)

+ (UIColor *)colorWithHexString:(NSString *)string
{
    if ([string hasPrefix:@"#"])
        string = [string substringFromIndex:1];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    NSString *rString = [string substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [string substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [string substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:1];
}

+ (UIColor *)randomColor
{
    CGFloat red = arc4random_uniform(256);
    CGFloat green = arc4random_uniform(256);
    CGFloat blue = arc4random_uniform(256);
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

/** 十六进制颜色扩充
// */
//convenience init?(hex : String, alpha : CGFloat = 1.0) {
//    //1.判断字符串长度是否符合
//    guard hex.characters.count >= 6 else {
//        return nil
//    }
//    //2.将字符串转成大写
//    var tempHex = hex.uppercased()
//    //3.判断开头
//    if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") || tempHex.hasPrefix("0X") {
//        //去掉开头
//        tempHex = tempHex.dropFirst(2)
//    }
//    if tempHex.hasPrefix("#") {
//        tempHex = tempHex.dropFirst()
//    }
//    //4.分别截取RGB
//    var range = NSRange(location: 0, length: 2)
//    let rHex = (tempHex as NSString).substring(with: range)
//    range.location = 2
//    let gHex = (tempHex as NSString).substring(with: range)
//    range.location = 4
//    let bHex = (tempHex as NSString).substring(with: range)
//    //5.将字符串转化成数字  emoji也是十六进制表示(此处也可用Float类型)
//    var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0
//    //创建扫描器,将字符串的扫描结果赋值给:r,g,b
//    Scanner(string: rHex).scanHexInt32(&r)
//    Scanner(string: gHex).scanHexInt32(&g)
//    Scanner(string: bHex).scanHexInt32(&b)
//    
//    self.init(r : CGFloat(r), g : CGFloat(g), b : CGFloat(b))
//}
//
//
///**RGB三原色
// */
//convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) {
//    self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
//}

@end
