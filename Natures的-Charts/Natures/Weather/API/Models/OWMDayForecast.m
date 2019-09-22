//
//  OWMDayForecast.m
//  openweather-ios
//
//  Created by Harry Singh on 21/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMDayForecast.h"
#import "OWMForecast.h"
#import "OWMMain.h"
#import "OWMConstants.h"
#import "NSDate+Helper.h"

@interface OWMDayForecast()
@property (strong, nonatomic) NSNumber *min;
@property (strong, nonatomic) NSNumber *max;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSArray *forecast;
@property (strong, nonatomic) NSDate *date;
@end

@implementation OWMDayForecast

-(instancetype _Nullable)initWithDate:(NSDate *)date andDaysForecast:(NSArray *)forecast{
    NSAssert(date != nil, @"Date cannot be nil.");
    NSAssert(forecast != nil, @"Forecast cannot be nil.");
    
    if (self = [super init]) {
        self.date = date;
        self.forecast = forecast;
    }
    
    return self;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init unavailable. User initWithDate:andDaysForecast: instead"
                                 userInfo:nil];
}

#pragma mark - Getters / Setters

-(NSNumber *)min{
    if (!_min) {
        __block NSNumber *min;
        
        [self.forecast enumerateObjectsUsingBlock:^(OWMForecast * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!min) {
                min = obj.main.tempMin;
                return;
            }
            
            if (min.integerValue > obj.main.tempMin.integerValue) {
                min = obj.main.tempMin;
                return;
            }
        }];
        
        _min = min;
    }
    
    return _min;
}

-(NSNumber *)max{
    if (!_max) {
        __block NSNumber *max;
        
        [self.forecast enumerateObjectsUsingBlock:^(OWMForecast * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!max) {
                max = obj.main.tempMax;
                return;
            }
            
            if (max.integerValue < obj.main.tempMax.integerValue) {
                max = obj.main.tempMin;
                return;
            }
        }];
        
        _max = max;
    }
    
    return _max;
}

-(NSString *)day{
    return self.date.dayName;
}
@end
