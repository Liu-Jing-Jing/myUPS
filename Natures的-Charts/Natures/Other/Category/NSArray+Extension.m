//
//  NSArray+Extension.m
//  EMS
//
//  Created by 柏霖尹 on 2019/6/27.
//  Copyright © 2019 work. All rights reserved.
//

#import "NSArray+Extension.h"
#import <objc/runtime.h>// 导入运行时文件

@implementation NSArray (Extension)
+ (instancetype)createNewArrayWithSize:(int)length sameValues:(id)obj
{
    if(length<=0) return @[];
    
    // 有数据的
    NSMutableArray *tempArray = [NSMutableArray array];
    for(int i=0;i<length;i++)
    {
        [tempArray addObject:obj];
    }
    
    return tempArray.copy;
}
//返回当前类的所有属性
+ (instancetype)getProperties:(Class)cls
{
    
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++)
    {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return mArray.copy;
}
@end
