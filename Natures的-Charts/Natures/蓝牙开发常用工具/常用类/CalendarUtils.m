//
//  CalendarUtils.m
//  KangNengWear
//
//  Created by liangss on 2017/10/17.
//  Copyright © 2017年 sjty. All rights reserved.
//

#import "CalendarUtils.h"
#import "BaseUtils.h"
static NSDateFormatter *sdf;

@implementation CalendarUtils

+(int) getWeekOfDayByDate:(NSDate*) date{
    
    int weekArr[] = {0,7,1,2,3,4,5,6};

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|
    NSCalendarUnitDay|
    NSCalendarUnitWeekday |
    NSCalendarUnitHour|
    NSCalendarUnitMinute|
    NSCalendarUnitSecond;
    //int week=1是星期一,week=7是星期天;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    return weekArr[week];
}

+ (NSMutableString*) getWeekStr:(NSString*)weekStr {
    NSMutableString* string = [NSMutableString string];
    Byte b = [BaseUtils byteConvertForHexString:weekStr];
    
    if ((b & WeekdayOfMon) == WeekdayOfMon ) {
        [string appendString:@"Mon"];
        [string appendString:@","];
    }
    if ((b & WeekdayOfTue) == WeekdayOfTue) {
        [string appendString:@"Tue"];
        [string appendString:@","];
    }
    if ((b & WeekdayOfWed) == WeekdayOfWed) {
        [string appendString:@"Wed"];
        [string appendString:@","];
    }
    if ((b & WeekdayOfThu) == WeekdayOfThu) {
        [string appendString:@"Thu"];
        [string appendString:@","];
    }
    if ((b & WeekdayOfFri) == WeekdayOfFri) {
        [string appendString:@"Fri"];
        [string appendString:@","];
    }
    if ((b & WeekdayOfSat) == WeekdayOfSat) {
        [string appendString:@"Sat"];
        [string appendString:@","];
    }
    if ((b & WeekdayOfSun) == WeekdayOfSun) {
        [string appendString:@"Sun"];
    }
    return string;
}

+ (NSMutableString*) getWeekStrOfCN:(NSInteger)b {
    NSMutableString* string = [NSMutableString string];
//    Byte b = [BaseUtils byteConvertForHexString:weekStr];
    
    if ((b & WeekdayOfMon) == WeekdayOfMon ) {
        [string appendString:NSLocalizedString(@"周一", @"周一")];
        [string appendString:@","];
    }
    if ((b & WeekdayOfTue) == WeekdayOfTue) {
        [string appendString:NSLocalizedString(@"周二", @"周二")];
        [string appendString:@","];
    }
    if ((b & WeekdayOfWed) == WeekdayOfWed) {
        [string appendString:NSLocalizedString(@"周三", @"周三")];
        [string appendString:@","];
    }
    if ((b & WeekdayOfThu) == WeekdayOfThu) {
        [string appendString:NSLocalizedString(@"周四", @"周四")];
        [string appendString:@","];
    }
    if ((b & WeekdayOfFri) == WeekdayOfFri) {
        [string appendString:NSLocalizedString(@"周五", @"周五")];
        [string appendString:@","];
    }
    if ((b & WeekdayOfSat) == WeekdayOfSat) {
        [string appendString:NSLocalizedString(@"周六", @"周六")];
        [string appendString:@","];
    }
    if ((b & WeekdayOfSun) == WeekdayOfSun) {
        [string appendString:NSLocalizedString(@"周日", @"周日")];
    }
    return string;
}

+(NSString *) getWeekOfDayName:(int) weekOfDay{
    switch (weekOfDay) {
        case SUNDAY:
            return @"星期日";
        case MONDAY:
            return @"星期一";
        case TUESDAY:
            return @"星期二";
        case WEDNESDAY:
            return @"星期三";
        case THURSDAY:
            return @"星期四";
        case FRIDAY:
            return @"星期五";
        case SATURDAY:
            return @"星期六";
    }
    return @"";
}

+(NSDate*)getDateCurrentWithHour:(NSInteger)hour andMinute:(NSInteger)minute{
    NSDate * date = [NSDate date];
    
//    NSDateComponents * compnents = [self getDateComponentsByDate:date];
//    compnents.hour = hour;
//    compnents.minute = minute;
    NSString * currentDay = [self stringFromDate:date formartStr:@"yyyy-MM-dd"];
    NSString * newDay = [NSString stringWithFormat:@"%@ %ld:%ld",currentDay,hour,minute];
    NSDate * newDate = [self dateFromString:newDay formartStr:@"yyyy-MM-dd HH:mm"];
    
    return newDate;
}

