//
//  NSString+attributeStringWithColor.m
//  EMS
//
//  Created by 柏霖尹 on 2019/7/1.
//  Copyright © 2019 work. All rights reserved.
//

#import "NSString+attributeStringWithColor.h"

@implementation NSString (attributeStringWithColor)
- (NSMutableAttributedString *)attributeStringWithColor:(UIColor *)color textFont:(UIFont *)font;
{
    // 设置普通字体的颜色
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attrString addAttributes:@{NSFontAttributeName: font ,NSForegroundColorAttributeName: color} range:NSMakeRange(0, self.length)];
    
    return attrString;
}
@end
