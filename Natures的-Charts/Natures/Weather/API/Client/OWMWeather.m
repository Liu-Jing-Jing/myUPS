//
//  OWMWeather.m
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMWeather.h"
#import "OWMAPIClient.h"
#import "OWMConstants.h"
#import "OWMWeatherData.h"
#import "OWMForecast.h"
#import "OWMMain.h"
#import "OWMConstants.h"
#import "OWMToday.h"
#import "OWMCity.h"
#import "OWMDayForecast.h"
#import "OWMWeatherForecast.h"
#import "OWMLocation.h"

NSString * const kOWMWeatherEncodeDecodePlacemark = @"com.owm.placemark.encode.decode";
NSString * const kOWMWeatherEncodeDecodeLocation = @"com.owm.location.encode.decode";
NSString * const kOWMWeatherEncodeDecodeWeather = @"com.owm.weather.encode.decode";
NSString * const kOWMWeatherEncodeDecodeToday = @"com.owm.today.encode.decode";
NSString * const kOWMWeatherEncodeDecodeType = @"com.owm.type.encode.decode";

@import CoreLocation;

@interface OWMWeather() <OWMLocationProtocol>
@property (strong, nonatomic) OWMAPIClient *client;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) CLLocation *currLocation;
@property (strong, nonatomic) OWMWeatherData *weather;
@property (strong, nonatomic) OWMToday *today;
@property (strong, nonatomic) OWMDayForecast *todayForecast;
@property (strong, nonatomic) OWMLocation *location;
@property (assign, nonatomic) WeatherType type;
@end

@implementation OWMWeather

-(instancetype)initWithPlacemark:(CLPlacemark *)placemark{
    NSAssert(placemark != nil, @"Cannot initilize a weather object without a placemark.");
    
    if (self = [super init]) {
        self.client = [[OWMAPIClient alloc] initWithBaseURL:kWeatherAPIBaseURL];
        self.placemark = placemark;
        self.currLocation = placemark.location;

        self.type = WeatherTypeCustom;
        
        if (self.client.networkStatus == NetworkStatusRechable) {
            [self updateTodaysWeather];
            [self updateFiveDayWeather];
        }
        
        __weak typeof(self) wself = self;
        self.client.networkStatusBlock = ^(NetworkStatus status) {
            if (status == NetworkStatusRechable) {
                [wself updateTodaysWeather];
                [wself updateFiveDayWeather];
            }
        };
    }
    
    return self;
}

