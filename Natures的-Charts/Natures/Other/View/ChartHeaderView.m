//
//  ChartHeaderView.m
//  AirMachine
//
//  Created by sjty on 2019/2/23.
//  Copyright © 2019年 com.sjty. All rights reserved.
//

#import "ChartHeaderView.h"
#import "UIImage+Color.h"

@interface ChartHeaderView()


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property(strong,nonatomic)UIView *contentView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;

@property(nonatomic,strong)NSDate *currentDate;
@end

@implementation ChartHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
        // change mode
        [self initFormatWithDateValue];
    }
    return self;
}

- (void)initFormatWithDateValue
{
    if(self.currentDate == nil) self.currentDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    if(self.mode == DAY)
    {
        formatter.dateFormat=@"MMM-dd-YYYY";
        self.timeLabel.text= [formatter stringFromDate:self.currentDate];
#warning Delegates 通知类型 告诉外面的 具体时间数据
    }
    else if(self.mode == WEEK)
    {
        formatter.dateFormat=@"MMM-dd-YYYY";
        NSDate *next7D = [self getDateFromDate:[NSDate date] withDay:6];
        self.timeLabel.text= [NSString stringWithFormat:@"%@  %@",[formatter stringFromDate:_currentDate], [formatter stringFromDate:next7D]];
        [formatter stringFromDate:[NSDate date]];
        
#warning Delegates 通知类型 告诉外面的delegate
        if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)])
        {
            [self.delegate chartHeaderView:self StartTime:_startTime EndTime:_endTime];
        }
    }
    else if(self.mode == MONTH)
    {
        formatter.dateFormat=@"MMM-YYYY";
        self.timeLabel.text= [formatter stringFromDate:self.currentDate];
    }
    else if(self.mode == YEAR)
    {
        formatter.dateFormat = @"YYYY";
        self.timeLabel.text = [formatter stringFromDate:self.currentDate];
    }
}
#pragma mark - Setter
- (void)setMode:(CAL_MODE)mode
{
    _mode = mode;
    
    // 设置模式 在ViewDidLoad
    [self initFormatWithDateValue];
}


-(void)setTitle:(NSString *)title
{
    self.titleLabel.text=title;
}


-(void)lastAction
{
    if (self.mode==DAY)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        self.currentDate = [self getDateFromDate:self.currentDate withDay:-1];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        formatter.dateFormat=@"MMM-dd-YYYY";
        
        self.timeLabel.text=[formatter stringFromDate:self.currentDate];
#warning 通知第几天啊
        if([self.delegate respondsToSelector:@selector(chartHeaderView:didChangeDate:)])
        {
            [self.delegate chartHeaderView:self didChangeDate:self.currentDate];
        }
    }
    else if (self.mode==WEEK)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        
        self.currentDate=[self getDateFromDate:_currentDate withDay:-7];
        NSDate *endDate = [self getDateFromDate:_currentDate withDay:+6];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        
        formatter.dateFormat=@"MMM-dd-YYYY";
        NSString *str1 = [formatter stringFromDate:self.currentDate];
        NSString *str2 = [formatter stringFromDate:endDate];
        
        self.timeLabel.text= str1.add(@" ").add(str2);
        #warning 通知这个日期范围给我
        if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)]) {
            [self.delegate chartHeaderView:self StartTime:_startTime EndTime:_endTime];
        }
    }
    else if (self.mode==MONTH)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        
        self.currentDate=[self getDateFromDate:self.currentDate withMonth:-1];
        [self getBeginAndEndWith:self.currentDate DateType:MONTH];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        
        formatter.dateFormat=@"MMM-YYYY";
        //formatter.dateFormat=@"MMM-dd-YYYY";
        //formatter.dateFormat=@"YYYY";
        self.timeLabel.text=[formatter stringFromDate:self.currentDate];
        NSString *rangeWeekStr =[NSString stringWithFormat:@"%@-%@",[[self.startTime substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."],[[self.endTime substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
        NSLog(@"%@", rangeWeekStr);
        if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)])
        {
#warning 通知这个日期范围给我 几月到月底
            
        }
        
        if([self.delegate respondsToSelector:@selector(chartHeaderView:didChangeDate:)])
        {
            [self.delegate chartHeaderView:self didChangeDate:self.currentDate];
        }
    }
    else if(self.mode == YEAR)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        self.currentDate=[self getDateFromDate:_currentDate withYear:-1];

        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        formatter.dateFormat=@"YYYY";
        self.timeLabel.text = [formatter stringFromDate:self.currentDate];
        if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)])
        {
            #warning 通知这一年的1.1-12.31
        }
        
        if([self.delegate respondsToSelector:@selector(chartHeaderView:didChangeDate:)])
        {
            [self.delegate chartHeaderView:self didChangeDate:self.currentDate];
        }
    }
}



