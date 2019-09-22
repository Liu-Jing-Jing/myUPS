#import "ChartViewController.h"
#import "YASimpleGraphView.h"
#import "Masonry.h"
#import "UpsModel.h"
#import "NSDate+Helper.h"
#import "JTCalendarManager.h"
#import "JTHorizontalCalendarView.h"
#import "EMSTwoButtonPopView.h"
#import "NSDate+Helper.h"
#import "Natures-Bridging-Header.h"
#import "DateValueFormatter.h"
#import "SymbolsValueFormatter.h"
#import "QFDatePickerView.h"
#import "PopUpDatePickerView.h"
#import "QFYearPickerView.h"
#import "UIColor+HW.h"
@interface ChartViewController ()<ChartViewDelegate, ChartHeaderDelegate, HistoryChartViewControllerDelegate>
@property (nonatomic, strong) UILabel *powerUsedLabel;
@property (nonatomic, strong) ChartHeaderView *header;
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *yAxisName;
@property (nonatomic, strong) UILabel *yNameLabel;
@property (nonatomic, copy) NSArray *indexArray;
@property (nonatomic, assign) BOOL isStepLine;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIButton *changeCalendarButton;
@property (nonatomic, assign) BOOL isPowerUsed;
@end

@implementation ChartViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kThemeColor;
    if(self.mode == DAY) self.vcIndex = 0;
    if(self.mode == MONTH) self.vcIndex = 1;if(self.mode == YEAR) self.vcIndex = 2;
    // Do any additional setup after loading the view from its nib.
    ChartHeaderView *header = [[ChartHeaderView alloc] init];
    header.delegate = self;
    self.changeCalendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeCalendarButton addTarget:self action:@selector(changeCalendar) forControlEvents:UIControlEventTouchDown];
#warning 打开更新功能;
    [self.view addSubview:header];
    [self.view addSubview:self.changeCalendarButton];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(35);
    }];
    
    [self.changeCalendarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(35);
    }];
    self.powerUsedLabel = [[UILabel alloc] init];
    [self.view addSubview:self.powerUsedLabel];
    [self.powerUsedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([[UIApplication sharedApplication] statusBarFrame].size.width);
        make.height.mas_equalTo(35);
        make.center.mas_equalTo(self.view.center);
    }];
    self.powerUsedLabel.textAlignment = NSTextAlignmentCenter;
    self.powerUsedLabel.textColor = UIColor.whiteColor;
    
    UILabel *yNameLabel = [[UILabel alloc] init];
    yNameLabel.textAlignment = NSTextAlignmentLeft;
    self.yNameLabel = yNameLabel;
    [self.yNameLabel setTextColor:UIColor.whiteColor];
    [self.view addSubview:yNameLabel];
    [self.yNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(35);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    if(self.mode) header.mode = self.mode;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择日期" style:UIBarButtonItemStyleDone target:self action:@selector()];
    
    
    [MBProgressHUD showSuccess:@"Loading..." toView:self.view];
    [self getHistoryDataWithCalendarType:self.mode]; //得到历史数据
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    //self.allDates = [todayData copy];
    //self.allValues = [yArray copy];
    // 创建玩数据后 开始创建图表
}

- (void)setMode:(CAL_MODE)mode
{
    _mode = mode;
}

