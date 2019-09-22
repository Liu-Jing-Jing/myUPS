//
//  PowerBleDevice.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/19.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "BaseBleDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface PowerBleDevice : BaseBleDevice
- (void)historyMachineDataWithResultBlock:(void(^)(NSString *dataString))returnBlock;
- (NSData *)syncCurrentTimeCommand;
/** 得到UUID地址*/
- (void)getUUIDResultBlock:(void(^)(NSString *result, NSString *macString))returnBlock;
/** 得到Mac地址*/
- (void)MachineAddressCodeResultBlock:(void(^)(NSString *result, NSString *macString))returnBlock;
- (void)setStartCommandWithSyncMacineTimeSuccess:(void(^)(void))successBlock;
//- (NSString *)currentActivityMachineData;
- (void)currentActivityMachineDataWithResultBlock:(void(^)(NSData *result))returnBlock;
@end

NS_ASSUME_NONNULL_END		
