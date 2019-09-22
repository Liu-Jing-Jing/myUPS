//
//  UpsModel.h
//  Natures
//
//  Created by 柏霖尹 on 2019/8/7.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpsModel : NSObject
@property (nonatomic, strong) NSNumber* temperature;

/**  Power Used使用功率使用这个*/
@property (nonatomic, strong) NSNumber* power;
/** 转换一下  yyyy-MM-dd HH:mm:ss*/
@property (nonatomic, strong) NSString * createTime;
/**  电压使用情况*/
@property (nonatomic, strong) NSString* voltage;

@property (nonatomic, strong) NSString* noMean;

/** 逆变器状态*/
@property (nonatomic, strong) NSNumber* inverter;
/** 灯状态*/
@property (nonatomic, strong) NSNumber* lamp;

/** Fuse*/
@property (nonatomic, strong) NSNumber* fuse;//7
@property (nonatomic, strong) NSNumber* ac;
/** */
@property (nonatomic, strong) NSNumber* arrowDown;
/** 低电量*/
@property (nonatomic, strong) NSNumber* lowPower;

@property (nonatomic, strong) NSNumber* buttons;

@property (nonatomic, strong) NSNumber* dc;

@property (nonatomic, strong) NSNumber* usb;
/** 三个接口*/
@property (nonatomic, strong) NSNumber* threePlug;
/** 灯状态*/
@property (nonatomic, strong) NSNumber* upPower;

/** 蓝牙指示灯*/
@property (nonatomic, strong) NSNumber* bluetooth;
/** 风能接口*/
@property (nonatomic, strong) NSNumber* threeFan; //17
/** 太阳能接口*/
@property (nonatomic, strong) NSNumber* tian;
/** 扩展接口*/
@property (nonatomic, strong) NSNumber* plug;
/** 电池格数*/
@property (nonatomic, strong) NSNumber* powerCount;
@property (nonatomic, strong) NSNumber*  elec;
@property (nonatomic, strong) NSString * mac;
@property (nonatomic, strong) NSString * uuids;
//不知道作用的数据      不知道作用的数据  不知道作用的数据
@property (nonatomic, strong) NSNumber* idField;
@property (nonatomic, strong) NSString * str;
@property (nonatomic, strong) NSNumber* productId;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * systemTestResString;
@property (nonatomic, assign) BOOL del;

/* 上传网络使用的字段 str*/
@property (nonatomic, strong) NSString *historyString;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSArray<NSString *> *)getAllObjCIvarList;

@end
NS_ASSUME_NONNULL_END