-(void)nextAction
{
    if (self.mode==DAY)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        self.currentDate = [self getDateFromDate:self.currentDate withDay:+1];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        formatter.dateFormat=@"MMM-dd-YYYY";
        
        self.timeLabel.text=[formatter stringFromDate:self.currentDate];
#warning 通知第几天啊
        
        if([self.delegate respondsToSelector:@selector(chartHeaderView:didChangeNextDate:)])
        {
            [self.delegate chartHeaderView:self didChangeNextDate:self.currentDate];
        }
    }
    else if (self.mode==WEEK)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        
        self.currentDate=[self getDateFromDate:_currentDate withDay:+7];
        NSDate *endDate = [self getDateFromDate:self.currentDate withDay:+6];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        
        formatter.dateFormat=@"MMM-dd-YYYY";
        NSString *str1 = [formatter stringFromDate:self.currentDate];
        NSString *str2 = [formatter stringFromDate:endDate];
        
        self.timeLabel.text= str1.add(@" ").add(str2);
#warning 通知这个日期范围给我
        if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)])
        {
            [self.delegate chartHeaderView:self StartTime:_startTime EndTime:_endTime];
        }
        if([self.delegate respondsToSelector:@selector(chartHeaderView:didChangeNextDate:)])
        {
            [self.delegate chartHeaderView:self didChangeNextDate:self.currentDate];
        }
    }
    else if (self.mode==MONTH)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        
        self.currentDate=[self getDateFromDate:self.currentDate withMonth:+1];
        [self getBeginAndEndWith:self.currentDate DateType:MONTH];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        
        formatter.dateFormat=@"MMM-YYYY";
        
        self.timeLabel.text=[formatter stringFromDate:self.currentDate];
        NSString *rangeWeekStr =[NSString stringWithFormat:@"%@-%@",[[self.startTime substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."],[[self.endTime substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
        NSLog(@"%@", rangeWeekStr);
        if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)])
        {
#warning 通知这个日期范围给我 几月到月底
            
        }
        if([self.delegate respondsToSelector:@selector(chartHeaderView:didChangeNextDate:)])
        {
            [self.delegate chartHeaderView:self didChangeNextDate:self.currentDate];
        }
    }else if(self.mode == YEAR)
    {
        if (self.currentDate==nil)
        {
            self.currentDate=[NSDate date];
        }
        self.currentDate=[self getDateFromDate:_currentDate withYear:+1];

        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        formatter.dateFormat=@"YYYY";
        self.timeLabel.text = [formatter stringFromDate:self.currentDate];
        if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)])
        {
#warning 通知这一年的1.1-12.31
        }
        if([self.delegate respondsToSelector:@selector(chartHeaderView:didChangeNextDate:)])
        {
            [self.delegate chartHeaderView:self didChangeNextDate:self.currentDate];
        }
    }
}

/**
 获取指定时间的几个月前日期或几个月后日期

 @param date 指定时间
 @param month 月的数量
 @return 返回日期
 */
-(NSDate *)getDateFromDate:(NSDate *)date withMonth:(NSInteger)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

/**
 获取指定时间的几天前日期或几个天后日期
 
 @param date 指定时间
 @param day 天的数量
 @return 返回日期
 */
-(NSDate *)getDateFromDate:(NSDate *)date withDay:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

-(NSDate *)getDateFromDate:(NSDate *)date withYear:(NSInteger)year
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}




/**
 获取指定日期的月份开始时间、结束时间
 获取指定日期的星期开始时间、结束时间

 @param newDate 指定日期
 @param dateType 类型
 */
-(void)getBeginAndEndWith:(NSDate *)newDate DateType:(NSInteger)dateType
{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    
    double interval = 0;
    
    NSDate *beginDate = nil;
    
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = false;
    if (dateType==WEEK) {
       ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:newDate];
        
#warning
    }else if (dateType==MONTH )
    {
        ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    }
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    
    if (ok)
    {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return;
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.startTime = [myDateFormatter stringFromDate:beginDate];
    
    self.endTime = [myDateFormatter stringFromDate:endDate];
    
}


-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"ChartHeaderView" owner:self options:nil].lastObject;
        //_contentView.frame = self.bounds;
    }
    return _contentView;
}


-(void)setupUI{
    [self addSubview:self.contentView];
    [self.segmentControl setTitle:@"Month" forSegmentAtIndex:1];
    [self.segmentControl setTitle:@"Week" forSegmentAtIndex:0];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:8.0f],NSFontAttributeName,nil];
    [self.segmentControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    [self.segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];

    
    [self.segmentControl setBackgroundImage: [UIImage imageWithColor:[UIColor colorWithRed:0/255.0 green:115/255.0 blue:255/255.0 alpha:1]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentControl setBackgroundImage: [UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.lastButton addTarget:self action:@selector(lastAction) forControlEvents:UIControlEventTouchDown];
    
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchDown];

    self.backgroundColor=[UIColor clearColor];
    [self.segmentControl addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    
    self.currentDate=[NSDate date];
    [self getBeginAndEndWith:[NSDate date] DateType:DateWeek];
    
    self.timeLabel.text=[NSString stringWithFormat:@"%@-%@",[[self.startTime substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."],[[self.endTime substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    if ([self.delegate respondsToSelector:@selector(chartHeaderView:StartTime:EndTime:)]) {
        [self.delegate chartHeaderView:self StartTime:_startTime EndTime:_endTime];
    }
}



@end
