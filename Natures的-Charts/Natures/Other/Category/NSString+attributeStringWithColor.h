//
//  NSString+attributeStringWithColor.h
//  EMS
//
//  Created by 柏霖尹 on 2019/7/1.
//  Copyright © 2019 work. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSAttributedString.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (attributeStringWithColor)
- (NSMutableAttributedString *)attributeStringWithColor:(UIColor *)color textFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
