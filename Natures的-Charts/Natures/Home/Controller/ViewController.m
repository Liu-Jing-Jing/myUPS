//
//  ViewController.m
//  Natures
//
//  Created by sjty on 2019/7/10.
//  Copyright © 2019 com.sjty. All rights reserved.
//
//  第一个页面的VC
#import "ViewController.h"
#import "InfoView.h"
#import "AppDelegate.h"
#import "SearchBLEViewController.h"
#import "SystemTestViewController.h"
#import "PowerBleDevice.h"
#import "DeviceConnectedBus.h"
#import "UnsyncUPSModel.h"

#import "UpsModel.h"
#define kCommandLength 44
@interface ViewController ()
@property (weak, nonatomic) IBOutlet InfoView *outputInfoView;
@property (weak, nonatomic) IBOutlet InfoView *batteryInfoView;
@property (weak, nonatomic) IBOutlet InfoView *tempInfoView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic, copy) NSMutableArray *stateControls;
@property (nonatomic, strong) NSMutableArray *fourLightingButtons;
@property (weak, nonatomic) IBOutlet UILabel *wattLabel;
@property (nonatomic, strong) NSTimer *getCurrentDataTimer;
@property (nonatomic, strong) NSString *sycnCurrentTimer;
@property (nonatomic, strong) NSString *macineUUID;
@property (nonatomic, assign) int watts;
@property (nonatomic, assign) int hpowerGrade;
@property (nonatomic, assign) int batteryGrade;
@property (weak, nonatomic) IBOutlet UILabel *fullLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *top2Label;
@property (weak, nonatomic) IBOutlet UIImageView *bluetoothImageView;
@property (nonatomic, assign) BOOL isBLEConnected;

@property (nonatomic, strong) UpsModel *currentModel;
@property (nonatomic, strong) PowerBleDevice *device;

@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.view.backgroundColor = kThemeColor;
    CGFloat navigationBarAndStatusBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.navAndStatusBarH = navigationBarAndStatusBarHeight;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleClosed:) name:BabyNotificationAtCentralManagerDisable object:nil];
    self.fourLightingButtons = [NSMutableArray array];
    for (UIView *child in self.fourStatusButton)
    {
        if([child isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)child;
            [self.fourLightingButtons insertObject:btn atIndex:0]; //反序的
        }
    }
    
    //顶部的四小灯
    //NSLog(@"%@", self.fourLightingButtons);
    //test
    //[self startParserHistoryData:@"2222feef016200001215091938428000c0400005f7aafddffeef016200001215091938528000c0400005e66bfddffeef016200001315091939028000c04000058a61fddffeef016200001315091940128000c04000055ceefddffeef016200001315091940228000c04000056cedfddffeef016200001315091941328000c0400005bce0fddffeef016200001315091942428000c04000058d32fddffeef016200001315091942528000c04000059cf3fddffeef016200001415091943028000c0400005f8f1fddffeef016200001415091944128000c0400005a8d6fddffeef016200001415091944228000c040000598d5fddffeef016200001415091945328000c040000548d8fddffeef016200001415091946428000c0400005790afddffeef016200001415091946528000c040000568cbfddffeef010f41adfddf11111"];
}
//9491cdd7be eb

- (void)disconnectAllBLE
{
    self.isBLEConnected = NO;
    [self.getCurrentDataTimer invalidate];
    self.bluetoothImageView.highlighted = NO;
    [self.batteryLeftView stopAnimating];
    [self.batteryRightView stopAnimating];
    // 让所有按钮变灰
    for (UIView *child in self.stateControls)
    {
        if([child isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)child;
            btn.selected = YES;
        }
        else
        {
            child.hidden = YES;
        }
    }
    
    
    self.outputInfoView.title = @"0";
    self.batteryInfoView.title = @"0";
    self.tempInfoView.title = @"0";
    //还原两边的动画
    self.batteryLeftView.image = [UIImage imageNamed:@"battery_gray_left_bg"];
    self.batteryRightView.image = [UIImage imageNamed:@"battery_gray_right_bg"];
    [self setupOriginTopFourLabelColor];
    [[BabyBluetooth shareBabyBluetooth] cancelAllPeripheralsConnection];
}

