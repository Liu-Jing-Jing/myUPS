//
//  BaseBleDevice.m
//  KangNengWear
//
//  Created by liangss on 2017/10/12.
//  Copyright © 2017年 sjty. All rights reserved.
//

#import "BaseBleDevice.h"
#import "CalendarUtils.h"
#import "NSQueue.h"
#import "BaseBleDevice.h"
#import "DeviceConnectedBus.h"

@implementation BaseBleDevice
static int weekArr[] = {0,7,1,2,3,4,5,6};

- (instancetype)initWithUsingNameFilterWithoutUUIDForBabyBluetooth:(BabyBluetooth *)babyBlutooth
{
    self = [super init];
    if (self)
    {
        self->babyBlutooth = babyBlutooth;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifcationValue:) name:BabyNotificationAtDidUpdateValueForCharacteristic object:nil];
        [self setFilterByName:YES];
        self.queue = [[NSQueue alloc] init];
        
        // NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.028 target:self selector:@selector(sendData) userInfo:nil repeats:YES];
    }
    return self;
}

-(instancetype) initWithBabyBluetooth:(BabyBluetooth*)babyBlutooth{
    self = [super init];
    if (self) {
      self->babyBlutooth = babyBlutooth;
        //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
      
#warning 这行代码是利用UUID 一开始就过滤
        
      //连接设备->
        NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
      [babyBlutooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:[self getServiceUUID]]]  discoverWithServices:@[[CBUUID UUIDWithString:[self getServiceUUID]]]  discoverWithCharacteristics:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifcationValue:) name:BabyNotificationAtDidUpdateValueForCharacteristic object:nil];
        
        self.queue = [[NSQueue alloc] init];
        
       // NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.028 target:self selector:@selector(sendData) userInfo:nil repeats:YES];
       
    }
    return self;
}


-(NSMutableArray*)spiltDataArray {
    if (_spiltDataArray == nil) {
        _spiltDataArray =[NSMutableArray array];
    }
    return _spiltDataArray;
}

-(NSString*)getServiceUUID
{
    return @"";
}

-(NSString*)getWriteUUID
{
    return @"";
}

-(NSString*)getNotifiUUID
{
    return @"";
}

-(NSArray*)deviceName
{
    return @[];
}

-(void)setActivityCBPeripheral:(CBPeripheral *)activityCBPeripheral {
    _cbService = nil;
    _notifyCharacteristic = nil;
    _writeCharacteristic = nil;
    _activityCBPeripheral = activityCBPeripheral;
    [self performSelector:@selector(setNotify) withObject:self afterDelay:1.5];
    [self performSelector:@selector(checkSelfTimer) withObject:self afterDelay:3];
}

- (void)checkSelfTimer {//自检程序
    if (_selfCheckTimer) {
        [_selfCheckTimer invalidate];
        _selfCheckTimer = nil;
    }
    if (_selfCheckTimer == nil) {
        _selfCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkSelf) userInfo:nil repeats:YES];
    }
}

- (void)checkSelf {
    if (self.activityCBPeripheral.state == CBPeripheralStateConnected) {
        if (self.cbService == nil || self.notifyCharacteristic == nil || self.writeCharacteristic == nil) {
            NSLog(@"没找到服务,自杀了.");
            [[BabyBluetooth shareBabyBluetooth]  cancelPeripheralConnection:self.activityCBPeripheral];
            [[BabyBluetooth shareBabyBluetooth] AutoReconnectCancel:self.activityCBPeripheral];
             [[DeviceConnectedBus shareDeviceBus] removeDeviceByMac:[self.activityCBPeripheral.identifier UUIDString]];
            if (_selfCheckTimer) {
                [_selfCheckTimer invalidate];
                _selfCheckTimer = nil;
            }
        }
        
    }
}

-(void)setFilterByName:(BOOL)filter{
    __weak typeof(self) weekSelf = self;
    if (filter) {
        [babyBlutooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
            NSArray* array = [weekSelf deviceName];
            
            if ([array containsObject:peripheralName]) {
                return YES;
            }
            return NO;
        }];
    }
}

-(void)returnValue {
    
    NSMutableString * strData = [NSMutableString string];
    if(self.spiltDataArray.count > 0){
        for (NSString * str in self.spiltDataArray) {
            [strData appendString:str];
        }
    }
    if([self blockFilterNotifyValue]) {
        NSString * filterString = self.blockFilterNotifyValue();
        NSString * headString = [strData substringWithRange:NSMakeRange(0, filterString.length)];
        if ([filterString caseInsensitiveCompare:headString] == NSOrderedSame) {
            
            if ([self blockReturnNotifyValueToView]) {
                [self blockReturnNotifyValueToView](nil,strData);
            }
            //移除所有
        }
    }
    self.iSpiltData = NO;
    [self.spiltDataArray removeAllObjects];
}

