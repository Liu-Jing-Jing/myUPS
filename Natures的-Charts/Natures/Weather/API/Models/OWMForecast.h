//
//  OWMForecast.h
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMBaseModel.h"
@class OWMMain;
@class OWMClouds;
@class OWMWinds;
@class OWMRain;
@class OWMSnow;
@protocol OWMWeatherForecast;

@interface OWMForecast : OWMBaseModel
@property (strong, nonatomic) OWMClouds<Optional> *clouds;
@property (strong, nonatomic) OWMWinds<Optional> *wind;
@property (strong, nonatomic) NSDate<Optional> *dt;
@property (strong, nonatomic) OWMRain<Optional> *rain;
@property (strong, nonatomic) NSDate<Optional> *dt_txt;
@property (strong, nonatomic) OWMMain<Optional> *main;
@property (strong, nonatomic) NSArray<OWMWeatherForecast> *weather;
@property (strong, nonatomic) OWMSnow<Optional> *snows;
@property (strong, nonatomic) NSDictionary<Optional> *sys;

@end