#pragma mark - Lazy
- (NSMutableArray *)stateControls
{
    if(_stateControls == nil)
    {
        _stateControls = [NSMutableArray arrayWithCapacity:16];
        [_stateControls addObjectsFromArray:@[UIView.new, UIView.new, UIView.new]];
        [_stateControls addObjectsFromArray:_rightViews];
        #warning 记得修改灯的4个顺序.小灯不对的
        [_stateControls addObjectsFromArray:_fourStatusButton];// fourLightingButtons
        [_stateControls addObjectsFromArray:_leftViews];

        //
    }
    return _stateControls;
}

- (void)setupUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStylePlain target:self action:@selector(disconnectAllBLE)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStyleDone target:self action:@selector(getHistoryData)];
    self.title=NSStringLKV(@"Home");
    self.outputInfoView.title=@"0";
    self.outputInfoView.bgImage=[UIImage imageNamed:@"icon_mode_1"];
    self.outputInfoView.subTitle=@"Watts";
    
    self.batteryInfoView.title=@"0";
    self.batteryInfoView.bgImage=[UIImage imageNamed:@"icon_mode_1"];
    self.batteryInfoView.subTitle=@"Volts";
    //
    self.tempInfoView.title=@"0";
    self.tempInfoView.bgImage=[UIImage imageNamed:@"icon_mode_1"];
    self.tempInfoView.subTitle= @"°F";
    // 隐藏所有的控件啊
    for (UIView *sub in self.stateControls)
    {
        if ([sub isKindOfClass:[UIImageView class]])
        {
            sub.hidden = YES;
        }
    }
    self.wattLabel.attributedText = [self wattLabelStringWithValue:0];
}

- (NSAttributedString *)wattLabelStringWithValue:(int)value
{
    NSMutableAttributedString *aMString = [NSMutableAttributedString new];
    [aMString appendAttributedString:[[NSString stringWithFormat:@"%d ", value] attributeStringWithColor:UIColor.whiteColor textFont:[UIFont systemFontOfSize:25]]];
    [aMString appendAttributedString:[@"WATTS" attributeStringWithColor:UIColor.whiteColor textFont:[UIFont systemFontOfSize:15]]];
    
    return aMString;
}


- (void)setBatteryLeftGradeWithValue:(int)value
{
    self.batteryLeftView.image = [UIImage imageNamed:[NSString stringWithFormat:@"battery_left_bg_%d", value]];
    
    if (value>5 || value< 1)
    {
        //battery_gray_left_bg
        self.batteryLeftView.image = [UIImage imageNamed:@"battery_gray_left_bg"];
    }
}
- (void)setBatteryRightGradeWithValue:(int)value
{
    self.batteryRightView.image = [UIImage imageNamed:[NSString stringWithFormat:@"battery_right_bg_%d", value]];
    
    if (value>5 || value< 1)
    {
        //battery_gray_left_bg
        self.batteryRightView.image = [UIImage imageNamed:@"battery_gray_right_bg"];
    }
    
    
}

- (void)beginLeftViewAnimation
{
    NSArray *arr = @[@"battery_gray_left_bg", @"battery_left_bg_1", @"battery_left_bg_2", @"battery_left_bg_3", @"battery_left_bg_4", @"battery_left_bg_5"];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *name in arr)
    {
        
        UIImage *image = [UIImage imageNamed:name];
        [images addObject:image];
    }
    self.batteryLeftView.animationDuration = 6;
    self.batteryLeftView.animationRepeatCount = MAXFLOAT;
    [self.batteryLeftView setAnimationImages:images];
    [self.batteryLeftView startAnimating];
}

- (void)beginRightViewAnimation
{
    NSArray *arr = @[@"battery_gray_right_bg", @"battery_right_bg_1", @"battery_right_bg_2", @"battery_right_bg_3", @"battery_right_bg_4", @"battery_right_bg_5"];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *name in arr)
    {
        UIImage *image = [UIImage imageNamed:name];
        [images addObject:image];
    }
    self.batteryRightView.animationDuration = 15/images.count;
    self.batteryRightView.animationRepeatCount = MAXFLOAT;
    [self.batteryRightView setAnimationImages:images];
    [self.batteryRightView startAnimating];
}
#warning 设置顶部4个按钮的
- (void)setupTopFourLabelColor
{
    self.fullLabel.textColor = LLColor(56, 204, 163);
    self.maxLabel.textColor = LLColor(216, 0, 21);
    
    UILabel *outLabel = [self.top2Label firstObject];
    UILabel *batteryLabel = [self.top2Label lastObject];
    outLabel.textColor = LLColor(76, 140, 211);
    batteryLabel.textColor = LLColor(76, 140, 211);
}
- (void)setupOriginTopFourLabelColor
{
    self.fullLabel.textColor = UIColor.lightGrayColor;
    self.maxLabel.textColor = UIColor.lightGrayColor;
    
    UILabel *outLabel = [self.top2Label firstObject];
    UILabel *batteryLabel = [self.top2Label lastObject];
    outLabel.textColor = UIColor.lightGrayColor;
    batteryLabel.textColor = UIColor.lightGrayColor;
}

