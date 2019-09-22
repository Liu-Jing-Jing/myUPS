//
//  SearchBLEViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/22.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "BleAutoConnectionViewController.h"
#import "PowerBleDevice.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PopActionBlock)(PowerBleDevice *device);
@interface SearchBLEViewController : BleAutoConnectionViewController
@property (nonatomic, copy) PopActionBlock pop;
@end

NS_ASSUME_NONNULL_END