-(void)setNotify{
    if (self.activityCBPeripheral) {
        if (self.notifyCharacteristic) {
            __weak typeof(self) weekSelf = self;

            
            [babyBlutooth notify:weekSelf.activityCBPeripheral characteristic:weekSelf.notifyCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                //NSLog(@"self.activityCBPeripheral==%@ self==%@",weekSelf.activityCBPeripheral,weekSelf);
           
                    
            }];
            
        }
    }
}


-(void)sendCommand:(NSData*)cmd
       notifyBlock:(ReturnNotifyValueToViewBlock) notifyBlock
       filterBlock:(FilterNotifyValueBlock) filterBlock{
    self.blockReturnNotifyValueToView = notifyBlock;
    self.blockFilterNotifyValue = filterBlock;
    self.iSpiltData = NO;
    BabyLog(@"发送的数据为:%@",[BaseUtils stringConvertForData:cmd]);
 
#if  IS_SHOW_LOG
    NSString * sendDataStr = [BaseUtils stringConvertForData:cmd];
    
    NSString * sendStr = [self.logDictionary objectForKey:sendLog];
    
    if (sendStr) {
        
        [self.logDictionary setObject:[NSString stringWithFormat:@"%@\n%@",sendStr,sendDataStr] forKey:sendLog];
    } else {
        [self.logDictionary setObject:sendDataStr forKey:sendLog];
    }
#endif
    
    if (cmd) {
        if (self.activityCBPeripheral && self.activityCBPeripheral.state == CBPeripheralStateConnected) {
            if (self.writeCharacteristic != nil) {
                [self.activityCBPeripheral writeValue:cmd forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
            } else {
                  NSLog(@"liangss 特性为空.");
            }
        }
    }
    
//    [self.queue enqueue:cmd];
}

/**
 发送数据
 
 @param cmd 指令
 */
-(void)sendCommand:(NSData*)cmd
          isSplite:(BOOL)isSplite
       notifyBlock:(ReturnNotifyValueToViewBlock) notifyBlock
       filterBlock:(FilterNotifyValueBlock) filterBlock
{
    self.iSpiltData = isSplite;
    self.blockReturnNotifyValueToView = notifyBlock;
    self.blockFilterNotifyValue = filterBlock;
    
    BabyLog(@"发送的数据为:%@",[BaseUtils stringConvertForData:cmd]);
    
#if  IS_SHOW_LOG
    NSString * sendDataStr = [BaseUtils stringConvertForData:cmd];
    
    NSString * sendStr = [self.logDictionary objectForKey:sendLog];
    
    if (sendStr) {
        
        [self.logDictionary setObject:[NSString stringWithFormat:@"%@\n%@",sendStr,sendDataStr] forKey:sendLog];
    } else {
        [self.logDictionary setObject:sendDataStr forKey:sendLog];
    }
#endif
    
    if (cmd) {
        if (self.activityCBPeripheral && self.activityCBPeripheral.state == CBPeripheralStateConnected) {
            if (self.writeCharacteristic != nil) {
                [self.activityCBPeripheral writeValue:cmd forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
            } else {
                NSLog(@"liangss 特性为空.");
            }
        }
    }
}



- (void)sendData {
    
    if (![self.queue isEmpty]) {
        NSData* cmd =  [self.queue dequeue];
        BabyLog(@"发送的数据为:%@",[BaseUtils stringConvertForData:cmd]);
#if IS_SHOW_LOG
        NSString * sendDataStr = [BaseUtils stringConvertForData:cmd];
        
        NSString * sendStr = [self.logDictionary objectForKey:sendLog];
        
        if (sendStr) {
            
            [self.logDictionary setObject:[NSString stringWithFormat:@"%@\n%@",sendStr,sendDataStr] forKey:sendLog];
        } else {
            [self.logDictionary setObject:sendDataStr forKey:sendLog];
        }
#endif
        if (cmd) {
            if (self.activityCBPeripheral && self.activityCBPeripheral.state == CBPeripheralStateConnected) {
                if (self.writeCharacteristic != nil) {
                    [self.activityCBPeripheral writeValue:cmd forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
                } else {
                    NSLog(@"liangss 特性为空.");
                }
            }
        }
    }
}

-(CBCharacteristic*)writeCharacteristic{
    if (_writeCharacteristic == nil) {
        for (CBCharacteristic *characteristic in self.cbService.characteristics ) {
           // NSLog(@"characteristic.UUID==%@",characteristic.UUID.UUIDString);
            
            if ([characteristic.UUID.UUIDString isEqualToString:[[self getWriteUUID] uppercaseString]])
                {
                    _writeCharacteristic = characteristic;
                }
            }
        
        }
    return _writeCharacteristic;
}

- (CBCharacteristic*)notifyCharacteristic{
    if (_notifyCharacteristic == nil) {
        
        
        for (CBCharacteristic *characteristic in self.cbService.characteristics ) {
           // NSLog(@"notifiUUID==%@",characteristic.UUID.UUIDString);

            if ([characteristic.UUID.UUIDString  isEqualToString:[[self getNotifiUUID] uppercaseString]])
            {
                _notifyCharacteristic = characteristic;
            }
        }
    }
    return _notifyCharacteristic;
}

- (CBService*)cbService{
    if (_cbService == nil) {
        for ( CBService *service in self.activityCBPeripheral.services ) {
          //  NSLog(@"serviceUUID==%@",service.UUID.UUIDString);

            NSString *sUUID = service.UUID.UUIDString;
            NSLog(@"%@", sUUID);
            if(service.UUID.UUIDString && [[service.UUID.UUIDString lowercaseString] isEqualToString:@"fee9"]) self.isSJTYMODE = YES;
            if ([service.UUID.UUIDString isEqualToString:[[self getServiceUUID] uppercaseString]]) {
                _cbService = service;
            }
        }
    }
    return _cbService;
}

-(NSString*)getAnsyTimeCmd{
    NSMutableString * string = [NSMutableString string];
    
    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|
    NSCalendarUnitDay|NSCalendarUnitWeekday |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    //然后就可以从d中获取具体的年月日了；
    NSInteger year = [d year] -2000;
    NSInteger month = [d month];
    NSInteger day  =  [d day];
    NSInteger hour = [d hour];
    NSInteger min = [d minute];
    NSInteger second = [d second];
    NSInteger week = weekArr[[d weekday]];
    NSLog(@"week===%ld",week);
    
    // hexYear + hexMonth + hexDay + hexHour + hexMin + hexSecond;
    
//    [string appendString:[BaseUtils stringConvertForByte:year]];
//    [string appendString:[BaseUtils stringConvertForByte:month]];
//    [string appendString:[BaseUtils stringConvertForByte:day]];
//    [string appendString:[BaseUtils stringConvertForByte:hour]];
//    [string appendString:[BaseUtils stringConvertForByte:min]];
//    [string appendString:[BaseUtils stringConvertForByte:second]];
    
    [string appendString:[BaseUtils getDoubleString:[NSString stringWithFormat:@"%ld",year]]];
    [string appendString:[BaseUtils getDoubleString:[NSString stringWithFormat:@"%ld",month]]];
    [string appendString:[BaseUtils getDoubleString:[NSString stringWithFormat:@"%ld",day]]];
    [string appendString:[BaseUtils getDoubleString:[NSString stringWithFormat:@"%ld",week]]];
    [string appendString:[BaseUtils getDoubleString:[NSString stringWithFormat:@"%ld",hour]]];
    [string appendString:[BaseUtils getDoubleString:[NSString stringWithFormat:@"%ld",min]]];
    [string appendString:[BaseUtils getDoubleString:[NSString stringWithFormat:@"%ld",second]]];
    
    return string;
}

#if IS_SHOW_LOG
-(NSMutableDictionary*)logDictionary {
    if (_logDictionary == nil) {
        _logDictionary = [NSMutableDictionary dictionary];
    }
    return _logDictionary;
}
#endif

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BabyNotificationAtDidUpdateValueForCharacteristic object:nil];
}

-(void)receiveNotifcationValue:(NSNotification*)notification {
    NSDictionary*dic = notification.object;
    CBPeripheral* peripheral = dic[@"peripheral"];
    CBCharacteristic* characteristics = dic[@"characteristic"];
  
    if ([peripheral.identifier.UUIDString isEqualToString:self.activityCBPeripheral.identifier.UUIDString] ) {//接收的peripheral 要与当前的activityCBPeripheral 为同一个。
        NSData * data = characteristics.value;
        NSString * strData =  [BaseUtils stringConvertForData:characteristics.value];
        
        BabyLog(@"接受的数据为:%@",strData);
#if IS_SHOW_LOG
        NSString * receiveStr = [self.logDictionary objectForKey:receiveLog];
        
        if (receiveStr) {
            [self.logDictionary setObject:[NSString stringWithFormat:@"%@\n%@",receiveStr,strData] forKey:receiveLog];
        } else {
            [self.logDictionary setObject:strData forKey:receiveLog];
        }
#endif
        
        if ([self iSpiltData]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnValue) object:nil];
            [self.spiltDataArray addObject:strData];
            [self performSelector:@selector(returnValue) withObject:nil afterDelay:0.5];
            
        } else {
            
            if([self blockFilterNotifyValue]) {
#warning j切割字符串出现错误
                NSString * filterString = self.blockFilterNotifyValue();
                NSString * headString = [strData substringWithRange:NSMakeRange(0, filterString.length)];
                if ([filterString caseInsensitiveCompare:headString] == NSOrderedSame) {
                    if ([self blockReturnNotifyValueToView]) {
                        [self blockReturnNotifyValueToView](data,strData);
                    }
                }
            }
        }
    }
}

/**
 *清除数据缓存
 */
- (void)cleanDataBuffer {
    if (self.queue) {
        [self.queue clearQueue];
    }
}

-(void)cleanObject {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BabyNotificationAtDidUpdateValueForCharacteristic object:nil];
    [[BabyBluetooth shareBabyBluetooth]  cancelPeripheralConnection:self.activityCBPeripheral];
    if (self.queue) {
        [self.queue clearQueue];
    }
}


@end