- (void)chartHeaderView:(ChartHeaderView *)chartHeaderView didChangeNextDate:(NSDate *)currentDate
{
    // 修改了时间
    switch (self.mode)
    {
        case DAY:
        {
            [UpsNetworkingTools getUpsRangeDataWithCurrentDay:currentDate UUIDString:self.machineID success:^(id  _Nonnull response) {
                // 昨天的数据
                NSLog(@"前几天的数据");
                self.modelArray = response;
                //更新表格
                [self updateChartData:DAY usingDatePicker:NO];
                
            } failure:^(NSError * _Nonnull error) {
                //
            }];
        }
            break;
        case MONTH:
        {
            [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYMMstring:[currentDate convertToNumberStringYYYYmm] success:^(NSArray * _Nonnull response) {
                [self updateChartData:DAY usingDatePicker:NO];
            } failure:^(NSError * _Nonnull error) {
                //错误的处理方式;
            }];
            
        }
            break;
        case YEAR:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY"];
            [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYstring:[formatter stringFromDate:currentDate] success:^(NSArray * _Nonnull response) {
                // 2019年份
                self.modelArray = response;
                if(self.mode || self.historyType)
                    [self updateChartData:DAY usingDatePicker:NO];
            } failure:^(NSError * _Nonnull error) {
                //错误的处理方法
            }];
            
        }
        default:
            break;
    }
}
- (void)chartHeaderView:(ChartHeaderView *)chartHeaderView didChangeDate:(NSDate *)currentDate
{
    // 修改了时间
    switch (self.mode)
    {
        case DAY:
        {
            [UpsNetworkingTools getUpsRangeDataWithCurrentDay:currentDate UUIDString:self.machineID success:^(id  _Nonnull response) {
                // 昨天的数据
                NSLog(@"前几天的数据");
                self.modelArray = response;
                //更新表格
                [self updateChartData:DAY usingDatePicker:NO];
                
            } failure:^(NSError * _Nonnull error) {
                //
            }];
        }
            break;
        case MONTH:
        {
            [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYMMstring:[currentDate convertToNumberStringYYYYmm] success:^(NSArray * _Nonnull response) {
                [self updateChartData:DAY usingDatePicker:NO];
            } failure:^(NSError * _Nonnull error) {
                //错误的处理方式;
            }];
            
        }
            break;
        case YEAR:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY"];
            [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYstring:[formatter stringFromDate:currentDate] success:^(NSArray * _Nonnull response) {
                // 2019年份
                self.modelArray = response;
                if(self.mode || self.historyType)
                    [self updateChartData:DAY usingDatePicker:NO];
            } failure:^(NSError * _Nonnull error) {
                //错误的处理方法
            }];
            
        }
        default:
            break;
    }
}

