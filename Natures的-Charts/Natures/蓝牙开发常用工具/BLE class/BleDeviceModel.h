//
//  BleDeviceModel.h
//  Natures
//
//  Created by 柏霖尹 on 2019/9/5.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface BleDeviceModel : JKDBModel
/** 本地存的设备昵称*/
@property (nonatomic, strong) NSString *nickname;
/** mac地址的字段*/
@property (nonatomic, strong) NSString *macString;

/** 唯一的蓝牙标似*/
@property (nonatomic, strong) NSString *uuidString;
@end

NS_ASSUME_NONNULL_END
