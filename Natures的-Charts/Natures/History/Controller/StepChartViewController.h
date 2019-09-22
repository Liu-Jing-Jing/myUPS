//
//  StepChartViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/8/30.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "ChartHeaderView.h"
#import "UpsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StepChartViewController : UIViewController
@property (nonatomic, assign) CAL_MODE calendarMode;
@property (nonatomic, strong) NSArray<UpsModel *>*modelArray;
@property (nonatomic, strong) NSArray<NSNumber *>*yValues;

@end

NS_ASSUME_NONNULL_END