- (void)historyChartVCWillChangeCalendarData:(NSData *)currentData withCurrentIndex:(int)index
{
    if(self.vcIndex == index)
    {
        NSLog(@"%d,------ %d", self.vcIndex, index);
        
        //[self changeCalendar];
    }
}
#pragma mark - 设置日期的控件
- (void)changeCalendar
{
    if(self.historyType == PowerUsed)
    {
        //发送其他的网络请求
        [self noDataSetupChatView];
        return;
    }
    
    
    switch (self.mode)
    {
        case DAY:
        {
            EMSTwoButtonPopView *twoPopUpView = [EMSTwoButtonPopView twoButtonPopViewInstance];
            twoPopUpView.selectCalendarBlock = ^(NSDate * date) {
                NSLog(@"当前选择的date  %@", date);
                self.header.title = [date convertToMessageFormat];
                [UpsNetworkingTools getUpsRangeDataWithCurrentDay:date UUIDString:self.machineID success:^(id  _Nonnull response) {
                    self.modelArray = response;
                    //update chart
                    if (self.modelArray.count==0)
                    {
                        //清空数据
                        [self noDataSetupChatView];
                    }else{
                        
                        if(self.mode || self.historyType)
                        {
                            [self updateChartData:DAY usingDatePicker:NO];
                        }
                    }
                } failure:^(NSError * _Nonnull error) {
                    // 出错的处理方式
                }];
                [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {}];
                
            };
            [WPAlertControl alertForView:twoPopUpView begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self maskClick:nil animateStatus:nil];
        }
            break;
        case MONTH:
        {
            QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithSUperView:self.view response:^(NSString *str) {
                NSString *string = [[str componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
                NSLog(@"str = %@",string);
                [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYMMstring:string success:^(NSArray * _Nonnull response) {
                    self.modelArray = response;
                    if (response.count==0)
                    {
                        //清空数据
                        [self noDataSetupChatView];
                    }
                    else{
                        if(self.mode || self.historyType)
                        {
                            [self updateChartData:MONTH usingDatePicker:NO];
                        }
                    }
                } failure:^(NSError * _Nonnull error) {
                    //错误的处理方式;
                }];
            }];
            [datePickerView show];
        }
            break;
        case YEAR:
        {
            QFYearPickerView *yearPickerView = [[QFYearPickerView alloc] initDatePackerWithSUperView:self.view response:^(NSString *str) {
                
                NSString *string = str;
                NSLog(@"str = %@",string);
                [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYstring:string success:^(NSArray * _Nonnull response) {
                    // 2019年份
                    self.modelArray = response;
                    if (response.count==0)
                    {
                        //清空数据
                        [self noDataSetupChatView];
                    }else{
                        if(self.mode || self.historyType)
                        {
                            [self updateChartData:YEAR usingDatePicker:NO];
                        }
                    }
                } failure:^(NSError * _Nonnull error) {
                    //错误的处理方法
                }];
            }];
            [yearPickerView show];
        }
            break;
        default:
            break;
    }
    
    
}
// 设置图表然后开始操作
- (void)setupAAChartWithCalendarMode:(CAL_MODE)mode withHistoryType:(HistoryType)Historytype
{
    //CGFloat chartViewWidth  = self.view.frame.size.width;
    //CGFloat chartViewHeight = self.view.frame.size.height-250;
    self.chartView = [[LineChartView alloc] init];
    if(!self.chartView.superview) [self.view addSubview:self.chartView];
    self.chartView.delegate = self;
    if(self.isStepLine)
    {
        self.chartView.leftAxis.granularity=1; // 设置y轴显示1个间隔
    }
    else
    {
        self.chartView.leftAxis.granularity=0.1; // 设置y轴显示1个间隔
    }
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.height.mas_equalTo(self.view.height*0.75);
    }];
    
    NSMutableArray *xData = [NSMutableArray array];
    NSMutableArray *xtitles = [NSMutableArray array];
    self.isPowerUsed = NO;
    switch (Historytype) {
        case OutputWatt:
            self.typeName = @"Output Wattage";
            self.yAxisName = @"W";
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.power];
                
            }
            break;
        case BatteryV:
            self.typeName = @"Battery Voltage";
            self.yAxisName = @"V";
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.voltage];
                
            }
            break;
        case TemperatureH:
            self.typeName = @"Temperature";
            self.yAxisName = @"F°";
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.temperature];
                
            }
            break;
        case PowerUsed:
            self.isPowerUsed = YES;
            self.typeName = @"PowerUsed";
            self.yAxisName = @"";
            for (UpsModel *data in self.modelArray)
            {
#warning 使用量需要修改的
                [xData addObject:data.power];
                
            }
            break;
        case Solar:
            self.typeName = @"Solar Panel";
            self.yAxisName = @"";
            self.isStepLine = YES;
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.tian];
            }
            break;
        case Wind:
            self.typeName = @"Wind Generator";
            self.yAxisName = @"";
            self.isStepLine = YES;
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.threeFan];
            }
            break;
        case AC:
            self.typeName = @"AC Charger";
            self.yAxisName = @"";
            self.isStepLine = YES;
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.ac];
            }
            break;
        default:
            break;
    }
    self.yNameLabel.text = self.yAxisName;
    // 设置XY的样式再绘制数据
    [self setupChartAxisStyles:self.chartView];
    
    if(mode == DAY)
    {
        [self setupDataWithCalendarMode:DAY dataArray: xData];
    }
    else if (mode == WEEK)
    {
        //        for (int i = 1; i<=7; i++)
        //        {
        //            xtitles = [NSMutableArray array];
        //            NSString *timeStr = [NSMutableString stringWithFormat:@"星期几"];
        //            [xtitles addObject:timeStr];
        //            xData = @[@0.0, @0.0, @1.0, @1.0, @0.0, @0.0, @0.0].mutableCopy;
        //        }
        //
        //        [self setupDataWithCalendarMode:DAY dataArray: xData];
    }
    else if (mode == MONTH)
    {
        [self setupDataWithCalendarMode:MONTH dataArray: xData];
    }
    else if (mode == YEAR)
    {
        [self setupDataWithCalendarMode:YEAR dataArray: xData];
    }
    
}


