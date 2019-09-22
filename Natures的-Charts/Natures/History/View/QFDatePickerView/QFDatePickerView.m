//
//  QFDatePickerView.m
//  dateDemo
//
//  Created by 情风 on 2017/1/12.
//  Copyright © 2017年 情风. All rights reserved.
//

#import "QFDatePickerView.h"
#import "AppDelegate.h"
@interface QFDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    void(^backBlock)(NSString *);
    
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSString *restr;
    
    NSString *selectedYear;
    NSString *selectecMonth;
    
    BOOL onlySelectYear;
    
    UIView *superView;
}

@property (nonatomic, strong) UILabel *currentYearLabel;
@end

@implementation QFDatePickerView

#pragma mark - initDatePickerView
/**
 初始化方法，只带年月的日期选择
 
 @param block 返回选中的日期
 @return QFDatePickerView对象
 */
- (instancetype)initDatePackerWithResponse:(void (^)(NSString *))block{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    [self setViewInterface];
    if (block) {
        backBlock = block;
    }
    onlySelectYear = NO;
    return self;
}

/**
 初始化方法，只带年月的日期选择
 
 @param superView picker的载体View
 @param block 返回选中的日期
 @return QFDatePickerView对象
 */
- (instancetype)initDatePackerWithSUperView:(UIView *)superView response:(void(^)(NSString*))block {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    [self setViewInterface];
    if (block) {
        backBlock = block;
    }
    superView = superView;
    onlySelectYear = NO;
    return self;
}

/**
 初始化方法，只带年份的日期选择
 
 @param block 返回选中的年份
 @return QFDatePickerView对象
 */
- (instancetype)initYearPickerViewWithResponse:(void(^)(NSString*))block {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    [self setViewInterface];
    if (block) {
        backBlock = block;
    }
    onlySelectYear = YES;
    return self;
}

/**
 初始化方法，只带年份的日期选择
 
 @param block 返回选中的年份
 @return QFDatePickerView对象
 */
- (instancetype)initYearPickerWithView:(UIView *)superView response:(void(^)(NSString*))block {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    [self setViewInterface];
    if (block) {
        backBlock = block;
    }
    superView = superView;
    onlySelectYear = YES;
    return self;
}
/**

    107,0,2019-09-22 14:51:34,12.9,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,2,F6:D3:01:0E:45:B1,0000000001";
    107,0,2019-09-22 15:01:38,12.9,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,2,F6:D3:01:0E:45:B1,0000000001;
    107,0,2019-09-22 15:11:36,13.0,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,0,2,F6:D3:01:0E:45:B1,0000000001",
111,65535,2019-09-22 15:31:33,11.7,0,0,1,0,1,0,0,0,1,1,1,0,0,0,0,1,0,5,,0000000001",
    107,0,2019-09-22 15:41:34,13.0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,5,,0000000001",
107,0,2019-09-22 15:51:35,13.1,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,5,,0000000001",
ß
*/
#pragma mark - Configuration
- (void)setViewInterface {
    
    [self getCurrentDate];
    
    [self setYearArray];
    
    [self setMonthArray];
    
    contentView = [[UIToolBar alloc] initWithFrame:CGRectMake(0, -300, self.frame.size.width, 300)];
    [self addSubview:contentView];
    contentview.layer.cornerRadius = 3.0;
    //设置背景颜色为黑色，并有0.4的透明度
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, self.frame.size.width, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [contentView addSubview:whiteView];
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 10, 60, 40)];
        [button setTitle:i == 0 ? @"Cancel" : @"YES" forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
//            button.x+=100;
        } else {
            [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            //[button setBackgroundColor:UIColor.whiteColor];
//            button.x-=100;
        }
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 260)];
    //[contentView addSubview:pickerView];

    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 15, 60, 40)];
        [button setTitle:i == 0 ? @"" : @"" forState:UIControlStateNormal];
        [button setImage:i == 0 ? [UIImage imageNamed:@"back_white"] : [UIImage imageNamed:@"back_white2"] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(changeYearValueWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    
    NSDate *now = [NSDate date];
    NSString *currentYYYY = [now convertToNumberStringYYYY];
    UILabel * yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.bounds), 30)];
    [yearLabel setFont:[UIFont systemFontOfSize:30]];
    [yearLabel setTextColor:[UIColor blackColor]];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.text = currentYYYY;
    self.currentYearLabel = yearLabel;
    [contentView addSubview:yearLabel];
    
