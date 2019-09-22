//  SearchBLEViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/22.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "SearchBLEViewController.h"
#import "DeviceConnectedBus.h"
#import "DeviceViewCell.h"
#import "BleDeviceModel.h"
#import "SVProgressHUD.h"
#define kBluetoothDeviceKey @"peripheral"
#define kPeripheralAdName @"peripheralName"
#define sjtyUUID @"A8C7C419-914A-DFED-99A6-81EB371CC1C2"
#define kListName @"bleDeviceList"
// 分隔符试用^
@interface SearchBLEViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *deviceArray;
@property (nonatomic, strong) CBPeripheral *selectPer;
@property (nonatomic, strong) BleDeviceModel *nameModel;
@property (nonatomic, strong) NSString *nickName;
@end

@implementation SearchBLEViewController


#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleClosed:) name:BabyNotificationAtCentralManagerDisable object:nil];
    self.baseBleDevice = [[PowerBleDevice alloc] initWithUsingNameFilterWithoutUUIDForBabyBluetooth:self.babyBluetooth];
    [self babyDelegate];
    [self scanDevice];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)bleClosed:(NSNotification *)note
{
    //NSLog(@"关闭缓存池中的蓝牙设备");
    LLog(@"你关闭了BLE");
    for (NSString *uuidString in [DeviceConnectedBus shareDeviceBus].deviceDictionary)
    {
        PowerBleDevice *body= (PowerBleDevice *) [[DeviceConnectedBus shareDeviceBus] getDevice:uuidString];
        //   在下一个控制器取出设备
        [self onDisconnect:body.activityCBPeripheral];
    }
}

#pragma mark - BLE part
- (void)stopBleScanAction
{//self.babyBluetooth.scanForPeripherals().begin();
    [self.babyBluetooth cancelScan];
}

- (void)onConnectFinsh
{
    //[MBProgressHUD showError:@"原厂的蓝牙模块又问题"];
    //    __weak typeof(self) weakSelf = self;
    //    PowerBleDevice *dev = (PowerBleDevice *)self.baseBleDevice;
}





//-(void)onDisconnect:(CBPeripheral *)peripheral{
//    //NSLog(@"=====断开了设备");
//
//    // 测试蓝牙
//    [self onDisconnect:peripheral];
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)dealloc
{
    
}

#warning 没有通知
- (void)onNotifyFinish
{
    __weak typeof(self) weakSelf = self;
    PowerBleDevice *dev = (PowerBleDevice *)self.baseBleDevice;
    [dev setStartCommandWithSyncMacineTimeSuccess:^{
        
        NSLog(@"设置成功");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSData *timeData = [dev syncCurrentTimeCommand];
            [dev sendCommand:timeData notifyBlock:^(NSData *data, NSString *stringData) {
                // 判断是否成功得到
            } filterBlock:^NSString *{ return @"FEEF";}];
        });
        
        
        //        NSLog(@"%@",weakSelf.selectPer);
//        [dev getUUIDResultBlock:^(NSString * _Nonnull result, NSString * _Nonnull uuid) {
//            //
//            NSLog(@"uuid::%@", uuid);
//        }];
        [MBProgressHUD showMessage:@"Connecting Bluetooth" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            
            [dev getUUIDResultBlock:^(NSString * _Nonnull result, NSString * _Nonnull uuidString) {
                __block BOOL isExist = NO;
                __block NSMutableDictionary *nameModels = [[[NSUserDefaults standardUserDefaults] valueForKey:kListName] mutableCopy];
                [nameModels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if([dev.activityCBPeripheral.identifier.UUIDString isEqualToString:key])
                    {
                        isExist = YES;
                    }
                    
                    // 判断内部存储的SN是否存在
                    NSString *values = obj;
                    if([values componentsSeparatedByString:@"^"])
                    {
                        NSString *uuid = [values componentsSeparatedByString:@"^"][1];
                        if([uuid isEqualToString:uuidString])
                        {
                            isExist = YES;
                        }
                    }
                    
                }];
                [dev MachineAddressCodeResultBlock:^(NSString * _Nonnull result, NSString * _Nonnull macString) {
                    //没有找到记录
                    if(isExist== NO)
                    {
//                        BleDeviceModel *model = [[BleDeviceModel alloc] init];
//                        model.nickname = self.nickName;
//                        model.uuidString = dev.activityCBPeripheral.identifier.UUIDString;
//                        model.macString = macString;
//
                        //if([model saveOrUpdate]) [MBProgressHUD showSuccess:@"Saved!"];
                        if(macString.length == 0) macString = @"00:00:00:00:00:00";
                        if(nameModels == nil) nameModels = [NSMutableDictionary dictionary];
                        nameModels[dev.activityCBPeripheral.identifier.UUIDString] = [NSString stringWithFormat:@"%@^%@^%@", self.nickName, uuidString, macString]; //先存在名字再存唯一ID最后是Mac地址;
                        [[NSUserDefaults standardUserDefaults] setObject:nameModels forKey:kListName];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    if(weakSelf.pop)
                    {
                        [MBProgressHUD hideHUD];
                        weakSelf.pop((PowerBleDevice *)weakSelf.baseBleDevice);
                    }
                }];
                
            }];
         
#warning POP的时候导致了其他的问题
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - UI part
- (NSMutableArray *)deviceArray
{
    if(_deviceArray == nil)
    {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}

- (void)reload
{
    [super reload];
    [self.tableView reloadData];
}

- (void)setupUI
{
    //setupUI
    self.title = @"Search";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopBleScanAction)];
    // tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableview];
    self.tableView = tableview;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction:)];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


