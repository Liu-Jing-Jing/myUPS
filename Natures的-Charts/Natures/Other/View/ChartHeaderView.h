//
//  ChartHeaderView.h
//  AirMachine
//
//  Created by sjty on 2019/2/23.
//  Copyright © 2019年 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    DAY,
    WEEK,
    MONTH,
    YEAR
} CAL_MODE;

typedef enum : NSUInteger {
    DateWeek,//按周
    DateMonth,//按月
} DateType;
NS_ASSUME_NONNULL_BEGIN
@class ChartHeaderView;
@protocol ChartHeaderDelegate <NSObject>
-(void)chartHeaderView:(ChartHeaderView *)chartHeaderView StartTime:(NSString *)startTime EndTime:(NSString *)endTime;
-(void)chartHeaderView:(ChartHeaderView *)chartHeaderView didChangeDate:(NSDate *)currentDate;
-(void)chartHeaderView:(ChartHeaderView *)chartHeaderView didChangeNextDate:(NSDate *)currentDate;
@end

@interface ChartHeaderView : UIView
@property(nonatomic,weak)id<ChartHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,copy)NSString *title;
@property (nonatomic, assign) CAL_MODE mode;
@end

NS_ASSUME_NONNULL_END
