//
//  OWMConstants.m
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWMConstants.h"

//FOUNDATION_EXPORT
NSLocaleKey const NSLocaleTemperatureUnit;
NSString * const kDefaultTempLocation = @"com.owm.constants.tempunit";

@implementation OWMConstants

+(NSString *)kelvinToDefaultTemprature:(NSNumber *)kelvin{
//    if (self.currentUnit == TemperatureUnitCelsius) {
//        return [NSString stringWithFormat:@"%0.0f°", roundf(kKelvinToCelcius(kelvin.floatValue))];
//    }
    
    return [NSString stringWithFormat:@"%0.0f°", roundf(kKelvinToFahrenheit(kelvin.floatValue))];
}

+(void)setTemperatureUnit:(TemperatureUnit)unit{
    NSNumber *newVal = @(unit);
    [[NSUserDefaults standardUserDefaults] setObject:newVal forKey:kDefaultTempLocation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(TemperatureUnit)currentUnit{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTempLocation]) {
        return ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTempLocation]).integerValue;
    }
    
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleTemperatureUnit] isEqualToString:@"Fahrenheit"]) {
        [self setTemperatureUnit:TemperatureUnitFahrenheit];
    } else {
        [self setTemperatureUnit:TemperatureUnitCelsius];
    }
    return TemperatureUnitCelsius;
}

+(NSString *)dayNameFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}

@end
