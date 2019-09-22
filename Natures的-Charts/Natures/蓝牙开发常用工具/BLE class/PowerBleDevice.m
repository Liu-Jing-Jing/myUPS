//
//  PowerBleDevice.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/19.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "PowerBleDevice.h"
#include "CheackUtils.h"
#import "BleDeviceModel.h"
#define NOTIFY_CHARACTERISTIC_UUID @"d44bc439-abfd-45a2-b575-925416129601"
#define SERVICE_UUID @"0000FEE9-0000-1000-8000-00805F9B34FB" //fee9

#define SJTY_WRITEUUID              @"d44bc439-abfd-45a2-b575-925416129600"//@"a101"
#define SJTY_NOTIFIUUID             @"d44bc439-abfd-45a2-b575-925416129601"//@"a102"

@implementation PowerBleDevice
- (void)setStartCommandWithSyncMacineTimeSuccess:(void(^)(void))successBlock
{
    NSMutableString *sendDataString =[NSMutableString string];
    [sendDataString appendString:@"FEEF0201009950FDDF"];
    
    NSData *data=[BaseUtils stringToBytes:sendDataString];
    [self sendCommand:data notifyBlock:^(NSData *data, NSString *stringData) {
        Byte *byte=(Byte *)[data bytes];
        if (byte[3]==0x0b) {
            
#warning 开始设置时间
            if(successBlock)
            {
                successBlock();
            }
            
        };
    } filterBlock:^NSString *{
        return @"";
    }];
}


- (NSData *)syncCurrentTimeCommand
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss/mm/HH/dd/MM/YY"];
    NSString *str = [formatter stringFromDate:now];
    NSArray *dataComps = [str componentsSeparatedByString:@"/"];
    
    NSMutableString *sendDataString =[NSMutableString string];
    [sendDataString appendFormat:@"FEEF0702"];
    for (NSString *unitT in dataComps)
    {
        [sendDataString appendString:[BaseUtils stringConvertForDateValue:[unitT intValue]]];
    }
    
    NSLog(@"%@-------------date", sendDataString);
#warning verify code
   // uint8_t *b = NULL;
    NSData *data=[BaseUtils stringToBytes:sendDataString];
    uint8_t *b =   malloc(sizeof(data.length));
    [data getBytes:b length:data.length];
    uint32_t chech =  N_CRC16(b,(int)data.length);
    NSLog(@"校验了多少%d", *b);
    [sendDataString appendString:[BaseUtils stringConvertForShort:chech]];
    //拼接结尾2字节
    [sendDataString appendString:@"FDDF"];
    data=[BaseUtils stringToBytes:sendDataString];
    return data;
}

- (void)currentActivityMachineDataWithResultBlock:(void(^)(NSData *result))returnBlock
{
    NSMutableString *sendDataString =[NSMutableString string];
    [sendDataString appendString:@"FEEF010341A8FDDF"];
    
    NSData *data=[BaseUtils stringToBytes:sendDataString];
    [self sendCommand:data notifyBlock:^(NSData *data, NSString *stringData) {
        //
//        Byte *byte = [data bytes];
//        if(byte[2]==1) NSLog(@"解析实时数据");
        if(returnBlock && stringData.length>4 )
        {
            if([stringData hasPrefix:@"feef"])returnBlock(data);
        }
    } filterBlock:^NSString *{
        return @"";
    }];
}


//FE    EF    01    05    C1    AA    FD    DF
- (void)historyMachineDataWithResultBlock:(void(^)(NSString *dataString))returnBlock
{
    NSMutableString *sendDataString =[NSMutableString string];
    [sendDataString appendString:@"FEEF0105C1AAFDDF"];
    NSData *data=[BaseUtils stringToBytes:sendDataString];
    
    [self sendCommand:data isSplite:YES notifyBlock:^(NSData *data, NSString *stringData) {
        // 得到历史
        NSLog(@"%@-----------------蓝牙接收到的历史数据", stringData);
        //Byte *byte = [data bytes];
        //if(byte[2]==1) NSLog(@"解析实时数据");
        //if(byte[2]==0) NSLog(@"接收到  解析历史数据");
//        if(returnBlock && byte[2]==1 && [stringData hasPrefix:@"FEEF00"])
//        {
//            NSLog(@"接收到  解析历史数据");
//            returnBlock(data);
//        }
        
        if(returnBlock && stringData.length>16)
        {
            returnBlock(stringData);
        }
    } filterBlock:^NSString *{
        return @"";
    }];
}