/** 当手动调节日期的时候*/
- (void)updateChartData:(CAL_MODE)mode usingDatePicker:(BOOL)NOTManualClicked
{
    //if(NOTManualClicked) return;
    NSMutableArray *xData = [NSMutableArray array];
    NSMutableArray *xtitles = [NSMutableArray array];
    self.isPowerUsed = NO;
    switch (self.historyType)
    {
        case OutputWatt:
            self.typeName = @"Output Wattage";
            self.isStepLine = YES;
            self.yAxisName = @"W";
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.power];
                
            }
            break;
        case BatteryV:
            self.typeName = @"Battery Voltage";
            self.yAxisName = @"V";
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.voltage];
                
            }
            break;
        case TemperatureH:
            self.typeName = @"Internal Temperature";
            self.yAxisName = @"F°";
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.temperature];
                
            }
            break;
        case PowerUsed:
            self.isPowerUsed = YES;
            self.typeName = @"Power Used";
            self.yAxisName = @"";
            for (UpsModel *data in self.modelArray)
            {
#warning 使用量需要修改的
                [xData addObject:data.power];
                
            }
            break;
        case Solar:
            self.typeName = @"Solar Panel";
            self.yAxisName = @"";
            self.isStepLine = YES;
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.tian];
            }
            break;
        case Wind:
            self.typeName = @"Wind Generator";
            self.yAxisName = @"";
            self.isStepLine = YES;
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.threeFan];
            }
            break;
        case AC:
            self.typeName = @"AC Charger";
            self.yAxisName = @"";
            self.isStepLine = YES;
            for (UpsModel *data in self.modelArray)
            {
                [xData addObject:data.ac];
            }
            break;
        default:
            break;
    }
    
    // PowerUser的处理方式
    if(self.isPowerUsed)
    {
        if(mode == DAY)
        {
            
        }
        else if (mode == WEEK)
        {
        }
        else if (mode == MONTH)
        {
            
        }
        else if (mode == YEAR)
        {
        }
    }
    
    
    if(mode == DAY)
    {
        [self setupDataWithCalendarMode:DAY dataArray: xData];
    }
    else if (mode == WEEK)
    {
        [self setupDataWithCalendarMode:WEEK dataArray: xData];
    }
    else if (mode == MONTH)
    {
        [self setupDataWithCalendarMode:MONTH dataArray: xData];
        
    }
    else if (mode == YEAR)
    {
        [self setupDataWithCalendarMode:YEAR dataArray: xData];
    }
}

- (NSMutableArray *)addtionPointToChartViewData:(NSArray *)datas withTimeString:(NSArray *)timeStrings
{
    NSMutableArray<ChartDataEntry *> *allPoints = [NSMutableArray array];
    
    if(self.isStepLine)
    {
#warning 修复补点地方的BUG
        double currentValue = [[datas firstObject] doubleValue]; //拿到第一个点
        NSNumber *xValues1 = [timeStrings firstObject];
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:xValues1.doubleValue y:[[datas firstObject] doubleValue]];
        [allPoints addObject:entry];
        if(datas.count>1){
            for(int i=1; i<timeStrings.count; i++)
            {
                NSNumber *xValues = timeStrings[i];
                NSNumber *yValues = datas[i];
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:xValues.doubleValue y:[datas[i] doubleValue]];
                
                if(currentValue-yValues.doubleValue >0)
                {
                    //单调递减 现在要补充一个相同的点 然后再添件真数据
                    ChartDataEntry *entryNew = [[ChartDataEntry alloc] initWithX:xValues.doubleValue+1 y:currentValue];
                    [allPoints addObject:entryNew];
                }
                else if(currentValue-yValues.doubleValue<0)
                {
                    ChartDataEntry *entryNew = [[ChartDataEntry alloc] initWithX:xValues.doubleValue y:currentValue];
                    [allPoints addObject:entryNew];
                }
                
                [allPoints addObject:entry]; // 存放正式的表格entry实体数据
                currentValue = yValues.doubleValue;
                
            }
        }
    }
    else
    {
        for(int i=0;i<timeStrings.count;i++)
        {
            
            ChartDataEntry *entry;
            if(self.mode == DAY)
            {
                NSNumber *xValues = timeStrings[i];
                entry = [[ChartDataEntry alloc] initWithX:xValues.doubleValue y:[datas[i] doubleValue]];
            }
            else if (self.mode == MONTH)
            {
                //月
                NSString *xValues = timeStrings[i];
                //xValues = [xValues substringWithRange:NSMakeRange(xValues.length-2, 2)];
                entry = [[ChartDataEntry alloc] initWithX:xValues.intValue y:[datas[i] doubleValue]];
            }
            else if (self.mode == YEAR)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMM dd"];
                [dateFormatter dateFromString:timeStrings[i]];
#warning 这是一年的第几天 测试这里点正确吗
                NSString *xValues = timeStrings[i];
                entry = [[ChartDataEntry alloc] initWithX:xValues.intValue y:[datas[i] doubleValue]];
            }
            [allPoints addObject:entry]; // 存放正式的表格entry实体数据
        }
    }
    
    return allPoints;
}



