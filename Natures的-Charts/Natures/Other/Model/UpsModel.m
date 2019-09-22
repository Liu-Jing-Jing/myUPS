//
//  UpsModel.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/7.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "UpsModel.h"
#import <objc/runtime.h>
NSString *const kUPSModelClassAc = @"ac";
NSString *const kUPSModelClassArrowDown = @"arrowDown";
NSString *const kUPSModelClassBluetooth = @"bluetooth";
NSString *const kUPSModelClassButtons = @"buttons";
NSString *const kUPSModelClassCreateTime = @"createTime";
NSString *const kUPSModelClassDc = @"dc";
NSString *const kUPSModelClassDel = @"del";
NSString *const kUPSModelClassElec = @"elec";
NSString *const kUPSModelClassFuse = @"fuse";
NSString *const kUPSModelClassIdField = @"id";
NSString *const kUPSModelClassInverter = @"inverter";
NSString *const kUPSModelClassLamp = @"lamp";
NSString *const kUPSModelClassLowPower = @"lowPower";
NSString *const kUPSModelClassMac = @"mac";
NSString *const kUPSModelClassPlug = @"plug";
NSString *const kUPSModelClassPower = @"power";
NSString *const kUPSModelClassPowerCount = @"powerCount";
NSString *const kUPSModelClassProductId = @"productId";
NSString *const kUPSModelClassStr = @"str";
NSString *const kUPSModelClassTemperature = @"temperature";
NSString *const kUPSModelClassThreeFan = @"threeFan";
NSString *const kUPSModelClassThreePlug = @"threePlug";
NSString *const kUPSModelClassTian = @"tian";
NSString *const kUPSModelClassUpPower = @"upPower";
NSString *const kUPSModelClassUpdateTime = @"updateTime";
NSString *const kUPSModelClassUsb = @"usb";
NSString *const kUPSModelClassUserId = @"userId";
NSString *const kUPSModelClassUuids = @"uuids";
NSString *const kUPSModelClassVoltage = @"voltage";

@implementation UpsModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.noMean = @"0";
    }
    return self;
}

