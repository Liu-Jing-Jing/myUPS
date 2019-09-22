//
//  NSString+BlockExtension.h
//  EMS
//
//  Created by 柏霖尹 on 2019/7/6.
//  Copyright © 2019 work. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BlockExtension)
@property (nonatomic,readonly) NSString *(^_)(NSString* str);
@property (nonatomic,readonly) NSString *(^add)(NSString* str);
@property (nonatomic,readonly) NSString *(^addInt)(int value);
@property (nonatomic,readonly) NSString *(^addChar)(char ch);
//@property (nonatomic,readonly) NSString *(^addDouble)(double value, NSInteger accuracy);
//@property (nonatomic,readonly) NSString *(^addFloat)(float value, NSInteger accuracy);

- (int)hexStringToDecialValue;
- (NSString *)trimeLeftAndRightWhitespace;
@end

NS_ASSUME_NONNULL_END
