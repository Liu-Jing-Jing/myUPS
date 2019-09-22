//
//  NSString+BlockExtension.m
//  EMS
//
//  Created by 柏霖尹 on 2019/7/6.
//  Copyright © 2019 work. All rights reserved.
//

#import "NSString+BlockExtension.h"

@implementation NSString (BlockExtension)
- (NSString *(^)(NSString *))add{
    return ^(NSString *str){
        return [self stringByAppendingString:str];
    };
}

- (NSString * _Nonnull (^)(NSString * _Nonnull))_
{
    return ^(NSString *str){
        return [self stringByAppendingString:str];
    };
}
- (NSString * (^)(int))addInt
{
    return ^(int value){
        return [NSString stringWithFormat:@"%@%d", self, value];
    };
}

- (NSString * _Nonnull (^)(char))addChar
{
    return ^(char value){
        return [NSString stringWithFormat:@"%@%c", self, value];
    };
}

                                          
- (int)hexStringToDecialValue
{
    return (int)strtoul([self UTF8String],0,16);
}

- (NSString *)trimeLeftAndRightWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