// 通过这BOOL来控制按钮的标题
- (void)setIsBLEConnected:(BOOL)isBLEConnected
{
    _isBLEConnected = isBLEConnected;
    
    //
    if(isBLEConnected)
    {
        [self.connectButton setTitle:@"System Test" forState:UIControlStateNormal];
        self.connectButton.hidden = NO;
    }
    else
    {
        [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    }
}

- (IBAction)connectAction:(UIButton *)sender
{
    NSString *title = sender.titleLabel.text;
    if([title isEqualToString:@"System Test"])
    {
        // sb中绑定的字符串
        [self performSegueWithIdentifier:@"SystemTestSeg" sender:self];
    }
    else if([title isEqualToString:@"Connect"])
    {
        // 开始蓝牙连接 没脸接上还是将按钮显示为Connect// 蓝牙的连接扫描页面searchSegue
        [self performSegueWithIdentifier:@"searchSegue" sender:self];
    }
}

#pragma mark - 开始跳转和数据处理代码
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SystemTestSeg"])
    {
        // 给我传递模型啊啊啊啊
        SystemTestViewController *stVC = [segue destinationViewController];
        stVC.model = self.currentModel;
    }
    
    //
    SearchBLEViewController *bleVC = (SearchBLEViewController *)segue.destinationViewController;
    if([segue.identifier isEqualToString:@"searchSegue"])
    {
        __weak typeof(self) weakSelf = self;
        bleVC.pop = ^(PowerBleDevice * _Nonnull device) {

            self.macineUUID = device.machineUUID;
            // 获取了之后开始同步历史数据消息
            [weakSelf setupStateLightFromMachineWithPowerDevice:device start:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.isBLEConnected = YES;
                // 连接成功的时候我要设置
                [weakSelf setupTopFourLabelColor];
                
                weakSelf.getCurrentDataTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:weakSelf selector:@selector(setupStateLightFromMachineWithBLEDevice:) userInfo:device repeats:YES];
                [weakSelf.getCurrentDataTimer fire];
                
                [NSTimer scheduledTimerWithTimeInterval:6000 target:weakSelf selector:@selector(upLoadCurrentModel) userInfo:nil repeats:YES];
                [weakSelf.getCurrentDataTimer fire];
                //[weakSelf setupStateLightFromMachineWithBLEDevice:device];
                weakSelf.bluetoothImageView.highlighted = YES;
            });
        };
    }
}

- (void)upLoadCurrentModel
{
    // self.currentModel;
    
    
}




