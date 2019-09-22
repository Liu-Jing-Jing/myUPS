//
//  OWMDayForecast.h
//  openweather-ios
//
//  Created by Harry Singh on 21/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWMDayForecast : NSObject
@property (readonly, nonatomic, nonnull) NSNumber *min;
@property (readonly, nonatomic, nonnull) NSNumber *max;
@property (readonly, nonatomic, nonnull) NSString *day;
@property (readonly, nonatomic, nonnull) NSArray *forecast;
@property (readonly, nonatomic, nonnull) NSDate *date;

-(instancetype _Nullable)initWithDate:(NSDate * _Nonnull)date andDaysForecast:(NSArray * _Nonnull)forecast;
@end
