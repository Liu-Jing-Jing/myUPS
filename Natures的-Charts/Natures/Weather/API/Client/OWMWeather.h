//
//  OWMWeather.h
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OWMWeather;
@class CLPlacemark;
@class OWMWeatherData;
@class OWMToday;
@class OWMDayForecast;
@class OWMLocation;

typedef enum : NSUInteger {
    WeatherTypeCustom,
    WeatherTypeLocation
} WeatherType;

@protocol OWMWeatherProtocol

@optional
-(void)didUpdateForecaset:(OWMWeather * _Nonnull)weather;
-(void)didUpdateTodaysWeather:(OWMToday * _Nonnull)today;
-(void)failedToUpdateForecast:(NSError * _Nonnull)error;
@end

@interface OWMWeather : NSObject
@property (readonly, nonatomic, nullable) OWMWeatherData *weather;
@property (readonly, nonatomic, nullable) OWMToday *today;

@property (weak, nonatomic, nullable) id<OWMWeatherProtocol> delegate;
@property (readonly, nonatomic, nonnull) CLPlacemark * placemark;
@property (readonly, nonatomic) WeatherType type;

-(instancetype _Nullable)initWithPlacemark:(CLPlacemark * _Nonnull)placemark;
-(instancetype _Nullable)initWithLocationManager:(OWMLocation * _Nonnull)location;

-(NSArray<OWMDayForecast *> * _Nullable)forcastForRange:(NSRange)range;
-(NSArray<OWMDayForecast *> * _Nullable)fiveDayForecast;
-(NSArray * _Nullable)forecastForDate:(NSDate * _Nonnull)date;
-(NSString * _Nonnull)summary;
-(NSString * _Nonnull)city;
-(NSString * _Nonnull)currentTemp;
-(NSString * _Nonnull)todayMinTemp;
-(NSString * _Nonnull)todayMaxTemp;
-(NSString * _Nonnull)day;
@end
