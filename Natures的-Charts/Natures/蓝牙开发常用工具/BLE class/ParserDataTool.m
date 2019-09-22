//
//  ParserDataTool.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/16.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "ParserDataTool.h"
#import "BaseUtils.h"
#import "UpsModel.h"
@implementation ParserDataTool
+ (UpsModel *)parseData:(Byte *)byte
{
    // 获得的数据
    //if(byte[2] == 0) NSLog(@"解析历史数据");

    //#warning 温度的计算
    NSString *temprature = [NSString stringWithFormat:@"%d", byte[3]];
    //#warning 电压的计算
    float batteryVoltage = (float)byte[12]/10.0;//[[BaseUtils stringConvertForShort:(byte[13]*16*16+byte[12])] hexStringToDecialValue]/10;
    NSString *binaryStr = [BaseUtils binaryToHex:[BaseUtils stringConvertForShort:(byte[15]*16*16+byte[14])]];
    
    //0000000011100000
    unichar ch = [binaryStr characterAtIndex:2];
    NSString *chargeStateStr = [NSString stringWithCharacters:&ch length:1];
    
    if([chargeStateStr isEqualToString:@"0"])
    {
        //停止播放动画
        
    }
    else
    {
#warning 正在充电中
    }
    
    for (int i = 3; i < binaryStr.length; i++)
    {
        unichar ch = [binaryStr characterAtIndex:i];
        NSString *everyString = [NSString stringWithCharacters:&ch length:1];
        //NSLog(@"everyString--->%@", everyString);
        BOOL isLight = everyString.intValue;

        // 13种灯的状态
//        UIView *current = self.stateControls[i];
//        if([current isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)current;
//            btn.selected = !isLight;
//        }
//        else
//        {
//            current.hidden = !isLight;
//        }
    }
    
    int horsePower = byte[5]*16*16+byte[4]; // 功率
    int hPoewerGrade = byte[16];

    //weakSelf.batteryInfoView.title = [NSString stringWithFormat:@"%0.1f", batteryVoltage];
    
    //#warning 创建模型
    UpsModel *ups = [[UpsModel alloc] init];
    ups.temperature = @(byte[3]);
    ups.power = @(horsePower);
    //ups.createTime = [[NSDate date] convertToSJTYServerFormat];
    ups.voltage = [NSString stringWithFormat:@"%@", @(batteryVoltage)];
    unichar inverterC = [binaryStr characterAtIndex:1];
    NSString *inverterS = [NSString stringWithCharacters:&inverterC length:1];
    ups.inverter = @(inverterS.intValue);
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
            //NSLog(@"%@", [ups valueForKey:vars[i-3]]);
            [ups setValue:@(everyString.intValue) forKey:vars[i-3]];
        }
    }
    Byte powerCount = byte[17]; // 电量
    ups.powerCount = @(powerCount);
#warning 最后3个参数不确定什么意思
    
    int vvvv = byte[12];
    //ups.elec = @(0);
    ups.mac = @"known";
    ups.uuids = @"known";
    return ups;
}
@end