- (void)setupStateLightFromMachineWithBLEDevice:(NSTimer *)theTimer
{
    //NSLog(@"%@", [theTimer userInfo]);
    PowerBleDevice *device = [theTimer userInfo];
    self.device = device;
    __weak typeof(self) weakSelf = self;
        //[weakSelf.connectButton setTitle:@"System Test" forState:UIControlStateNormal];
        // 修改灯的状态 取出模型数据
        [device currentActivityMachineDataWithResultBlock:^(NSData * _Nonnull result) {
            Byte *byte = (Byte *)[result bytes];
            int power = byte[5]*16*16+byte[4];
            if(power < 1800){
            if(byte[2]==0) NSLog(@"解析实时数据");
            if(byte[2]==1) NSLog(@"解析历史数据");
            //[weakSelf setupStateLightFromMachineWithByteArray:byte];
            [weakSelf.batteryLeftView stopAnimating];
            
            
            Byte battery = byte[17]; // 电量
            [weakSelf setBatteryLeftGradeWithValue:battery];
            //NSLog(@"%@", result);
            
            
            
#warning 设置灯的状态
            NSString *binaryStr = [BaseUtils binaryToHex:[BaseUtils stringConvertForShort:(byte[15]*16*16+byte[14])]];//0000000011100000
            unichar ch = [binaryStr characterAtIndex:2];
            NSString *chargeStateStr = [NSString stringWithCharacters:&ch length:1];
            
            if([chargeStateStr isEqualToString:@"0"])
            {
                //停止播放动画
                [weakSelf.batteryLeftView stopAnimating];
            }
            else
            {
                [weakSelf beginLeftViewAnimation];
            }
            
            for (int i = 3; i < binaryStr.length; i++)
            {
                unichar ch = [binaryStr characterAtIndex:i];
                NSString *everyString = [NSString stringWithCharacters:&ch length:1];
                //NSLog(@"everyString--->%@", everyString);
                BOOL isLight = everyString.intValue;
                
                UIView *current = self.stateControls[i];
                uint lightingIndex = 3;
                if([current isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton *)current;
                    btn.selected = !isLight;
                    //if(_fourLightingButtons.count==4) [self.fourLightingButtons[i] setSelected:!isLight];
                    lightingIndex--;
                }
                else
                {
                    current.hidden = !isLight;
                }
            }
            
            int horsePower = byte[5]*16*16+byte[4]; // 功率
            weakSelf.watts = horsePower;
            int hPoewerGrade = byte[16];
            [weakSelf setBatteryRightGradeWithValue:hPoewerGrade];
            
            
//#warning 温度的计算
            NSLog(@"TEMP %@", [NSString stringWithFormat:@"%d", byte[3]]);
            weakSelf.tempInfoView.title = [NSString stringWithFormat:@"%d", byte[3]];
//#warning 电压的计算
            float batteryVoltage = [[BaseUtils stringConvertForShort:(byte[13]*16*16+byte[12])] hexStringToDecialValue]/10;
            weakSelf.batteryInfoView.title = [NSString stringWithFormat:@"%0.1f", batteryVoltage];
            
//#warning 创建模型
            UpsModel *ups = [[UpsModel alloc] init];
            ups.temperature = @(byte[3]);
            ups.power = @(horsePower);
            //ups.createTime = [[NSDate date] convertToSJTYServerFormat];
            ups.voltage = [NSString stringWithFormat:@"%@", @(batteryVoltage)];
            unichar inverterC = [binaryStr characterAtIndex:1];
            NSString *inverterS = [NSString stringWithCharacters:&inverterC length:1];
            ups.inverter = @(inverterS.intValue);
#warning 这个是什么意思啊
            ups.lamp = @(chargeStateStr.intValue);
            
            NSMutableArray *vars = [NSMutableArray arrayWithCapacity:13];
            [vars addObjectsFromArray:@[@"fuse",
                                        @"ac",
                                        @"arrowDown",
                                        @"lowPower",
                                        @"buttons",
                                        @"dc",
                                        @"usb",
                                        @"threePlug",
                                        @"upPower",
                                        @"bluetooth",
                                        @"threeFan",
                                        @"tian",
                                        @"plug"]];
            
            if(vars.count == 13){
                for (int i = 3; i < binaryStr.length; i++)
                {
                    unichar ch = [binaryStr characterAtIndex:i];
                    NSString *everyString = [NSString stringWithCharacters:&ch length:1];
                    //NSLog(@"everyString--->%@", everyString);
                    NSLog(@"%@", [ups valueForKey:vars[i-3]]);
                    [ups setValue:@(everyString.intValue) forKey:vars[i-3]];
                }
            }
            Byte powerCount = byte[17]; // 电量
            ups.powerCount = @(powerCount);
            #warning 最后3个参数不确定什么意思
            ups.elec = @(0);
            self.currentModel = ups;
            
            
            for(int i=5;i<11;i++)
            {
                //NSLog(@"日期的信息%d----%d",i+1, byte[i]);
            }
            // NSAssert(ups!=nil, @"模型创建成功了");
            
//            [device MachineAddressCodeResultBlock:^(NSString * _Nonnull result) {
//                for(int i=8;i<result.length;i+=2)
//                {
//                    NSLog(@"Mac地址:%@", [result substringWithRange:NSMakeRange(i, 2)]);
//                }
//
//            }];
            }
        }];
    

}


