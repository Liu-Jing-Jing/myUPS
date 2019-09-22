//
//  OWMConstants.h
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    TemperatureUnitCelsius,
    TemperatureUnitFahrenheit
} TemperatureUnit;

@interface OWMConstants : NSObject
+(NSString *)kelvinToDefaultTemprature:(NSNumber *)kelvin;
+(void)setTemperatureUnit:(TemperatureUnit)unit;
+(TemperatureUnit)currentUnit;
@end
