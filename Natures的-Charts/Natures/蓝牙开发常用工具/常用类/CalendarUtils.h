//
//  CalendarUtils.h
//  KangNengWear
//
//  Created by liangss on 2017/10/17.
//  Copyright © 2017年 sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SUNDAY 1
#define MONDAY 2
#define TUESDAY 3
#define WEDNESDAY 4
#define THURSDAY 5
#define FRIDAY 6
#define SATURDAY 7

#define DEFUALT_DATE_FORMART_YMD 1
#define DEFAULT_DATE_FORMART_YMDHM 2
#define DEFAULT_DATE_FORMART_YMDHMS 3
#define DEFAULT_DATE_FORMART_MMDD 4



typedef NS_ENUM(NSUInteger, Weekday) {
    WeekdayOfMon = 1<< 1,
    WeekdayOfTue = 1<< 2,
    WeekdayOfWed = 1<< 3,
    WeekdayOfThu = 1<< 4,
    WeekdayOfFri = 1<< 5,
    WeekdayOfSat = 1<< 6,
    WeekdayOfSun = 1<< 7,
};

@interface CalendarUtils : NSObject

+(int) getWeekOfDayByDate:(NSDate*) date;


/**
 sun,sta,

 @param weekStr <#weekStr description#>
 @return <#return value description#>
 */
+(NSMutableString*) getWeekStr:(NSString*)weekStr;

+ (NSMutableString*) getWeekStrOfCN:(NSInteger)weekStr;

+(NSString *) getWeekOfDayName:(int) weekOfDay;

//显示消息 消息内容，显示时间，在哪个View中显示
//+(void) showMessage:(NSString *) msg times:(float)time view:(id) view;
//通过日期获取NSDateComponents，方便取年月日周等信息
+(NSDateComponents *) getDateComponentsByDate:(NSDate *) date;

//日期按指定格式转换成字符串
+(NSString *) stringFromDate:(NSDate *) date formartType:(int) formartType;
//日期按指定格式转换成字符串
+(NSString *) stringFromDate:(NSDate *) date formartStr:(NSString *) formartStr;
//字符串按指定格式转换成日期
+(NSDate *) dateFromString:(NSString *) strDate formartType:(int) formartType;
//字符串按指定格式转换成日期
+(NSDate *) dateFromString:(NSString *) strDate formartStr:(NSString *) formartStr;


//根据日期获取这一周的第一天
+(NSDate *) getThisWeekFirstDay:(NSDate *) date;
//根据日期获取这一周的最后一天
+(NSDate *) getThisWeekEndDay:(NSDate *) date;
//根据日期获取这一月的第一天
+(NSDate *) getThisMonthFirstDay:(NSDate *) date;
//根据日期获取这一月的最后一天
+(NSDate *) getThisMonthEndDay:(NSDate *) date;
//根据日期获取这一年的第一天
+(NSDate *) getThisYearFirstDay:(NSDate *) date;
//根据日期获取这一年的最后一天
+(NSDate *) getThisYearEndDay:(NSDate *) date;


/**
 获取当前日期指定 小时 分钟
 @param hour 小时
 @param minute 分钟
 @return <#return value description#>
 */
+(NSDate*)getDateCurrentWithHour:(NSInteger)hour andMinute:(NSInteger)minute;
/**
 获取当前天
 @return
 */
+(NSDate *)getCurrentDate;

/**
 获取给定日前的前一天

 @param date 给定日期
 @return <#return value description#>
 */
+(NSDate*)getBeforeDayWithDate:(NSDate*)date;

/**
 获取给定日前的后一天
 @param date 给定日期
 @return <#return value description#>
 */
+(NSDate*)getAfterDayWithDate:(NSDate*)date;

/**
 获取给定日期年
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getYearWithDate:(NSDate*)date;

/**
 获取给定日期月
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getMonthWithDate:(NSDate*)date;

/**
 获取给定日期周
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getWeekWithDate:(NSDate*)date;

/**
 获取给定日期日
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getDayWithDate:(NSDate*)date;

/**
 获取给定日期时
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getHourWithDate:(NSDate*)date;

/**
 获取给定日期分
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getMinuteWithDate:(NSDate*)date;

/**
 获取给定日期秒
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getSecondWithDate:(NSDate*)date;

/**
 获取给定日期秒
 @param date 给定日期
 @return <#return value description#>
 */
+(NSInteger)getWeekOfDayWithDate:(NSDate*)date;
@end
