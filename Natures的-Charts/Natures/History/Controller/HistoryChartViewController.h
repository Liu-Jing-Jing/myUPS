//
//  HistoryChartViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/19.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentBaseViewController.h"
#import "UpsModel.h"
#import "ChartHeaderView.h"
NS_ASSUME_NONNULL_BEGIN
@class HistoryChartViewController;
@protocol HistoryChartViewControllerDelegate <NSObject>
@required
- (void)historyChartVCWillChangeCalendarData:(NSData *)currentData withCurrentIndex:(int)index;

@end
@interface HistoryChartViewController : ContentBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, assign) HistoryType type;
@property (nonatomic, assign) CAL_MODE mode;
@property (nonatomic, strong) NSString *machineID; //机器的uuID
@property(nonatomic,weak)id<HistoryChartViewControllerDelegate> dateDelegate;
@property (nonatomic, strong) NSArray<UpsModel *>*modelArray;
@end

NS_ASSUME_NONNULL_END
