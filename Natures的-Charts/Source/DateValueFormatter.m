

//
//  DateValueFormatter.m
//  ChartsTest
//
//  Created by 柏霖尹 on 2019/7/24.
//  Copyright © 2019 work. All rights reserved.
//

#import "DateValueFormatter.h"
@interface DateValueFormatter()
{
    NSArray * _arr;
}
@end
@implementation DateValueFormatter
-(id)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self)
    {
        _arr = arr;
        
    }
    return self;
}
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    if(value > _arr.count) return @"";
    return _arr[(NSInteger)value];
}

@end
