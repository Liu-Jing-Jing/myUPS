//
//  NSDate+Helper.m
//  openweather-ios
//
//  Created by Harry Singh on 22/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "NSDate+Helper.h"
#import "ChartHeaderView.h"
@implementation NSDate (Helper)
-  (NSString *)convertToMessageFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm dd/MM/yyyy"];
    return [formatter stringFromDate:self];
}
+ (NSDate *)convertToSJTYServerFormatWithString:(NSString *)sjtyFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:sjtyFormat];
}
+ (int)getNumberOfDaysOneYear:(NSDate *)date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange range = [calender rangeOfUnit:NSDayCalendarUnit
                                   inUnit: NSYearCalendarUnit
                                  forDate: date];
    return range.length;
}


+ (NSDate *)convertSJTYServerFormatToNSDateWithStr:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //NSString *sss = [formatter dateFromString:str];
    return [formatter dateFromString:str];
}

+ (NSString *)ConverthhmmNumberWithDataFormat:(NSString*)yyyymmDDstring
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *temp = [formatter dateFromString:yyyymmDDstring];
    
    [formatter setDateFormat:@"HH/mm/ss"];
    //NSString *sss = [formatter dateFromString:str];
    //
    NSString *dataStr = [formatter stringFromDate:temp];
    NSString *hh = [dataStr componentsSeparatedByString:@"/"][0];
    NSString *mm = [dataStr componentsSeparatedByString:@"/"][1];
    
    NSLog(@"%d时间转%d : %d", hh.intValue*24+mm.intValue, hh.intValue, mm.intValue);
    return [NSString stringWithFormat:@"%d", hh.intValue*60+mm.intValue];
}

- (NSString *)convertToNumberStringYYYY
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSArray *unit = [[formatter stringFromDate:self] componentsSeparatedByString:@"/"];
    
    return [unit firstObject];
}

- (NSString *)convertToNumberStringYYYYmmDD
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSArray *unit = [[formatter stringFromDate:self] componentsSeparatedByString:@"/"];
    
    return [unit componentsJoinedByString:@""];
}

- (NSString *)convertToNumberStringYYYYmm
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSArray *unit = [[formatter stringFromDate:self] componentsSeparatedByString:@"/"];
    
    if(unit.count >1)return [NSString stringWithFormat:@"%@%@", unit[0], unit[1]];
    else return @"";
}
-(NSString *)HH12Hour{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    [dateFormat setDateFormat:@"ha"];
    return [dateFormat stringFromDate:self];
}

-(NSString *)dayName{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:self];
}

//得到最后一天和第一天
+ (NSArray *)getMonthFirstAndLastDayWith:(NSDate *)currentDate
{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=currentDate;
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSString *firstString = [myDateFormatter stringFromDate: firstDate];
    //NSString *lastString = [myDateFormatter stringFromDate: lastDate];
    return @[firstDate, firstDate];
}


/**
 获取指定时间的几个月前日期或几个月后日期
 
 @param date 指定时间
 @param month 月的数量
 @return 返回日期
 */
+ (NSDate *)getDateFromDate:(NSDate *)date withMonth:(NSInteger)month
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
+ (NSDate *)getDateFromDate:(NSDate *)date withDay:(NSInteger)day
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
    BOOL ok = NO;
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
    
}
@end