// 设置表格的数据集和 补点的方法
- (void)setupDataWithCalendarMode:(CAL_MODE)mode dataArray:(NSArray *)array
{
    NSMutableArray *xtitles = [NSMutableArray array];
    NSMutableArray<ChartDataEntry *> *allPoints = [NSMutableArray array];
    NSMutableArray *timeStrings = [NSMutableArray array];
    
    
    if(mode == DAY)
    {
        for (UpsModel *model in self.modelArray)
        {
            NSString *str = [NSDate ConverthhmmNumberWithDataFormat:model.createTime];
            [timeStrings addObject:str];
            //[timeStrings addObject:[NSDate ConverthhmmNumberWithDataFormat:model.createTime]];
        }
        for(int i=0;i<24;i++)
        {
            for(int J=0;J<60;J++)
            {
                NSString *timeStr = [NSMutableString stringWithFormat:@"%02d:%02d", i, J];
                //1440个点的空数组
                [xtitles addObject:timeStr];
                //[allPoints addObject:NSNull.new];
            }
        }
        
        //[array ]
        NSMutableArray *allPoints = [self addtionPointToChartViewData:array withTimeString:timeStrings];
        __block double arrayMinValue = [[array firstObject] doubleValue];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *value = obj;
            if(value.doubleValue < arrayMinValue)
            {
                arrayMinValue = value.doubleValue;
            }
        }];
        
        
        NSMutableArray *setsArray = [NSMutableArray array];
        for(int i=0;i<1440;i++)
        {
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:0.0];
            if(self.isStepLine) entry = [[ChartDataEntry alloc] initWithX:i y:1.0];
            [setsArray addObject:entry];
        }
        
        self.chartView.xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:xtitles];
        LineChartDataSet *dataset = [[LineChartDataSet alloc] initWithEntries:setsArray];
        [dataset setLabel:@""];
        dataset.drawCirclesEnabled= NO;
        dataset.drawValuesEnabled = NO;
        [dataset setColor:UIColor.lightGrayColor];
        dataset.lineWidth = 0.0;
        
        // allpoint
        LineChartDataSet *actualityDataset = [[LineChartDataSet alloc] initWithEntries:allPoints label:self.typeName];
        actualityDataset.lineWidth = 1.0;
        actualityDataset.drawCirclesEnabled= NO;
        actualityDataset.drawVerticalHighlightIndicatorEnabled = YES;
        actualityDataset.drawHorizontalHighlightIndicatorEnabled = NO;
        
        actualityDataset.drawCirclesEnabled= YES;
        [actualityDataset setCircleColor:UIColor.yellowColor];
        actualityDataset.circleRadius = 1;
        [actualityDataset setColor:[UIColor greenColor]];
        if(self.isStepLine)actualityDataset.drawValuesEnabled = NO;
        // 加入两数据源 用于显示数据和填满X轴
        LineChartData *chartData = [[LineChartData alloc] initWithDataSets:@[dataset, actualityDataset]];
        ChartYAxis *leftAxis = self.chartView.leftAxis;
        leftAxis.axisMinimum = arrayMinValue-0.01;
        
        
        [self.chartView setData:chartData];
        [self.chartView.data notifyDataChanged];
        [self.chartView notifyDataSetChanged];
        //        [self setupChatsLineView];
        
    }
    else if (mode == WEEK)
    {
        
    }
    else if (mode == MONTH)
    {
        
        for (UpsModel *model in self.modelArray)
        {
            NSDate *date = [NSDate convertSJTYServerFormatToNSDateWithStr:model.createTime];
            //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
#warning 多语言的处理
            // 多语言
            //[dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
            //[dateFormatter setDateFormat:@"MMM dd"];
            NSCalendar *gregorian =
            [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSUInteger dayOfMonth =
            [gregorian ordinalityOfUnit:NSDayCalendarUnit
                                 inUnit:NSMonthCalendarUnit forDate:date];
            //[timeStrings addObject:[NSString stringWithFormat@"%d", (int)dayOfMonth]];
            [timeStrings addObject:[NSString stringWithFormat:@"%d", (int)dayOfMonth]];
        }
        
        // 9-01
        
        UpsModel *lastModel = self.modelArray.firstObject;
        NSDate *date = [NSDate convertSJTYServerFormatToNSDateWithStr:lastModel.createTime];
        NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        NSInteger dayCountOfMonth = daysInLastMonth.length;
        
        
        for(int i=0;i<dayCountOfMonth;i++)
        {
            
            NSDate *newDate = [NSDate getDateFromDate:[NSDate getMonthFirstAndLastDayWith:NSDate.date].firstObject withDay:i];
            
            // 多语言
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
            [dateFormatter setDateFormat:@"MMM dd"];
            NSString *datastr = [dateFormatter stringFromDate:newDate];
            [xtitles addObject:datastr];
        }
        
        //[array ]
        __block double arrayMinValue = [[array firstObject] doubleValue];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *value = obj;
            if(value.doubleValue < arrayMinValue)
            {
                arrayMinValue = value.doubleValue; //数组中的最小Y值
            }
        }];
        
        allPoints = [self addtionPointToChartViewData:array withTimeString:timeStrings];
        
        NSMutableArray *setsArray = [NSMutableArray array];
        for(int i=0;i<dayCountOfMonth;i++)
        {
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:0.0];
            if(self.isStepLine) entry = [[ChartDataEntry alloc] initWithX:i y:1.0];
            [setsArray addObject:entry];
        }
        
        self.chartView.xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:xtitles];
        LineChartDataSet *dataset = [[LineChartDataSet alloc] initWithEntries:setsArray];
        [dataset setLabel:@""];
        dataset.drawCirclesEnabled= NO;
        dataset.drawValuesEnabled = NO;
        [dataset setColor:UIColor.lightGrayColor];
        dataset.lineWidth = 0.0;
        
        
        LineChartDataSet *actualityDataset = [[LineChartDataSet alloc] initWithEntries:allPoints label:self.typeName];
        actualityDataset.lineWidth = 1.0;
        actualityDataset.drawCirclesEnabled= NO;
        actualityDataset.drawVerticalHighlightIndicatorEnabled = YES;
        actualityDataset.drawHorizontalHighlightIndicatorEnabled = NO;
        actualityDataset.drawCirclesEnabled= YES;
        [actualityDataset setCircleColor:UIColor.yellowColor];
        actualityDataset.circleRadius = 1;
        [actualityDataset setColor:[UIColor greenColor]];
        if(self.isStepLine)actualityDataset.drawValuesEnabled = NO;
        // 加入两数据源 用于显示数据和填满X轴
        LineChartData *chartData = [[LineChartData alloc] initWithDataSets:@[dataset, actualityDataset]];
        ChartYAxis *leftAxis = self.chartView.leftAxis;
        leftAxis.axisMinimum = arrayMinValue-0.01;
        
        
        [self.chartView setData:chartData];
        [self.chartView.data notifyDataChanged];
        [self.chartView notifyDataSetChanged];
    }
    else if (mode == YEAR)
    {
        //YEAR的数据处理
        for (UpsModel *model in self.modelArray)
        {
            NSDate *date = [NSDate convertSJTYServerFormatToNSDateWithStr:model.createTime];
            
            //tian
            int v = [self getThisDayOfThisYearInDate:date];
            [timeStrings addObject:[NSString stringWithFormat:@"%d", v]];
            
            //[timeStrings addObject:[dateFormatter stringFromDate:[NSString stringWithFormat@"%d",[self getThisDayOfThisYearInDate:date]];
        }
        
        NSString *dateStr = @"2019-12-31";
#warning 本地化的处理
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        int yearCount = [self getThisDayOfThisYearInDate:[formatter dateFromString:dateStr]];
        dateStr = @"2019-01-01";
        NSDate *firstDate = [formatter dateFromString:dateStr];
        //        判断
        for(int i=0;i<yearCount;i++)
        {
            NSDate *newDate = [NSDate getDateFromDate:firstDate withDay:i];
            [formatter setDateFormat:@"MMM dd"];
            NSString *datastr = [formatter stringFromDate:newDate];
            [xtitles addObject:datastr];
        }
        
        //[array ]
        __block double arrayMinValue = [[array firstObject] doubleValue];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *value = obj;
            if(value.doubleValue < arrayMinValue)
            {
                arrayMinValue = value.doubleValue; //数组中的最小Y值
            }
        }];
        
        allPoints = [self addtionPointToChartViewData:array withTimeString:timeStrings];
        
        NSMutableArray *setsArray = [NSMutableArray array];
        for(int i=0;i<yearCount;i++)
        {
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:0.0];
            if(self.isStepLine) entry = [[ChartDataEntry alloc] initWithX:i y:1.0];
            [setsArray addObject:entry];
        }
        
        self.chartView.xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:xtitles];
        LineChartDataSet *dataset = [[LineChartDataSet alloc] initWithEntries:setsArray];
        [dataset setLabel:@""];
        dataset.drawCirclesEnabled= NO;
        dataset.drawValuesEnabled = NO;
        [dataset setColor:UIColor.lightGrayColor];
        dataset.lineWidth = 0.0;
        
        
        LineChartDataSet *actualityDataset = [[LineChartDataSet alloc] initWithEntries:allPoints label:self.typeName];
        actualityDataset.lineWidth = 1.0;
        actualityDataset.drawCirclesEnabled= NO;
        actualityDataset.drawVerticalHighlightIndicatorEnabled = YES;
        actualityDataset.drawHorizontalHighlightIndicatorEnabled = NO;
        actualityDataset.drawCirclesEnabled= YES;
        [actualityDataset setCircleColor:UIColor.yellowColor];
        actualityDataset.circleRadius = 1;
        [actualityDataset setColor:[UIColor greenColor]];
        if(self.isStepLine)actualityDataset.drawValuesEnabled = NO;
        // 加入两数据源 用于显示数据和填满X轴
        LineChartData *chartData = [[LineChartData alloc] initWithDataSets:@[dataset, actualityDataset]];
        ChartYAxis *leftAxis = self.chartView.leftAxis;
        leftAxis.axisMinimum = arrayMinValue-0.01;
        
        
        [self.chartView setData:chartData];
        [self.chartView.data notifyDataChanged];
        [self.chartView notifyDataSetChanged];
    }
    
    
}
- (void)viewDidLayoutSubviews
{
    //
    
}
// 画出一天的坐标
- (void)setupChatsLineViewForDay
{
    NSMutableArray *mArray = [NSMutableArray new];
    for (int i = 1; i < 1440; i ++)
    {
        NSString *date = [NSString stringWithFormat:@"数据%d",i];
        int y = 0;
        if(i%4)
        {
            y = 1;
        }
        else
        {
            y = 0;
        }
        NSDictionary *value = @{@"xLineValue":date,@"yValue1":@(y).stringValue};
        [mArray addObject:value];
    }
    self.valueArray = mArray.copy;
    self.chartView.doubleTapToZoomEnabled = NO;//禁止双击缩放 有需要可以设置为YES
    //self.chartView.gridBackgroundColor = [UIColor orangeColor];//表框以及表内线条的颜色以及隐藏设置 根据自己需要调整
    //self.chartView.borderColor = [UIColor redColor];
    self.chartView.delegate = self;
    self.chartView.legend.form = ChartLegendFormCircle;
}