- (void)setupStateLightFromMachineWithPowerDevice:(PowerBleDevice *)device start:(BOOL)startHistory;
{
    //NSLog(@"%@", [theTimer userInfo]);
    self.device = device;
    __weak typeof(self) weakSelf = self;
    //[weakSelf.connectButton setTitle:@"System Test" forState:UIControlStateNormal];
    // 修改灯的状态 取出模型数据
    [device currentActivityMachineDataWithResultBlock:^(NSData * _Nonnull result) {
        //
        
        Byte *byte = (Byte *)[result bytes];
        int power = byte[5]*16*16+byte[4];
        if(power < 1800){
            if(byte[2]==0) NSLog(@"解析实时数据");
            if(byte[2]==1) NSLog(@"解析历史数据");
            //[weakSelf setupStateLightFromMachineWithByteArray:byte];
            [weakSelf.batteryLeftView stopAnimating];
            
            
            Byte battery = byte[17]; // 电量
            [weakSelf setBatteryLeftGradeWithValue:battery];
            //NSLog(@"%@", result);
            
            
            
#warning 设置灯的状态
            NSString *binaryStr = [BaseUtils binaryToHex:[BaseUtils stringConvertForShort:(byte[15]*16*16+byte[14])]];//0000000011100000
            unichar ch = [binaryStr characterAtIndex:2];
            NSString *chargeStateStr = [NSString stringWithCharacters:&ch length:1];
            
            if([chargeStateStr isEqualToString:@"0"])
            {
                //停止播放动画
                [weakSelf.batteryLeftView stopAnimating];
            }
            else
            {
                [weakSelf beginLeftViewAnimation];
            }
            
            for (int i = 3; i < binaryStr.length; i++)
            {
                unichar ch = [binaryStr characterAtIndex:i];
                NSString *everyString = [NSString stringWithCharacters:&ch length:1];
                //NSLog(@"everyString--->%@", everyString);
                BOOL isLight = everyString.intValue;
                
                UIView *current = self.stateControls[i];
                if([current isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton *)current;
                    btn.selected = !isLight;
                }
                else
                {
                    current.hidden = !isLight;
                }
            }
            
            int horsePower = byte[5]*16*16+byte[4]; // 功率
            weakSelf.watts = horsePower;
            int hPoewerGrade = byte[16];
            [weakSelf setBatteryRightGradeWithValue:hPoewerGrade];
            
            
            //#warning 温度的计算
            NSLog(@"TEMP %@", [NSString stringWithFormat:@"%d", byte[3]]);
            weakSelf.tempInfoView.title = [NSString stringWithFormat:@"%d", byte[3]];
            //#warning 电压的计算
            float batteryVoltage = [[BaseUtils stringConvertForShort:(byte[13]*16*16+byte[12])] hexStringToDecialValue]/10;
            weakSelf.batteryInfoView.title = [NSString stringWithFormat:@"%0.1f", batteryVoltage];
            
            //#warning 创建模型
            UpsModel *ups = [[UpsModel alloc] init];
            ups.temperature = @(byte[3]);
            ups.power = @(horsePower);
            //ups.createTime = [[NSDate date] convertToSJTYServerFormat];
            ups.voltage = [NSString stringWithFormat:@"%@", @(batteryVoltage)];
            unichar inverterC = [binaryStr characterAtIndex:1];
            NSString *inverterS = [NSString stringWithCharacters:&inverterC length:1];
            ups.inverter = @(inverterS.intValue);
#warning 这个是什么意思啊
            ups.lamp = @(chargeStateStr.intValue);
            
            NSMutableArray *vars = [NSMutableArray arrayWithCapacity:13];
            [vars addObjectsFromArray:@[@"fuse",
                                        @"ac",
                                        @"arrowDown",
                                        @"lowPower",
                                        @"buttons",
                                        @"dc",
                                        @"usb",
                                        @"threePlug",
                                        @"upPower",
                                        @"bluetooth",
                                        @"threeFan",
                                        @"tian",
                                        @"plug"]];
            
            if(vars.count == 13){
                for (int i = 3; i < binaryStr.length; i++)
                {
                    unichar ch = [binaryStr characterAtIndex:i];
                    NSString *everyString = [NSString stringWithCharacters:&ch length:1];
                    //NSLog(@"everyString--->%@", everyString);
                    NSLog(@"%@", [ups valueForKey:vars[i-3]]);
                    [ups setValue:@(everyString.intValue) forKey:vars[i-3]];
                }
            }
            Byte powerCount = byte[17]; // 电量
            ups.powerCount = @(powerCount);
#warning 最后3个参数不确定什么意思
            ups.elec = @(0);
            ups.mac = @"known";
            ups.uuids = @"known";
            self.currentModel = ups;
            
            
            // for(int i=5;i<11;i++)
            // {
            //     NSLog(@"日期的信息%d----%d",i+1, byte[i]);
            // }
            // NSAssert(ups!=nil, @"模型创建成功了");
            
            // 开始获得历史数据的方法
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if(startHistory == YES) [device historyMachineDataWithResultBlock:^(NSString * _Nonnull dataString) {
                    NSLog(@"准备同步历史数据");
                    [self startParserHistoryData:dataString];}];
#warning 开始同步历史数据的
            });
        }
    }];
    
    
}
// 解析并同步历史数据
- (void)startParserHistoryData:(NSString *)string
{
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MBProgressHUD showMessage:@"Synchronizing data" toView:self.view];
    });
    if([[string lowercaseString] hasPrefix:@"feef01"] ||[[string lowercaseString] rangeOfString:@"feef010f41adfddf"].location != NSNotFound|| [[string lowercaseString] rangeOfString:@"feef010f41adfddf"].location != NSNotFound)
    {
        // 开始解析历史数据  结束的标志位
        NSString *historyString = string;//
        if([historyString hasPrefix:@"feef010f41adfddf"])
        {
            // 去掉前面的数据,然后切割             //如果包含结束未就去掉，没有就不处理
            historyString = [string substringToIndex:[string rangeOfString:@"feef010f41adfddf"].location];
        }
        NSLog(@"去掉尾部的历史数据: %@", historyString);
        if(![historyString hasPrefix:@"feef01"])
        {
            // 去掉前面的数据,然后切割             //开始切割22字节
            historyString = [historyString substringFromIndex:[string rangeOfString:@"feef01"].location];
        }
        
        NSMutableArray *uploadModels = [NSMutableArray array];
        //开始切割22字节
        for(int i=0;i<historyString.length;i+=kCommandLength)
        {
            #warning 是否会越界
            NSString *element = [historyString substringWithRange:NSMakeRange(i, 44)];
            //一条历史数据
            NSLog(@"解析的数据---%@", element); //feef016200001702091921458100e040000508a5fddffeef010f41adfddf-----------------蓝牙接收到的历史数据
            //去掉尾部的历史数据: feef016200001702091921458100e040000508a5fddf
            //得到模型
            NSData *data = [BaseUtils stringToBytes:element];
            UpsModel *historyUpsModel = [ParserDataTool parseData:[data bytes]];
            
            NSMutableArray *timeComp = [NSMutableArray array];
            // for(int J=6*2;J<=2*11;J+=2)
            // {
                
            //     //NSLog(@"日期的信息%d----%@",J+1, [element substringWithRange:NSMakeRange(J, 2)]); 
            //     //[timeComp addObject:[element substringWithRange:NSMakeRange(J, 2)]];
            // }
            
            // 得到完整的时间字符串
            if(timeComp.count == 6)
            {
                NSString *fullTimeString = @"20".add(timeComp[3]).add(@"-").add(timeComp[2]).add(@"-").add(timeComp[1]).add(@" ").    add(timeComp[0]).add(@":").add(timeComp[5]).add(@":").add(timeComp[4]);
            
                historyUpsModel.createTime = fullTimeString;
                historyUpsModel.uuids = machineUUID;
#warning 添加正确的uuids
                //historyUpsModel.uuids = @"0000000001";//

                NSLog(@"%@", historyUpsModel.createTime);
                if(historyUpsModel) [uploadModels addObject:historyUpsModel];
            }
        }
        
        // 开始同步历史数据
            [UpsNetworkingTools postManyUPSDataToServer:uploadModels success:^(id resultDict) {
                //
                //self.connectButton.hidden = NO;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showSuccess:resultDict[@"Cloud Synchronization Data Successful"]];
            } failure:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"Cloud Synchronization Data Failed, Check the Network"];
                UnsyncUPSModel *unsynced = [UnsyncUPSModel new];
                unsynced.historyString = string;
                [unsynced save];
            }];
    }
}
- (void)setWatts:(int)watts
{
    _watts = watts;
    
    //判断
    if(watts == 0xffff)
    {
        self.wattLabel.text = @"UPS";
        self.outputInfoView.title = @"UPS";
    }
    else if(watts<1800)  // watt小于1800
    {
        self.wattLabel.attributedText = [self wattLabelStringWithValue:watts];
        self.outputInfoView.title = [NSString stringWithFormat:@"%d", watts];
    }
}