//FE    EF    1    7    40    6B    FD    DF
- (void)MachineAddressCodeResultBlock:(void(^)(NSString *result, NSString *macString))returnBlock
{
    NSMutableString *sendDataString =[NSMutableString string];
    [sendDataString appendString:@"FEEF0107406BFDDF"];
    
    
    //[sendDataString appendString:@"FEEF0107406BFDDF"];
    NSData *data=[BaseUtils stringToBytes:sendDataString];
    [self sendCommand:data  isSplite:NO notifyBlock:^(NSData *data, NSString *stringData) {
        //NSLog(@"获得MAC地址----%@", stringData);
        if(returnBlock && stringData.length>=4)
        {
            NSMutableArray *macAddress = [NSMutableArray array];
            
            if(self.isSJTYMODE) //我们的模块
            {
                for(int i=8;i<stringData.length;i+=2)
                {
                    if(i<20){
                        //NSLog(@"Mac地址:%@", [stringData substringWithRange:NSMakeRange(i, 2)]);
                        
                        NSString *value = [stringData substringWithRange:NSMakeRange(i, 2)];
                        
                        [macAddress insertObject:value atIndex:0];
                    }
                }
            }
            else
            {
                //
                
            }
//            NSLog(@"完整的mac ==%@", [macAddress componentsJoinedByString:@":"]);
            returnBlock(stringData, [macAddress componentsJoinedByString:@":"]);
        }
    } filterBlock:^NSString *{
        return @"";
    }];
}

- (void)getUUIDResultBlock:(void(^)(NSString *result, NSString *uuid))returnBlock
{
    NSMutableString *sendDataString =[NSMutableString string];
    [sendDataString appendString:@"FEEF0108006FFDDF"];
    
    
    //[sendDataString appendString:@"FEEF0107406BFDDF"];
    NSData *data=[BaseUtils stringToBytes:sendDataString];
    [self sendCommand:data  isSplite:NO notifyBlock:^(NSData *data, NSString *stringData) {
        if(returnBlock)
        {
            if([[stringData uppercaseString] hasPrefix:@"FEEF0B12"]){
                NSLog(@"UPS--UUID---%@", stringData);
                Byte *btyes = (Byte *)[data bytes];
                NSMutableString *res = [NSMutableString string];
                for (int i = 4;i<14; i++)
                {
                    [res appendFormat:@"%c", btyes[i]];
                }
                
                NSString *datastring = [stringData substringWithRange:NSMakeRange(8, 20)];
#warning 异常的UUID怎么处理
                if([datastring hasPrefix:@"000000000000"]) datastring = @"30303030303030303031";
                NSMutableString *a = [NSMutableString string];
                for (int i = 0;i<datastring.length; i+=2)
                {
                    NSString *each = [datastring substringWithRange:NSMakeRange(i, 2)];
                    if([each hasPrefix:@"0"]) each = [each substringFromIndex:1];
                    int decimalValue = [BaseUtils intConvertForHexString:each];
                    
                    //NSLog(@"---%d", decimalValue);
                    [a appendFormat:@"%c", decimalValue];
                    
                }
                //NSLog(@"FEEF0B12--UUID  %@", a);
                
                returnBlock(stringData, a.copy);
            }
        }
    } filterBlock:^NSString *{
        return @"";
    }];
}
#pragma mark - super methods
-(NSString*)getServiceUUID{
    if(self.isSJTYMODE)
    {
        return @"fee9";
    }
    else
    {
        return SERVICE_UUID;
    }
}
-(NSString*)getWriteUUID{
    //return @"d44bc439-abfd-45a2-b575-925416129600";
    if (self.isSJTYMODE) {
        return @"a101";
    }else{
        return SJTY_WRITEUUID;
    }

}

-(NSString*)getNotifiUUID{
    if (self.isSJTYMODE)
    {
        return @"a102";
    }
    else
    {
        return SJTY_NOTIFIUUID;
    }
//    return SJTY_NOTIFIUUID;
    //return @"003784CF-F7E3-55B4-6C4C-9FD140100A16";
}

-(NSArray*)deviceName
{
    return @[@"SmartKey", @"ZLG BLECABE3B"];
}

@end
