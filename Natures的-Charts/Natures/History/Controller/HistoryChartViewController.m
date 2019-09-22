//
//  HistoryChartViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/19.
//  Copyright © 2019 com.sjty. All rights reserved.
#import "HistoryChartViewController.h"
#import "JXCategoryTitleView.h"
#import "ChartViewController.h"
#import "EMSTwoButtonPopView.h"
#import "QFDatePickerView.h"
#import "JTCalendar.h"
#import "UIColor+HW.h"
@interface HistoryChartViewController ()<JTCalendarDelegate>
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property (nonatomic, strong) NSMutableArray *currentArray;


@end

@implementation HistoryChartViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kThemeColor;
   // NSLog(@"%d", self.type);
    if (self.titles == nil)
    {
        self.titles = @[@"DAY", @"MONTH", @"YEAR"];
        //        self.titles = @[@"DAY", @"WEEK", @"MONTH", @"YEAR"];
    }
    //self.view.backgroundColor = [UIColor colorWithRed:34/255.0 green:37/255.0 blue:46/255.0 alpha:1];
    self.myCategoryView.titles = self.titles;
    [self setupData];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleDone target:self action:@selector(clickedChangeButton:)];
    //传给下一个控制器
}

- (void)clickedChangeButton:(UIBarButtonItem *)sneder
{
    if([self.dateDelegate respondsToSelector:@selector(historyChartVCWillChangeCalendarData:withCurrentIndex:)])
    {
        // 设置日历控件出来
        
        switch (self.categoryView.selectedIndex)
        {
            case 0:
            {
                EMSTwoButtonPopView *twoPopUpView = [EMSTwoButtonPopView twoButtonPopViewInstance];
                twoPopUpView.secondBlock = ^{
                    // cancel
                    NSLog(@"设置日期");
                };
                
                twoPopUpView.selectCalendarBlock = ^(NSDate * date) {
                    NSLog(@"当前选择的date  %@", date);
//                    self.header.title = [date convertToMessageFormat];
                    [self.dateDelegate historyChartVCWillChangeCalendarData:date withCurrentIndex:1];
                    [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {}];
                    
                };
                [WPAlertControl alertForView:twoPopUpView begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self maskClick:nil animateStatus:nil];
            }
                break;
            case 1:
            {
                QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithSUperView:self.view response:^(NSString *str) {
                    NSString *string = str;
                    NSLog(@"str = %@",string);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-dd"];
                    
                    [self.dateDelegate historyChartVCWillChangeCalendarData:(NSDate *)[formatter dateFromString:string] withCurrentIndex:1];
                }];
                [datePickerView show];
            }
                break;
            case YEAR:
            {
                QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initYearPickerWithView:self.view response:^(NSString *str) {
                    NSString *string = str;
                    NSLog(@"str = %@",string);
                    //更新图表的年
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-dd"];
                    [self.dateDelegate historyChartVCWillChangeCalendarData:[formatter dateFromString:string] withCurrentIndex:1];
                }];
                [datePickerView show];
            }
                break;
            default:
                break;
        }
        
    }
}


- (void)setupData
{
    //
    //    NSMutableArray *currentDatas = [NSMutableArray array];
    //
    //    for (UpsModel *model in self.modelArray)
    //    {
    //        // 拿到每个模型中需要的属性值
    //        id value = [model valueForKey:self.propertyName];
    //        [currentDatas addObject:value];
    //    }
    //    self.currentArray = currentDatas;
}

#pragma mark - Delegate
- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    
    ChartViewController *vc = [[ChartViewController alloc] init];
    vc.historyType = self.type;
#warning 设置控制器的内容
    if(index == 0)
    {
        vc.mode = DAY;
        vc.vcIndex = 0;
        vc.title = @"0";
    }
    else if (index == 1)
    {
        vc.mode = MONTH;
        vc.title = @"1";
        vc.vcIndex = 1;
    }
    else if (index == 1)
    {
        vc.title = @"1";
        vc.mode = MONTH;
        vc.vcIndex = 1;
    }
    else if (index == 2)
    {
        vc.mode = YEAR;
        vc.vcIndex = 2;
        vc.title = @"2";
    }
    
#warning 设置每种模式下的则线图
    self.dateDelegate = vc;
    //当天的模型
    vc.machineID = self.machineID;
    vc.modelArray = self.modelArray;
    return vc;
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}
@end
