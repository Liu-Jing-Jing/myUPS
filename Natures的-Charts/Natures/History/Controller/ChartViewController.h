//
//  ChartViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/19.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "ChartHeaderView.h"
#import "UpsModel.h"
#import "HistoryChartViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChartViewController : UIViewController<JXCategoryListContentViewDelegate, HistoryChartViewControllerDelegate>
@property (nonatomic, assign) CAL_MODE mode;
@property (nonatomic, strong) NSString *machineID; //设备的唯一编号
@property (nonatomic, strong) NSArray<UpsModel *>*modelArray;
@property (nonatomic, strong) NSArray<NSNumber *>*yValues;
@property (nonatomic, assign) HistoryType historyType;
@property (nonatomic, assign) int vcIndex;
@end

NS_ASSUME_NONNULL_END
