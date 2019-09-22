//
//  BleAutoConnectionViewController.h
//  东莞五方
//
//  Created by sjty on 2018/7/12.
//  Copyright © 2018年 sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseBleDevice.h"

@interface BleAutoConnectionViewController : UIViewController

@property (nonatomic,strong) NSMutableArray * peripheralDataArray;
@property (nonatomic,strong) BaseBleDevice * baseBleDevice;


/**
 搜索蓝牙
 */
- (void)scanDevice ;
/**
 
 */
- (BabyBluetooth*)babyBluetooth;

/**
 是否连接上
 */
- (BOOL)isConnected;

/** 主要用于刷新设备列表使用的*/
-(void)reload;

-(void)stopScanDevice;

/**
 设置代理
 */
- (void)babyDelegate;

/**
 过滤搜索

 @param peripheral <#peripheral description#>
 @param advertisementData <#advertisementData description#>
 @param RSSI <#RSSI description#>
 */
- (void)filterScanDevice:(CBPeripheral*)peripheral
       advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

/**
 设置设备
 */
- (void)setPeripheral:(CBPeripheral *) peripheral;

/**
 连接设备

 @param peripheral <#peripheral description#>
 */
- (void)connectedCBPeripheral:(CBPeripheral*)peripheral;

/**
 连接超时
 */
- (void)onConnecTimeOut;

/**
 连接成功
 @param peripheral <#peripheral description#>
 */
- (void)onConnectSuccess:(CBPeripheral*)peripheral;


/**
 断开连接
 @param peripheral <#peripheral description#>
 */
- (void)onDisconnect:(CBPeripheral*)peripheral;

/**
 设置通知完成
 */
- (void)onNotifyFinish;

@end