- (void)setupChartAxisStyles:(LineChartView *)chartView
{
    chartView.drawMarkers = true;
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.axisLineColor = [UIColor whiteColor];
    xAxis.labelFont = [UIFont systemFontOfSize:11];
    xAxis.labelTextColor = [UIColor whiteColor];
    xAxis.drawGridLinesEnabled = false;
    //[xAxis setLabelCount:5 force:true];
    ChartYAxis *leftAxis = self.chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:11];
    leftAxis.labelTextColor = [UIColor whiteColor];
    leftAxis.axisLineColor = [UIColor whiteColor];
    leftAxis.enabled = true;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    
    self.chartView.rightAxis.enabled = NO;
    
    
    // 如果是阶梯 直方图才自定义Y的显示
    if(self.isStepLine)
    {
        self.chartView.leftAxis.valueFormatter = [[SymbolsValueFormatter alloc] init];
        leftAxis.granularity=1; // 设置y轴显示1个间隔
    }
}


#pragma mark - 表格的Delegate
- (void)showChartMarkViewWithYValue:(NSString *)value andX:(NSString *)xValue
{
    ChartMarkerView *marker = [[ChartMarkerView alloc] initWithFrame:CGRectMake(0,0, 80, 40)];;
    marker.chartView = self.chartView;
    marker.offset = CGPointMake(-20, -50);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Y: %@", value];
    label.textColor = UIColor.whiteColor;
    [label setFont:[UIFont systemFontOfSize:12]];
    label.backgroundColor = UIColor.lightGrayColor;
    [marker addSubview:label];
    self.chartView.marker = marker;
}
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight
{
    NSString *str = [NSString stringWithFormat:@"%.2f", entry.y];
    [self showChartMarkViewWithYValue:str andX:@""];
    
}


