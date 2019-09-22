//
//  SystemTestViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/20.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpsModel.h"
typedef enum:NSInteger{
    BatteryType = 0,
    USBPortsType,
    DCPort,
    Fuse,
    Temperature,
    Inverter,
    ExpansionPort,
    SolarPort,
    WindGeneratorPort
}StateType;
NS_ASSUME_NONNULL_BEGIN

@interface SystemTestViewController : UITableViewController
@property (strong, nonatomic) IBOutletCollection(UILabel ) NSArray *statusLabelArray;
//图标显示错误或者正确的小标识
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *statusImageViews;
// 拿到系统状态
@property (nonatomic, strong) IBOutlet UIImageView *inverterImageView;
@property (nonatomic, strong) UpsModel *model;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *waitingLabel;
@property (nonatomic, strong) NSMutableArray *systemStatus;

@end

NS_ASSUME_NONNULL_END
