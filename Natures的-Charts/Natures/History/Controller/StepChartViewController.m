//
//  StepChartViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/30.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "StepChartViewController.h"
#import "YASimpleGraphView.h"
#import "Masonry.h"
#import "UpsModel.h"
#import "NSDate+Helper.h"
#import "JTCalendarManager.h"
#import "JTHorizontalCalendarView.h"
#import "EMSTwoButtonPopView.h"
#import "AAChartKit.h"
@interface StepChartViewController ()
@property (nonatomic, strong) AAChartView *aaChartView;
@property (nonatomic, strong) ChartHeaderView *header;
@property (nonatomic, copy) NSArray *indexArray;
@end

@implementation StepChartViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.darkGrayColor;
    // Do any additional setup after loading the view from its nib.
    ChartHeaderView *header = [[ChartHeaderView alloc] init];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(35);
    }];
    
    //if(self.calendarMode) header.mode = self.mode;
    //[self setupData];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择日期" style:UIBarButtonItemStyleDone target:self action:@selector()];
}


- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    NSMutableArray *todayData = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    // 解析数据
    for(int i=0;i<self.modelArray.count;i++)
    {
        UpsModel *model = modelArray[i];
        NSTimeInterval  timeInterval = [[NSDate convertSJTYServerFormatToNSDateWithStr:model.createTime] timeIntervalSinceNow];
        timeInterval = -timeInterval;
        NSDate *date = [NSDate convertSJTYServerFormatToNSDateWithStr:model.createTime];
        NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *comps  = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:unitFlags fromDate:date];
        //        [todayData addObject:@(comps.hour).stringValue];
        [todayData addObject:[NSString stringWithFormat:@"%d", i+1]];
        [yArray addObject:self.yValues[i].stringValue];
    }
    //self.allDates = [todayData copy];
    //self.allValues = [yArray copy];
    
    //self.allDates = @[@"11", @"12", @"13", @"14", @"15"];
    //self.allValues = @[@"411", @"411", @"421", @"421", @"421"];
    // 创建玩数据后 开始创建图表
}

- (void)setupData
{
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateFormat = @"yyyy-mm-dd";
    //
    //    [HttpTool getUpsRangeDataWithStartDate:[formatter dateFromString:@"2019-07-10"] endDate:[formatter dateFromString:@"2019-07-30"] success:^(id  _Nonnull response) {
    //        NSLog(@"%@", response[@"message"]);
    //    } failure:^(NSError * _Nonnull error) {
    //        //
    //    }];
    //    [HttpTool getUpsDateByYYYYstring:@"2019" success:^(NSArray *response) {
    //        //
    //        NSLog(@"年的数据  %@", response);
    //    } failure:^(NSError * _Nonnull error) {
    //        //出错处理
    //    }];
    
}
- (void)setCalendarMode:(CAL_MODE)calendarMode
{
    _calendarMode = calendarMode;
    [self setupAAChartWithCalendarMode:calendarMode];
}