- (NSArray<NSString *> *)getAllObjCIvarList
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int methodCount = 0;
    Ivar * ivars = class_copyIvarList([self class], &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++)
    {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        const char * type = ivar_getTypeEncoding(ivar);
        
        
        NSString *propertyName = [[NSString stringWithUTF8String:name] substringFromIndex:1];
        if(![@"i" isEqualToString:[NSString stringWithUTF8String:type]] && ![@"B" isEqualToString:[NSString stringWithUTF8String:type]]) [array addObject:propertyName];
        
    }
    free(ivars);
    
    return array;
}
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.noMean = @"0";
    if(![dictionary[kUPSModelClassAc] isKindOfClass:[NSNull class]]){
        self.ac = @([dictionary[kUPSModelClassAc] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassArrowDown] isKindOfClass:[NSNull class]]){
        self.arrowDown =@( [dictionary[kUPSModelClassArrowDown] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassBluetooth] isKindOfClass:[NSNull class]]){
        self.bluetooth =@( [dictionary[kUPSModelClassBluetooth] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassButtons] isKindOfClass:[NSNull class]]){
        self.buttons =@( [dictionary[kUPSModelClassButtons] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassCreateTime] isKindOfClass:[NSNull class]]){
        self.createTime = dictionary[kUPSModelClassCreateTime];
    }
    if(![dictionary[kUPSModelClassDc] isKindOfClass:[NSNull class]]){
        self.dc = @([dictionary[kUPSModelClassDc] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassDel] isKindOfClass:[NSNull class]]){
        self.del = [dictionary[kUPSModelClassDel] boolValue];
    }
    
    if(![dictionary[kUPSModelClassElec] isKindOfClass:[NSNull class]]){
        self.elec = @([dictionary[kUPSModelClassElec] intValue]);
    }
    
    if(![dictionary[kUPSModelClassFuse] isKindOfClass:[NSNull class]]){
        self.fuse = @([dictionary[kUPSModelClassFuse] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassIdField] isKindOfClass:[NSNull class]]){
        self.idField = @([dictionary[kUPSModelClassIdField] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassInverter] isKindOfClass:[NSNull class]]){
        self.inverter = @([dictionary[kUPSModelClassInverter] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassLamp] isKindOfClass:[NSNull class]]){
        self.lamp = @([dictionary[kUPSModelClassLamp] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassLowPower] isKindOfClass:[NSNull class]]){
        self.lowPower = @([dictionary[kUPSModelClassLowPower] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassMac] isKindOfClass:[NSNull class]]){
        self.mac = dictionary[kUPSModelClassMac];
    }
    if(![dictionary[kUPSModelClassPlug] isKindOfClass:[NSNull class]]){
        self.plug = @([dictionary[kUPSModelClassPlug] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassPower] isKindOfClass:[NSNull class]]){
        self.power = @([dictionary[kUPSModelClassPower] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassPowerCount] isKindOfClass:[NSNull class]]){
        self.powerCount =@( [dictionary[kUPSModelClassPowerCount] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassProductId] isKindOfClass:[NSNull class]]){
        self.productId =@( [dictionary[kUPSModelClassProductId] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassStr] isKindOfClass:[NSNull class]]){
        self.str = dictionary[kUPSModelClassStr];
    }
    if(![dictionary[kUPSModelClassTemperature] isKindOfClass:[NSNull class]]){
        self.temperature =@( [dictionary[kUPSModelClassTemperature] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassThreeFan] isKindOfClass:[NSNull class]]){
        self.threeFan =@( [dictionary[kUPSModelClassThreeFan] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassThreePlug] isKindOfClass:[NSNull class]]){
        self.threePlug =@( [dictionary[kUPSModelClassThreePlug] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassTian] isKindOfClass:[NSNull class]]){
        self.tian = @([dictionary[kUPSModelClassTian] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassUpPower] isKindOfClass:[NSNull class]]){
        self.upPower =@( [dictionary[kUPSModelClassUpPower] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassUpdateTime] isKindOfClass:[NSNull class]]){
        self.updateTime = dictionary[kUPSModelClassUpdateTime];
    }
    if(![dictionary[kUPSModelClassUsb] isKindOfClass:[NSNull class]]){
        self.usb = @([dictionary[kUPSModelClassUsb] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassUserId] isKindOfClass:[NSNull class]]){
        self.userId = @([dictionary[kUPSModelClassUserId] integerValue]);
    }
    
    if(![dictionary[kUPSModelClassUuids] isKindOfClass:[NSNull class]]){
        self.uuids = dictionary[kUPSModelClassUuids];
    }
    if(![dictionary[kUPSModelClassVoltage] isKindOfClass:[NSNull class]]){
        self.voltage = dictionary[kUPSModelClassVoltage];
    }
    
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ac forKey:kUPSModelClassAc];
    [aCoder encodeObject:self.arrowDown forKey:kUPSModelClassArrowDown];
    [aCoder encodeObject:self.bluetooth forKey:kUPSModelClassBluetooth];
    [aCoder encodeObject:self.buttons forKey:kUPSModelClassButtons];
    if(self.createTime != nil){
        [aCoder encodeObject:self.createTime forKey:kUPSModelClassCreateTime];
    }
    [aCoder encodeObject:self.dc forKey:kUPSModelClassDc];
    [aCoder encodeObject:@(self.del) forKey:kUPSModelClassDel];
    [aCoder encodeObject:self.fuse forKey:kUPSModelClassFuse];
    [aCoder encodeObject:self.idField forKey:kUPSModelClassIdField];
    [aCoder encodeObject:self.inverter forKey:kUPSModelClassInverter];
    [aCoder encodeObject:self.lamp forKey:kUPSModelClassLamp];
    [aCoder encodeObject:self.lowPower forKey:kUPSModelClassLowPower];
    
    if(self.mac != nil){
        [aCoder encodeObject:self.mac forKey:kUPSModelClassMac];
    }
    [aCoder encodeObject:self.plug forKey:kUPSModelClassPlug];
    [aCoder encodeObject:self.power forKey:kUPSModelClassPower];
    [aCoder encodeObject:self.powerCount forKey:kUPSModelClassPowerCount];
    [aCoder encodeObject:self.productId forKey:kUPSModelClassProductId];
    if(self.str != nil){
        [aCoder encodeObject:self.str forKey:kUPSModelClassStr];
    }
    [aCoder encodeObject:self.temperature forKey:kUPSModelClassTemperature];
    [aCoder encodeObject:self.threeFan forKey:kUPSModelClassThreeFan];
    [aCoder encodeObject:self.threePlug forKey:kUPSModelClassThreePlug];
    [aCoder encodeObject:self.tian forKey:kUPSModelClassTian];
    [aCoder encodeObject:self.upPower forKey:kUPSModelClassUpPower];
    if(self.updateTime != nil){
        [aCoder encodeObject:self.updateTime forKey:kUPSModelClassUpdateTime];
    }
    [aCoder encodeObject:self.usb forKey:kUPSModelClassUsb];
    [aCoder encodeObject:self.userId forKey:kUPSModelClassUserId];
    if(self.uuids != nil){
        [aCoder encodeObject:self.uuids forKey:kUPSModelClassUuids];
    }
    [aCoder encodeObject:self.voltage forKey:kUPSModelClassVoltage];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.ac = [aDecoder decodeObjectForKey:kUPSModelClassAc] ;
    self.arrowDown = [aDecoder decodeObjectForKey:kUPSModelClassArrowDown] ;
    self.bluetooth = [aDecoder decodeObjectForKey:kUPSModelClassBluetooth] ;
    self.buttons = [aDecoder decodeObjectForKey:kUPSModelClassButtons] ;
    self.createTime = [aDecoder decodeObjectForKey:kUPSModelClassCreateTime];
    self.dc = [aDecoder decodeObjectForKey:kUPSModelClassDc] ;
    self.del = [[aDecoder decodeObjectForKey:kUPSModelClassDel] boolValue];
    self.elec = [aDecoder decodeObjectForKey:kUPSModelClassElec] ;
    self.fuse = [aDecoder decodeObjectForKey:kUPSModelClassFuse];
    self.idField = [aDecoder decodeObjectForKey:kUPSModelClassIdField];
    self.inverter = [aDecoder decodeObjectForKey:kUPSModelClassInverter];
    self.lamp = [aDecoder decodeObjectForKey:kUPSModelClassLamp];
    self.lowPower = [aDecoder decodeObjectForKey:kUPSModelClassLowPower];
    self.mac = [aDecoder decodeObjectForKey:kUPSModelClassMac];
    self.plug = [aDecoder decodeObjectForKey:kUPSModelClassPlug];
    self.power = [aDecoder decodeObjectForKey:kUPSModelClassPower];
    self.powerCount = [aDecoder decodeObjectForKey:kUPSModelClassPowerCount];
    self.productId = [aDecoder decodeObjectForKey:kUPSModelClassProductId];
    self.str = [aDecoder decodeObjectForKey:kUPSModelClassStr];
    self.temperature = [aDecoder decodeObjectForKey:kUPSModelClassTemperature];
    self.threeFan = [aDecoder decodeObjectForKey:kUPSModelClassThreeFan];
    self.threePlug = [aDecoder decodeObjectForKey:kUPSModelClassThreePlug];
    self.tian = [aDecoder decodeObjectForKey:kUPSModelClassTian];
    self.upPower = [aDecoder decodeObjectForKey:kUPSModelClassUpPower];
    self.updateTime = [aDecoder decodeObjectForKey:kUPSModelClassUpdateTime];
    self.usb = [aDecoder decodeObjectForKey:kUPSModelClassUsb];
    self.userId = [aDecoder decodeObjectForKey:kUPSModelClassUserId];
    self.uuids = [aDecoder decodeObjectForKey:kUPSModelClassUuids];
    self.voltage = [aDecoder decodeObjectForKey:kUPSModelClassVoltage];
    return self;
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    UpsModel *copy = [UpsModel new];
    
    copy.ac = self.ac;
    copy.arrowDown = self.arrowDown;
    copy.bluetooth = self.bluetooth;
    copy.buttons = self.buttons;
    copy.createTime = [self.createTime copy];
    copy.dc = self.dc;
    copy.del = self.del;
    copy.elec = self.elec;
    copy.fuse = self.fuse;
    copy.idField = self.idField;
    copy.inverter = self.inverter;
    copy.lamp = self.lamp;
    copy.lowPower = self.lowPower;
    copy.mac = [self.mac copy];
    copy.plug = self.plug;
    copy.power = self.power;
    copy.powerCount = self.powerCount;
    copy.productId = self.productId;
    copy.str = [self.str copy];
    copy.temperature = self.temperature;
    copy.threeFan = self.threeFan;
    copy.threePlug = self.threePlug;
    copy.tian = self.tian;
    copy.upPower = self.upPower;
    copy.updateTime = [self.updateTime copy];
    copy.usb = self.usb;
    copy.userId = self.userId;
    copy.uuids = [self.uuids copy];
    copy.voltage = self.voltage;
    
    return copy;
}

@end
