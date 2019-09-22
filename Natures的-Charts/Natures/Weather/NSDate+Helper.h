//
//  NSDate+Helper.h
//  openweather-ios
//
//  Created by Harry Singh on 22/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
//当前日期的某一天
+ (NSDate *)getDateFromDate:(NSDate *)date withDay:(NSInteger)day;
+ (NSDate *)getDateFromDate:(NSDate *)date withMonth:(NSInteger)month;
- (NSString *)convertToMessageFormat;
+ (NSDate *)convertSJTYServerFormatToNSDateWithStr:(NSString *)str;
- (NSString *)convertToSJTYServerFormat;
+ (NSString *)ConverthhmmNumberWithDataFormat:(NSString*)yyyymmDDstring;
- (NSString *)convertToNumberStringYYYYmmDD;
-(NSString *)HH12Hour;
-(NSString *)dayName;
- (NSString *)convertToNumberStringYYYYmm;
/**
 得到当前月第一天和最后一天
 */
- (NSString *)convertToNumberStringYYYY;
+ (NSArray *)getMonthFirstAndLastDayWith:(NSDate *)currentDate;
+ (int)getNumberOfDaysOneYear:(NSDate *)date;
@end