- (void)setupAAChartWithCalendarMode:(CAL_MODE)mode
{
    //CGFloat chartViewWidth  = self.view.frame.size.width;
    //CGFloat chartViewHeight = self.view.frame.size.height-250;
    self.aaChartView = [[AAChartView alloc]init];
    //    _aaChartView.frame = CGRectMake(0, 60, 320, chartViewHeight);
    ////禁用 AAChartView 滚动效果(默认不禁用)
    self.aaChartView.scrollEnabled = YES;
    ////设置图表视图的内容高度(默认 contentHeight 和 AAChartView 的高度相同)
    //_aaChartView.contentHeight = chartViewHeight;
    [self.view addSubview:_aaChartView];
    [self.aaChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(35);
        make.height.mas_equalTo(self.view.height*0.5);
    }];
    
    NSDate *now = [NSDate date];
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *comps  = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:unitFlags fromDate:now];
    NSMutableArray *xData = [NSMutableArray array];
    NSMutableArray *xtitles = [NSMutableArray array];
    if(mode == DAY)
    {
        
        xtitles = [NSMutableArray array];
        for (int i = 1; i<=60; i++)
        {
            NSString *timeStr = [NSMutableString stringWithFormat:@"17:%02dPM", i];
            [xtitles addObject:timeStr];
        }
        xData = @[@0.0,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new, @1.0,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,@0.0,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,@0.0,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,NSNull.new,@1.0].mutableCopy;
    }
    else if (mode == WEEK)
    {
        for (int i = 1; i<=7; i++)
        {
            xtitles = [NSMutableArray array];
            NSString *timeStr = [NSMutableString stringWithFormat:@"星期几"];
            [xtitles addObject:timeStr];
            xData = @[@0.0, @0.0, @1.0, @1.0, @0.0, @0.0, @0.0].mutableCopy;
        }
    }
    else if (mode == MONTH)
    {
        for (int i = 1; i<=30; i++)
        {
            xtitles = [NSMutableArray array];
            NSString *timeStr = [NSMutableString stringWithFormat:@"8月几号"];
            [xtitles addObject:timeStr];
            xData = @[@0.0, @0.0, @1.0, @1.0, @0.0, @0.0, @0.0, @0.0, @1.0, @1.0, @0.0, @0.0, @0.0, @0.0, @1.0, @1.0, @0.0, @0.0, @0.0, @0.0, @1.0, @1.0, @0.0, @0.0, @0.0, @0.0, @1.0, @1.0, @0.0, @0.0, @0.0, @0.0].mutableCopy;
        }
    }
    else if (mode == YEAR)
    {
        xtitles = [NSMutableArray array];
        
        xData = [xData mutableCopy];
        for (int i = 1; i<=365; i++)
        {
            NSString *timeStr = [NSMutableString stringWithFormat:@"天"];
            [xtitles addObject:@"SB".add([NSString stringWithFormat:@"%d", i])];
            [xData addObject:@(1)];
        }
        
        for(int i=0;i<365;i++)
        {
            if(i%100 == 0) xData[i] = @(0);
        }
    }
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeLine)//设置图表的类型(这里以设置的为折线图为例)
    //.titleSet(@"接口状态")//设置图表标题//.subtitleSet(@"数据")//设置图表副标题
    .categoriesSet(xtitles)//图表横轴的内容
    .yAxisTitleSet(@"接口开关")//设置图表 y 轴的单位
    .yAxisMinSet(@0.0)
    .yAxisMaxSet(@1.5)
    .yAxisLabelsEnabledSet(NO)
    .connectNullsSet(YES)
    .zoomTypeSet(AAChartZoomTypeX)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .stepSet(@YES)
                 .nameSet(@"2019")
                 .showInLegendSet(NO)
                 .dataSet(xData)
                 ]);
    
    [_aaChartView aa_drawChartWithChartModel:aaChartModel];
}
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView
{
    return self.view;
}

- (void)listDidAppear {}

- (void)listDidDisappear {}

// setup UI controls
- (void)setupYYChart {
    //    // Create a gradient to apply to the bottom portion of the graph
    //    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    //    size_t num_locations = 2;
    //    CGFloat locations[2] = { 0.0, 1.0 };
    //    CGFloat components[8] = {
    //        0.33, 0.67, 0.93, 0.25,
    //        1.0, 1.0, 1.0, 1.0
    //    };
    //
    //    YASimpleGraphView *graphView = [[YASimpleGraphView alloc]init];
    //    graphView.frame = CGRectMake(15, 200, 375-30, 200);
    //    graphView.backgroundColor = [UIColor whiteColor];
    //    graphView.allValues = _allValues;
    //    graphView.allDates = _allDates;
    //    graphView.defaultShowIndex = _allDates.count-1;
    //    graphView.delegate = self;
    //    graphView.lineColor = [UIColor grayColor];
    //    graphView.lineWidth = 1.0/[UIScreen mainScreen].scale;
    //    graphView.lineAlpha = 1.0;
    //    graphView.enableTouchLine = YES;
    
    //graphView.topAlpha = 1.0;
    //graphView.topColor = [UIColor orangeColor];
    //graphView.topGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    //graphView.bottomAlpha = 1.0;
    //    //graphView.bottomColor = [UIColor orangeColor];
    //    graphView.bottomGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    //
    //    [self.view addSubview:graphView];
    //    [graphView startDraw];
}
@end
