
//
//  SymbolsValueFormatter.m
//  ChartsTest
//
//  Created by 柏霖尹 on 2019/7/24.
//  Copyright © 2019 work. All rights reserved.
//

#import "SymbolsValueFormatter.h"

@implementation SymbolsValueFormatter
-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

//返回y轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    if(value==1.0) return @"ON";
    
    if(value==0) return @"OFF";
    return @"";
}

@end