static BOOL isScan = NO;
- (void)rightBarButtonAction:(UIBarButtonItem *)sender
{
    isScan = !isScan;
    if(isScan)
    {
        [sender setTitle:@"Scan"];
        [self stopBleScanAction];
    }
    else
    {
        [sender setTitle:@"Stop"];
        [self scanDevice];
    }
}

//点击弹窗的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        // 点击了设置名字的按钮
        NSString *input =  [alertView textFieldAtIndex:0].text;
        if(!input.length)
        {
            [MBProgressHUD showError:@"请输入名字"];
        }
        else
        {
            [self connectedCBPeripheral:self.selectPer];
            self.nickName = input;

        }
        
    }
}
#pragma mark - TableView
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning Detail
    CBPeripheral *per = self.peripheralDataArray[indexPath.row][kBluetoothDeviceKey];
    if(per)
    {
        NSString *uuidString = per.identifier.UUIDString;
//        BOOL isExist = NO;
//        for(BleDeviceModel *bleModel in [BleDeviceModel findAll])
//        {
//            if([bleModel.uuidString isEqualToString:uuidString])
//            {
//                isExist = YES;
//            }
//        }
//
        __block BOOL isExist = NO;
        NSMutableDictionary *nameModels = [[[NSUserDefaults standardUserDefaults] valueForKey:kListName] mutableCopy];
        [nameModels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([uuidString isEqualToString:key])
            {
                isExist = YES;
            }
        }];
        
        if(isExist)
        {
            // 连接蓝牙设备
            [self connectedCBPeripheral:per];
            self.selectPer = per;
        }
        else
        {
            self.selectPer = per;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"给我起个名字吧" message:@"提示" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set Name", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            //开始起个名字
            [alert show];
        }
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peripheralDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceViewCell *cell = [DeviceViewCell cellforTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置具体的数据模型
    
    // setting Cell
    //    cell.titleLabel
    
    //systemOK    cell.detailLabel
    //    cell.timeDetailLabel
    CBPeripheral *per = self.peripheralDataArray[indexPath.row][kBluetoothDeviceKey];
    cell.titleLabel.text = per.name;
    [MBProgressHUD showSuccess:per.identifier.UUIDString];
    NSDictionary *nameModels = [[NSUserDefaults standardUserDefaults] valueForKey:kListName];
    NSString *values = [nameModels valueForKey:per.identifier.UUIDString];
    if (values.length)
    {
        //找到了存在的蓝牙模块
        NSString *nickname = [[values componentsSeparatedByString:@"^"] firstObject];
        cell.titleLabel.text = nickname;
    }
//    for (BleDeviceModel *model in nameModels)
//    {
//        if([model.uuidString isEqualToString:per.identifier.UUIDString])
//        {
//            cell.titleLabel.text = model.nickname;
//        }
//
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", sender);
}
@end
/**
 //连接设备->
 NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
 [self.babyBluetooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"fee9"]] discoverWithServices:nil  discoverWithCharacteristics:nil];
 */
//-(void)setPeripheral:(CBPeripheral *)peripheral
//{
//    [super setPeripheral:peripheral];
//    self.baseBleDevice.activityCBPeripheral=peripheral;
//    NSLog(@"%@", self.baseBleDevice.cbService.UUID.UUIDString);
//    if (
//        [self.baseBleDevice.cbService.UUID.UUIDString isEqualToString:@"fee9"]) {
//        self.baseBleDevice.isSJTYMODE=YES;
//    }else{
//        self.baseBleDevice.isSJTYMODE=NO;
//    }
//
//    [[DeviceConnectedBus shareDeviceBus] addDevice:self.baseBleDevice];
//}
