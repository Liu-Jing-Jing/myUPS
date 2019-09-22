//
//  BaseBleDevice.h
//  KangNengWear
//
//  Created by liangss on 2017/10/12.
//  Copyright © 2017年 sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "BaseUtils.h"
#import "NSQueue.h"


#define sendLog @"sendCommand"
#define receiveLog @"receiveCommand"
#define IS_SHOW_LOG   0

typedef void(^ReturnNotifyValueToViewBlock)(NSData* data,NSString* stringData);
typedef NSString*(^FilterNotifyValueBlock)();

@interface BaseBleDevice : NSObject {
@public
    BabyBluetooth *babyBlutooth;
}


@property (nonatomic, assign) BOOL isSJTYMODE;

@property (nonatomic,strong) CBPeripheral * activityCBPeripheral;

@property (nonatomic,strong) CBCharacteristic * writeCharacteristic;

@property (nonatomic,strong) CBCharacteristic * notifyCharacteristic;

@property (nonatomic,strong) NSMutableArray<NSString*>* spiltDataArray;

@property (nonatomic,strong) CBService * cbService;

@property (nonatomic, copy) ReturnNotifyValueToViewBlock blockReturnNotifyValueToView;
@property (nonatomic,copy)  FilterNotifyValueBlock blockFilterNotifyValue;

@property (nonatomic,strong) NSMutableDictionary* logDictionary;

@property (nonatomic,retain) NSQueue *queue;

@property (nonatomic,strong) NSTimer *selfCheckTimer;//自检程序定时器


@property (nonatomic,assign) BOOL iSpiltData;
//@property (nonatomic,strong) BabyBluetooth *babyBlutooth;



/**
 初始化

 @param babyBlutooth 蓝牙管理
 @return 返回设备对象
 */
-(instancetype) initWithBabyBluetooth:(BabyBluetooth*)babyBlutooth;

- (instancetype)initWithUsingNameFilterWithoutUUIDForBabyBluetooth:(BabyBluetooth *)babyBlutooth;

/**
 获取服务UUID 子类需覆盖次方法

 @return serviceUUID
 */
-(NSString*)getServiceUUID;


/**
 
 获取写数据UUID 子类需覆盖次方法
 
 @return writeUUID
 */
-(NSString*)getWriteUUID;


/**
 
 获取通知数据UUID 子类需覆盖次方法
 
 @return writeUUID
 */
-(NSString*)getNotifiUUID;


/**
 设备名字 子类需覆盖次方法

 @return 设备的名字
 */

-(NSArray*)deviceName;


/**
 设置是否名字过滤

 @param filter YES 是  NO否
 */
-(void)setFilterByName:(BOOL)filter;


/**
 设置通知
 */
-(void)setNotify;

/**
 *清除数据缓存
 */
- (void)cleanDataBuffer;

/**
 发送数据

 @param cmd 指令
 */
-(void)sendCommand:(NSData*)cmd
       notifyBlock:(ReturnNotifyValueToViewBlock) notifyBlock
       filterBlock:(FilterNotifyValueBlock) filterBlock;


/**
 发送数据
 
 @param cmd 指令
 */
-(void)sendCommand:(NSData*)cmd
          isSplite:(BOOL)isSplite
       notifyBlock:(ReturnNotifyValueToViewBlock) notifyBlock
       filterBlock:(FilterNotifyValueBlock) filterBlock;


//获取同步时间指令  hexYear + hexMonth + hexDay + hexHour + hexMin + hexSecond;
-(NSString*)getAnsyTimeCmd;

-(void)cleanObject;

@end
