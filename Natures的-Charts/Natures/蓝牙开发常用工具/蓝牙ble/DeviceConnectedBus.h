//
//  DeviceConnectedBus.h
//  蓝牙灯
//
//  Created by sjty on 2018/3/8.
//  Copyright © 2018年 sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBleDevice.h"

@interface DeviceConnectedBus : NSObject

+(instancetype)shareDeviceBus;

@property (nonatomic,strong) NSMutableDictionary<NSString*, BaseBleDevice*> *deviceDictionary;



/**
 添加设备
 @param device <#device description#>
 */
- (void) addDevice:(BaseBleDevice*)device;


/**
 删除设备
 @param device <#device description#>
 */
- (void) removeDevice:(BaseBleDevice*)device;


/**
 获取设备
 @param mac <#mac description#>
 @return <#return value description#>
 */
- (BaseBleDevice*) getDevice:(NSString*)mac;


/**
 删除设备名字
 @param mac <#mac description#>
 */
- (void) removeDeviceByMac:(NSString*)mac;

/**
 清除所有连接的设备
 */
- (void) cleanAll;

/**
 *连接数
 */
- (NSInteger) deviceSize;



@end
