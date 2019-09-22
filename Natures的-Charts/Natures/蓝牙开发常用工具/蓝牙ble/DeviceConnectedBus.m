//
//  DeviceConnectedBus.m
//  蓝牙灯
//
//  Created by sjty on 2018/3/8.
//  Copyright © 2018年 sjty. All rights reserved.
//

#import "DeviceConnectedBus.h"


@implementation DeviceConnectedBus
// 创建静态对象 防止外部访问
static DeviceConnectedBus *_instance;
static NSTimer *selfCheckTimer;//自检定时器


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    @synchronized (self) {
    //        // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //        return _instance;
    //    }
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            
            if (selfCheckTimer == nil) {
                  // selfCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(selfCheck) userInfo:nil repeats:YES];
            }
        
        }
    });
    return _instance;
}

- (void)selfCheck {
    NSArray *array = [self.deviceDictionary allValues];
    for (BaseBleDevice *device in array) {
        if (device.cbService == nil) {
            NSLog(@"liang 自检程序执行");
            [self removeDevice:device];
        }
    }
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareDeviceBus
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

/**
 添加设备
 @param device <#device description#>
 */
- (void) addDevice:(BaseBleDevice*)device {
    [self.deviceDictionary setObject:device forKey:device.activityCBPeripheral.identifier.UUIDString];
}

/**
 删除设备
 @param device <#device description#>
 */
- (void) removeDevice:(BaseBleDevice*)device {
    [device cleanObject];
    [self.deviceDictionary removeObjectForKey:device.activityCBPeripheral.identifier.UUIDString];
}

/**
 获取设备
 @param mac <#mac description#>
 @return <#return value description#>
 */
- (BaseBleDevice*) getDevice:(NSString*)mac {

    return [self.deviceDictionary objectForKey:mac];
}

/**
 删除设备名字
 @param mac <#mac description#>
 */
- (void) removeDeviceByMac:(NSString*)mac {//回搜索不到蓝牙
    BaseBleDevice* device = [self.deviceDictionary objectForKey:mac];
    [device cleanObject];
    [self.deviceDictionary removeObjectForKey:mac];

}

- (NSMutableDictionary<NSString*, BaseBleDevice*>*)deviceDictionary {
    if (_deviceDictionary == nil) {
        _deviceDictionary = [NSMutableDictionary dictionary];
    }
    return _deviceDictionary;
}

- (void) cleanAll {
    if (_deviceDictionary) {
        [_deviceDictionary removeAllObjects];
    }
}

- (NSInteger) deviceSize {
    
    
    return [_deviceDictionary count];
    
}


@end
