//
//  BleAutoConnectionViewController.m
//  东莞五方
//
//  Created by sjty on 2018/7/12.
//  Copyright © 2018年 sjty. All rights reserved.
//

#import "BleAutoConnectionViewController.h"
#import "BaseBleDevice.h"

@interface BleAutoConnectionViewController ()


@end

@implementation BleAutoConnectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //过滤作用
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BabyBluetooth*)babyBluetooth {
    
    return  [BabyBluetooth shareBabyBluetooth];
}

- (BOOL)isConnected
{
    if (self.baseBleDevice.activityCBPeripheral == nil)
    {
        return NO;
    }
    return  self.baseBleDevice.activityCBPeripheral.state == CBPeripheralStateConnected;
}


/**
 RSSI number设置蓝牙信号的强度
 */
- (void)babyDelegate
{
    
    __weak typeof(self) weakSelf = self;
    
    //设置扫描到设备的委托
    [self.babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        [weakSelf filterScanDevice:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    
    [self.babyBluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"---连接成功---%@", self.baseBleDevice.deviceName);
        NSLog(@"%@", self.baseBleDevice);
        //[peripheral cbSerivce]  service->UUID
        NSLog(@"%@", peripheral);
        NSDictionary *attr = [peripheral valueForKey:@"_attributes"];
        NSLog(@"%@", attr);
        //[SVProgressHUD dismiss];
        [self connectSuccessFinish];
        [weakSelf setPeripheral:peripheral];
    }];
    
    //设置发现设service的Characteristics的委托
    [self.babyBluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        //发现特性 设置通知
        NSLog(@"--- 发现特性 --- %@",error);
    }];
    
    
    [self.babyBluetooth setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"设置通知");
        [self onNotifyFinish];
    }];
    
    [self.babyBluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [self onDisconnect:peripheral];
    }];
    
    //设置发现characteristics的descriptors的委托
    //    [babyBluetooth setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
    //        if (!error) {
    //             NSLog(@"--- 发现characteristics的descriptors的委托 ---");
    //
    //        }
    //    }];
    
}

- (void)scanDevice {
//    [self.babyBluetooth cancelAllPeripheralsConnection];
    self.babyBluetooth.scanForPeripherals().begin();
}

//搜索过滤
- (void)filterScanDevice:(CBPeripheral*)peripheral
      advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSArray *peripherals = [self.peripheralDataArray valueForKey:@"peripheral"];
    
    if (![peripherals containsObject:peripheral]) {
        
        NSString *peripheralName;
        if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
            peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
            peripheralName = peripheral.name;
        }
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        //[item setValue:peripheralName forKey:@"peripheralName"];
        //
        [item setValue:peripheralName forKey:@"peripheralName"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        
#warning 默认只显示一个
        //[self.peripheralDataArray removeAllObjects];
        [self.peripheralDataArray addObject:item];
        
        /* 搜索到新设备就刷新表格*/
        [self reload];
        //自动连接
//        [self connectedCBPeripheral:peripheral];
    }
}

-(void)reload{
}


-(void)stopScanDevice{
    [self.babyBluetooth cancelScan];
    
}
#pragma mark 连接成功
- (void)setPeripheral:(CBPeripheral *) peripheral{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connecTimeOut) object:self];
    //单链接
    self.baseBleDevice.activityCBPeripheral = peripheral;
    //自动回连
//    [self.babyBluetooth AutoReconnect:peripheral];
    [self onConnectSuccess:peripheral];
}

#pragma mark 连接成功
- (void)onConnectSuccess:(CBPeripheral*)peripheral {
    
}

#pragma mark 断开连接
- (void)onDisconnect:(CBPeripheral*)peripheral {
    
}

#pragma mark 连接设备
- (void)connectedCBPeripheral:(CBPeripheral*)peripheral {
    //    self.babyBluetooth.having(periphera).
    //    [SVProgressHUD showWithStatus:NSLocalizedString(@"device_connect", @"")];
    [self.babyBluetooth cancelScan];
//    self.babyBluetooth conn
    self.babyBluetooth.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().begin();
}

- (void)onConnecTimeOut {
    [self stopAnimation];
}

- (void)stopAnimation {
    
}
- (void)onNotifyFinish {
    
}

- (void)connectSuccessFinish {
    
}


- (NSMutableArray*)peripheralDataArray{
    if (_peripheralDataArray==nil) {
        _peripheralDataArray = [NSMutableArray array];
    }
    return _peripheralDataArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