-(instancetype)initWithLocationManager:(OWMLocation *)location{
    if (self = [super init]) {
        self.client = [[OWMAPIClient alloc] initWithBaseURL:kWeatherAPIBaseURL];
        
        self.location = location;
        self.currLocation = location.lastLocation;
        self.location.delegate = self;
        
        self.type = WeatherTypeLocation;
        
        if (self.currLocation && self.client.networkStatus == NetworkStatusRechable) {
            [self updateTodaysWeather];
            [self updateFiveDayWeather];
        }
        
        __weak typeof(self) wself = self;
        self.client.networkStatusBlock = ^(NetworkStatus status) {
            if (status == NetworkStatusRechable && wself.currLocation) {
                [wself updateTodaysWeather];
                [wself updateFiveDayWeather];
            }
        };
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (!aDecoder) {
        return nil;
    }
    
    OWMWeather *wth;
    WeatherType type = [aDecoder decodeIntegerForKey:kOWMWeatherEncodeDecodeType];
    CLPlacemark *mark = [aDecoder decodeObjectForKey:kOWMWeatherEncodeDecodePlacemark];
    
    if (type == WeatherTypeCustom) {
        wth = [[OWMWeather alloc] initWithPlacemark:mark];
    } else {
         wth = [[OWMWeather alloc] initWithLocationManager:[[OWMLocation alloc] init]];
    }
    
    wth.type = type;
    wth.currLocation = [aDecoder decodeObjectForKey:kOWMWeatherEncodeDecodeLocation];
    wth.today = [[OWMToday alloc] initWithString:[aDecoder decodeObjectForKey:kOWMWeatherEncodeDecodeToday] error:nil];
    wth.weather = [[OWMWeatherData alloc] initWithString:[aDecoder decodeObjectForKey:kOWMWeatherEncodeDecodeWeather] error:nil];
    return wth;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    if (!aCoder) {
        return;
    }
    
    [aCoder encodeObject:_placemark forKey:kOWMWeatherEncodeDecodePlacemark];
    [aCoder encodeObject:_currLocation forKey:kOWMWeatherEncodeDecodeLocation];
    [aCoder encodeObject:_weather.toJSONString forKey:kOWMWeatherEncodeDecodeWeather];
    [aCoder encodeObject:_today.toJSONString forKey:kOWMWeatherEncodeDecodeToday];
    [aCoder encodeInteger:_type forKey:kOWMWeatherEncodeDecodeType];
}

-(NSMutableDictionary *)baseParams{
    return @{ @"APPID" : kWeatherAPIKey }.mutableCopy;
}

-(void)updateTodaysWeather{
    NSMutableDictionary *paramas = [self baseParams];
    [paramas setObject:@(self.currLocation.coordinate.latitude).stringValue forKey:@"lat"];
    [paramas setObject:@(self.currLocation.coordinate.longitude).stringValue forKey:@"lon"];
    
    if (self.client.networkStatus == NetworkStatusRechable) {
        [self.client performGETCallToEndpoint:@"weather" withParameters:paramas andSuccess:^(id  _Nullable responseObject) {
            NSError *error;
            OWMToday *today = [[OWMToday alloc] initWithDictionary:responseObject error:&error];
            
            if (error) {
                [self fireFailedToUpdateWithError:error];
            } else {
                self.today = today;
            }
        } andFailure:^(NSError * _Nullable error) {
            [self fireFailedToUpdateWithError:error];
        }];
    } else {
        [self fireFailedToUpdateWithError:[NSError errorWithDomain:@"com.openweaher.reachability." code:400 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"Internet not reachable. Please connect to the internet and try again." }]];
    }
}

-(void)updateFiveDayWeather{
    NSMutableDictionary *paramas = [self baseParams];
    [paramas setObject:@(self.currLocation.coordinate.latitude).stringValue forKey:@"lat"];
    [paramas setObject:@(self.currLocation.coordinate.longitude).stringValue forKey:@"lon"];
    
    if (self.client.networkStatus == NetworkStatusRechable) {
        [self.client performGETCallToEndpoint:@"forecast" withParameters:paramas andSuccess:^(id  _Nullable responseObject) {
            NSError *error;
            OWMWeatherData *data = [[OWMWeatherData alloc] initWithDictionary:responseObject error:&error];
            
            if (error) {
                [self fireFailedToUpdateWithError:error];
            } else {
                self.weather = data;
            }
        } andFailure:^(NSError * _Nullable error) {
            [self fireFailedToUpdateWithError:error];
        }];
    } else {
        [self fireFailedToUpdateWithError:[NSError errorWithDomain:@"com.openweaher.reachability." code:400 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"Internet not reachable. Please connect to the internet and try again." }]];
    }
}

-(OWMDayForecast *)todayForecast{
    if (_todayForecast) {
        return _todayForecast;
    }
    
    if (self.today && self.weather) {
        NSArray *forecast = [self forecastForDate:self.today.dt];
        if (forecast) {
            _todayForecast = [[OWMDayForecast alloc] initWithDate:self.today.dt andDaysForecast:forecast];
        }
    }
    
    return _todayForecast;
}
-(void)setWeather:(OWMWeatherData *)weather{
    _weather = weather;
    
    if (weather) {
        NSArray<OWMForecast> *list = (id)[weather.list sortedArrayUsingComparator:^NSComparisonResult(OWMForecast * _Nonnull obj1, OWMForecast * _Nonnull obj2) {
            return [obj1.dt compare:obj2.dt];
        }];
        
        _weather.list = list;
        
        [self fireDidUpdateWeather];
    }
}