#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView
{
    return self.view;
}

- (void)listDidAppear {}

- (void)listDidDisappear {}


/** 网络请求的处理方法 拿到历史数据信息*/
- (void)getHistoryDataWithCalendarType:(CAL_MODE)type
{
    if(self.historyType == PowerUsed)
    {
        //发送其他的网络请求
        [self noDataSetupChatView];

        return;
    }
    
    
    switch (type)
    {
        case DAY:
        {
            [UpsNetworkingTools getUpsRangeDataWithStartDate:nil endDate:nil UUIDString:self.machineID  success:^(id  _Nonnull response) {
                // 获得当天的历史数据
                //NSLog(@"今天的历史数据--%@", response);
                self.modelArray = response;
                if(self.modelArray.count == 0) [MBProgressHUD showError:@"No Data" toView:self.view];
                if(self.mode || self.historyType)
                    [self setupAAChartWithCalendarMode:self.mode withHistoryType:self.historyType];
                // 显示表格数据
            } failure:^(NSError * _Nonnull error) {
                //错误的处理
            }];
        }
            break;
        case MONTH:
        {
            //月的数据
            NSString *str = [[NSDate date] convertToNumberStringYYYYmmDD];
            NSString * param = [str substringWithRange:NSMakeRange(0, str.length-2)]; //if
            if(str.length==6){}
            [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYMMstring:param success:^(NSArray * _Nonnull response) {
                //// 获得月的历史数据
                self.modelArray = response;
                if(self.modelArray.count == 0) [MBProgressHUD showError:@"No Data" toView:self.view];
                if(self.mode || self.historyType)
                    [self setupAAChartWithCalendarMode:MONTH withHistoryType:self.historyType];
            } failure:^(NSError * _Nonnull error) {
                // 错误处理
            }];
            //            [UpsNetworkingTools getUpsRangeDataWithStartDate:nil endDate:nil success:^(id  _Nonnull response) {
            //                // 获得当天的历史数据
            //                NSLog(@"今天的历史数据--%@", response);
            //                self.modelArray = response;
            //                // 显示表格数据
            //            } failure:^(NSError * _Nonnull error) {
            //                //错误的处理
            //            }];
        }
            break;
        case YEAR:
        {
            //请求年的的数据
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY"];
            NSString *str = [formatter stringFromDate:[NSDate date]];
            [UpsNetworkingTools getUpsDateWithUUIDString:self.machineID byYYYYstring:[formatter stringFromDate:[NSDate date]] success:^(NSArray * _Nonnull response) {
                // 2019年份
                self.modelArray = response;
                if(self.mode || self.historyType)
                    [self setupAAChartWithCalendarMode:YEAR withHistoryType:self.historyType];
            } failure:^(NSError * _Nonnull error) {
                //错误的处理方法
            }];
        }
        default:
            break;
    }
    
}

- (int)getThisDayOfThisYearInDate:(NSDate *)date
{
    NSCalendar *gregorian =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger dayOfYear =
    [gregorian ordinalityOfUnit:NSDayCalendarUnit
                         inUnit:NSYearCalendarUnit forDate:date];
    
    return dayOfYear;
}

- (void)noDataSetupChatView
{
    if(_historyType != PowerUsed)[MBProgressHUD showError:@"NO Data" toView:self.view];
    [self.chartView setData:nil];
    [self.chartView.data notifyDataChanged];
    [self.chartView notifyDataSetChanged];
}


- (void)getPowerUsedDataWithCalendarType:(CAL_MODE)type
{
    switch (type)
    {
        case DAY:
        {
            self.powerUsedLabel.text = [NSString stringWithFormat:@"Power Used: %.2f wh", 0];
        }
            break;
        case MONTH:
        {
            //网络请求的方式
        }
            break;
        case YEAR:
        {
            
        }
            break;
            default:
            self.powerUsedLabel.text = @"";
            break;
    }
            
}
@end


/**/