//    UIScrollView *titleView = [[UIScrollView alloc] initWithFrame:contentView.bounds];
//    //[[NSDate date] convertToNumberStringYYYYmm];
//    titleView.pagingEnabled = YES;
//    titleView.showsHorizontalScrollIndicator = NO;
//    titleView.showsVerticalScrollIndicator = NO;
//    titleView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*10,  0);
//    [titleView setContentOffset:CGPointMake(9*CGRectGetWidth(self.bounds), 0)];
//    [contentView addSubview:titleView];
//    //label
    
    
    for(int i=2010;i<2020;i++)
    {
        CGFloat x = CGRectGetWidth(self.bounds)*(i-2010);
        UILabel * yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 10, CGRectGetWidth(self.bounds), 30)];
        [yearLabel setFont:[UIFont systemFontOfSize:30]];
        [yearLabel setTextColor:[UIColor blackColor]];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.text = [NSString stringWithFormat:@"%d", i];
    }
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 220)];
    dateView.backgroundColor = UIColor.clearColor;
    //添加滑动
    
    
    //一行4个
    int colum = 4;
    int margin = (CGRectGetWidth(self.bounds)/9);
    for (int i=0; i<12; i++)
    {
        CGFloat x = margin + 2*(i%colum)*margin;
        CGFloat y = i/4*margin*2;
        UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, CGRectGetWidth(self.bounds)/9, CGRectGetWidth(self.bounds)/9)];
        dateButton.tag = i+1;
        dateButton.layer.cornerRadius = dateButton.height/2;
        //dateButton.backgroundColor = UIColor.blackColor;
        [dateButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [dateButton setTitle:@"".addInt(i+1) forState:UIControlStateNormal];
        [dateView addSubview:dateButton];
        [dateButton addTarget:self action:@selector(selectMonhth:) forControlEvents:UIControlEventTouchDown];
        
    }
    contentView.backgroundColor = UIColor.whiteColor;
    contentView.alpha = 0.75;
    [contentView addSubview:dateView];
    
    
    
}

- (void)selectMonhth:(UIButton *)sender
{
    //拿到当前的第几个月通知代理方法
    sender.backgroundColor = UIColor.blackColor;
    [sender setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    NSString *year = self.currentYearLabel.text;
    NSString *yyyymm = [NSString stringWithFormat:@"%@-%02d", year, (int)sender.tag];
    if(backBlock) backBlock(yyyymm);
    contentview.userInteractionEnabled = NO;
    [self dismiss];
}
- (void)getCurrentDate {
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    if (dateArray.count == 2) {//年 月
        currentYear = [[dateArray firstObject]integerValue];
        currentMonth =  [dateArray[1] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
}

- (void)setYearArray {
    //初始化年数据源数组
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = currentYear; i >= 2010; i--)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)i];
        [yearArray addObject:yearStr];
    }
    //[yearArray addObject:@"Now"];
}

- (void)setMonthArray {
    //初始化月数据源数组
    monthArray = [[NSMutableArray alloc]init];
    
    if ([[selectedYear substringWithRange:NSMakeRange(0, 4)] isEqualToString:[NSString stringWithFormat:@"%ld",(long)currentYear]]) {
        for (NSInteger i = 1 ; i <= currentMonth; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)i];
            [monthArray addObject:monthStr];
        }
    } else {
        for (NSInteger i = 1 ; i <= 12; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)i];
            [monthArray addObject:monthStr];
        }
    }
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if (onlySelectYear) {
            restr = [selectedYear stringByReplacingOccurrencesOfString:@"年" withString:@""];
        } else {
            if ([selectecMonth isEqualToString:@""]) {//至今的情况下 不需要中间-
                restr = [NSString stringWithFormat:@"%@%@",selectedYear,selectecMonth];
            } else {
                restr = [NSString stringWithFormat:@"%@-%@",selectedYear,selectecMonth];
            }
            
            restr = [restr stringByReplacingOccurrencesOfString:@"年" withString:@""];
            restr = [restr stringByReplacingOccurrencesOfString:@"月" withString:@""];
        }
        //backBlock(restr);
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    if (superView) {
        [superView addSubview:self];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height+appDelegate.navAndStatusBarH);

}
#pragma mark - pickerView消失
- (void)dismiss{
        //contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (onlySelectYear) {//只选择年
        return 1;
    } else {
        return 2;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        return yearArray.count;
    } else {
        if (component == 0) {
            return yearArray.count;
        } else {
            return monthArray.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        return yearArray[row];
    } else {
        if (component == 0) {
            return yearArray[row];
        } else {
            return monthArray[row];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        selectedYear = yearArray[row];
    } else {
        if (component == 0) {
            selectedYear = yearArray[row];
            if ([selectedYear isEqualToString:@"至今"]) {//至今的情况下,月份清空
                [monthArray removeAllObjects];
                selectecMonth = @"";
            } else {//非至今的情况下,显示月份
                [self setMonthArray];
                selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
            }
            [pickerView reloadComponent:1];
            
        } else {
            selectecMonth = monthArray[row];
        }
    }
}

- (void)changeYearValueWithSender:(UIButton *)sender
{
    int num = self.currentYearLabel.text.intValue;
    if(sender.tag == 0)
    {
        //
        num--;
    }
    else if(sender.tag ==1)
    {
        NSDate *now = [NSDate date];
        NSString *currentYYYY = [now convertToNumberStringYYYY];
        if([self.currentYearLabel.text isEqualToString:currentYYYY]) return;
        num++;
    }
    
    self.currentYearLabel.text = [NSString stringWithFormat:@"%d", num];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *tt = [touches anyObject];
    CGPoint point = [tt locationInView:self];
    if(!CGRectContainsPoint(contentView.frame, point))
    {
        //
        [self dismiss];
    }
}
@end