-(void)setToday:(OWMToday *)today{
    _today = today;
    
    if (today) {
        [self fireDidUpdateTodaysForecast];
    }
}

-(NSArray<OWMDayForecast *> *)forcastForRange:(NSRange)range{
    if (!self.weather) {
        return nil;
    }
    
    NSMutableArray *forecastInRange = [[NSMutableArray alloc] init];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    
    for (int x = (int)range.location; x <= range.length; x++) {
        dayComponent.day = x;
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        NSArray *forecast = [self forecastForDate:nextDate];
        
        if (forecast) {
            OWMDayForecast *day = [[OWMDayForecast alloc] initWithDate:nextDate andDaysForecast:forecast];
            [forecastInRange addObject:day];
        }
    }
    
    return forecastInRange;
}

-(NSArray *)fiveDayForecast{
    return [self forcastForRange:NSMakeRange(1, 5)];
}

-(NSArray *)forecastForDate:(NSDate *)date{
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDate *tdy = [[NSCalendar currentCalendar] dateFromComponents:today];
    
    NSMutableArray *todaysWeather = [[NSMutableArray alloc] init];
    
    for (OWMForecast *forecast in self.weather.list) {
        NSDate *otherDate = [[NSCalendar currentCalendar] dateFromComponents: [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:forecast.dt]];
        if ([tdy isEqualToDate:otherDate]) {
            [todaysWeather addObject:forecast];
        }
    }
    
    return todaysWeather;
}

-(NSString *)summary{
    if (self.today.weather.count) {
        return ((OWMWeatherForecast *)self.today.weather.firstObject).main.capitalizedString;
    } else {
        return @"--";
    }
}

-(NSString *)city{
    if (self.today.name) {
        return self.today.name.capitalizedString;
    } else if (self.weather.city.name) {
        return self.weather.city.name.capitalizedString;
    } else if (self.placemark.locality) {
        return self.placemark.locality.capitalizedString;
    } else {
        return @"--";
    }
}

-(NSString *)currentTemp{
    if (self.today.main.temp) {
        return [OWMConstants kelvinToDefaultTemprature:self.today.main.temp];
    }
    
    return @"--";
}

-(NSString *)todayMinTemp{
    if(self.todayForecast &&  self.todayForecast.min) {
        return [OWMConstants kelvinToDefaultTemprature:self.todayForecast.min];
    }

    return @"--";
}

-(NSString *)todayMaxTemp{
    if(self.todayForecast && self.todayForecast.max) {
        return [OWMConstants kelvinToDefaultTemprature:self.todayForecast.max];
    }

    return @"--";
}

-(NSString *)day{
    if(self.todayForecast && self.todayForecast.day) {
        return self.todayForecast.day;
    }
    
    return @"--";
}

#pragma mark - Location Manager Delegate

-(void)didUpdateLocation:(CLLocation *)location{
    self.currLocation = location;
    
    [self updateTodaysWeather];
    [self updateFiveDayWeather];
}

#pragma mark - Fire Delegate

-(void)fireDidUpdateWeather{
    if (self.delegate && [((NSObject *)self.delegate) respondsToSelector:@selector(didUpdateForecaset:)]) {
        [self.delegate didUpdateForecaset:self];
    }
}

-(void)fireDidUpdateTodaysForecast{
    if (self.delegate && [((NSObject *)self.delegate) respondsToSelector:@selector(didUpdateTodaysWeather:)]) {
        [self.delegate didUpdateTodaysWeather:self.today];
    }
}

-(void)fireFailedToUpdateWithError:(NSError *)error{
    if (self.delegate && [((NSObject *)self.delegate) respondsToSelector:@selector(failedToUpdateForecast:)]) {
        [self.delegate failedToUpdateForecast:error];
    }
}
@end