//通过日期获取NSDateComponents，方便取年月日周等信息
+(NSDateComponents *) getDateComponentsByDate:(NSDate *) date{
    if (date == nil) {
        date = [[NSDate alloc] init];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    NSInteger calendarUnitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    dateComps = [calendar components:calendarUnitFlags fromDate:date];
    return dateComps;
}

//显示消息 消息内容，显示时间，在哪个View中显示


//日期按指定格式转换成字符串
+(NSString *) stringFromDate:(NSDate *) date formartType:(int) formartType{
    NSString *formartStr = @"";
    switch (formartType) {
        case DEFUALT_DATE_FORMART_YMD:
            formartStr = @"yyyy-MM-dd";
            break;
        case DEFAULT_DATE_FORMART_YMDHM:
            formartStr = @"yyyy-MM-dd HH:mm";
            break;
        case DEFAULT_DATE_FORMART_YMDHMS:
            formartStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        default:
            formartStr = @"yyyy-MM-dd";
            break;
    }
    return [self stringFromDate:date formartStr:formartStr];
}

//日期按指定格式转换成字符串
+(NSString *) stringFromDate:(NSDate *) date formartStr:(NSString *) formartStr{
    if (sdf == nil) {
        sdf = [[NSDateFormatter alloc] init];
    }
    [sdf setDateFormat:formartStr];
    return [sdf stringFromDate:date];
}
//字符串按指定格式转换成日期
+(NSDate *) dateFromString:(NSString *) strDate formartType:(int) formartType{
    NSString *formartStr = @"";
    switch (formartType) {
        case DEFUALT_DATE_FORMART_YMD:
            formartStr = @"yyyy-MM-dd";
            break;
        case DEFAULT_DATE_FORMART_YMDHM:
            formartStr = @"yyyy-MM-dd HH:mm";
            break;
        case DEFAULT_DATE_FORMART_YMDHMS:
            formartStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        case DEFAULT_DATE_FORMART_MMDD:
            formartStr = @"MM-dd";
            break;
        default:
            formartStr = @"yyyy-MM-dd";
            break;
    }
    return [self dateFromString:strDate formartStr:formartStr];
}
//字符串按指定格式转换成日期
+(NSDate *) dateFromString:(NSString *) strDate formartStr:(NSString *) formartStr{
    if (sdf == nil) {
        sdf = [[NSDateFormatter alloc] init];
    }
    [sdf setDateFormat:formartStr];
    return [sdf dateFromString:strDate];
}


//根据日期获取这一周的第一天
+(NSDate *) getThisWeekFirstDay:(NSDate *) date{
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    //    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //  [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekday startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        return beginDate;
        //      endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    
    return date;
    
}

//根据日期获取这一周的最后一天
+(NSDate *) getThisWeekEndDay:(NSDate *) date{
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekday startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval - 24 * 3600];
        return endDate;
    }
    return date;
}

//根据日期获取这一月的第一天
+(NSDate *) getThisMonthFirstDay:(NSDate *) date{
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    //    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //  [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        return beginDate;
    }
    return date;
}
//根据日期获取这一月的最后一天
+(NSDate *) getThisMonthEndDay:(NSDate *) date{
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //[calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval - 1];
        return endDate;
    }
    return date;
}

//根据日期获取这一年的第一天
+(NSDate *) getThisYearFirstDay:(NSDate *) date{
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    //    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //  [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitYear startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        return beginDate;
    }
    return date;
}
//根据日期获取这一年的最后一天
+(NSDate *) getThisYearEndDay:(NSDate *) date{
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //[calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitYear startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval - 1];
        return endDate;
    }
    return date;
}
+(NSDate *)getCurrentDate {

    return [NSDate date];
}

/**
 获取给定日前的前一天
 
 @param date 给定日期
 @return <#return value description#>
 */
+(NSDate*)getBeforeDayWithDate:(NSDate*)date{
    return [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
}

/**
 获取给定日前的后一天
 @param date 给定日期
 @return <#return value description#>
 */
+(NSDate*)getAfterDayWithDate:(NSDate*)date{
    
    return [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
}

/**
 获取给定日期年
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getYearWithDate:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
 
    return [d year] ;
}

/**
 获取给定日期月
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getMonthWithDate:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return [d month] ;
}

/**
 获取给定日期周
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getWeekWithDate:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return [d weekOfYear] ;
}

/**
 获取给定日期日
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getDayWithDate:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return [d day] ;
}

/**
 获取给定日期时
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getHourWithDate:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return [d hour] ;
}

/**
 获取给定日期分
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getMinuteWithDate:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return [d minute] ;
}

/**
 获取给定日期秒
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getSecondWithDate:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return [d second] ;
}

/**
 获取给定日期秒
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getWeekOfDayWithDate:(NSDate*)date{
    
    int weekArr[] = {0,7,1,2,3,4,5,6};

    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|
    NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    return weekArr[[d weekday]];;
}

@end