- (void)getHistoryData
{
    //feef01 0b 40 6e fddf
//    [self.device historyMachineDataWithResultBlock:^(NSData * _Nonnull result) {
//        // 历史数据
//        NSLog(@"历史-----%@", result);
//
//
//    }];
//
//    NSLog(@"%@",self.currentModel);
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

/*
[device historyMachineDataWithResultBlock:^(NSData * _Nonnull result) {
    //
    Byte *byte = (Byte *)[result bytes];
    int power = byte[5]*16*16+byte[4];
    if(power < 1800){
        if(byte[2]==1) NSLog(@"解析历史数据");
        
        
        Byte battery = byte[17]; // 电量
        //NSLog(@"%@", result);
        
#warning 设置灯的状态
        NSString *binaryStr = [BaseUtils binaryToHex:[BaseUtils stringConvertForShort:(byte[15]*16*16+byte[14])]];//0000000011100000
        unichar ch = [binaryStr characterAtIndex:2];
        NSString *chargeStateStr = [NSString stringWithCharacters:&ch length:1];
        
        if([chargeStateStr isEqualToString:@"0"])
        {
            //停止播放动画
            [weakSelf.batteryLeftView stopAnimating];
        }
        else
        {
            [weakSelf beginLeftViewAnimation];
        }
        
        for (int i = 3; i < binaryStr.length; i++)
        {
            unichar ch = [binaryStr characterAtIndex:i];
            NSString *everyString = [NSString stringWithCharacters:&ch length:1];
            //NSLog(@"everyString--->%@", everyString);
            BOOL isLight = everyString.intValue;
            
            UIView *current = self.stateControls[i];
            if([current isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)current;
                btn.selected = !isLight;
            }
            else
            {
                current.hidden = !isLight;
            }
        }
        
        int horsePower = byte[5]*16*16+byte[4]; // 功率
        weakSelf.watts = horsePower;
        int hPoewerGrade = byte[16];
        [weakSelf setBatteryRightGradeWithValue:hPoewerGrade];
        
        
        //#warning 温度的计算
        NSLog(@"TEMP %@", [NSString stringWithFormat:@"%d", byte[3]]);
        weakSelf.tempInfoView.title = [NSString stringWithFormat:@"%d", byte[3]];
        //#warning 电压的计算
        float batteryVoltage = [[BaseUtils stringConvertForShort:(byte[13]*16*16+byte[12])] hexStringToDecialValue]/10;
        weakSelf.batteryInfoView.title = [NSString stringWithFormat:@"%0.1f", batteryVoltage];
        
        //#warning 创建模型
        UpsModel *ups = [[UpsModel alloc] init];
        ups.temperature = @(byte[3]);
        ups.power = @(horsePower);
        //ups.createTime = [[NSDate date] convertToSJTYServerFormat];
        ups.voltage = [NSString stringWithFormat:@"%@", @(batteryVoltage)];
        unichar inverterC = [binaryStr characterAtIndex:1];
        NSString *inverterS = [NSString stringWithCharacters:&inverterC length:1];
        ups.inverter = @(inverterS.intValue);
#warning 这个是什么意思啊
        ups.lamp = @(chargeStateStr.intValue);
        
        NSMutableArray *vars = [NSMutableArray arrayWithCapacity:13];
        [vars addObjectsFromArray:@[@"fuse",
                                    @"ac",
                                    @"arrowDown",
                                    @"lowPower",
                                    @"buttons",
                                    @"dc",
                                    @"usb",
                                    @"threePlug",
                                    @"upPower",
                                    @"bluetooth",
                                    @"threeFan",
                                    @"tian",
                                    @"plug"]];
        
        if(vars.count == 13){
            for (int i = 3; i < binaryStr.length; i++)
            {
                unichar ch = [binaryStr characterAtIndex:i];
                NSString *everyString = [NSString stringWithCharacters:&ch length:1];
                //NSLog(@"everyString--->%@", everyString);
                NSLog(@"%@", [ups valueForKey:vars[i-3]]);
                [ups setValue:@(everyString.intValue) forKey:vars[i-3]];
            }
        }
        Byte powerCount = byte[17]; // 电量
        ups.powerCount = @(powerCount);
#warning 最后3个参数不确定什么意思
        ups.elec = @(0);
        ups.mac = @"known";
        ups.uuids = @"known";
        self.currentModel = ups;
    }
    //end
}];
*/
@end
