//
//  OWMToday.h
//  openweather-ios
//
//  Created by Harry Singh on 21/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMBaseModel.h"
@class OWMClouds;
@class OWMWeatherLocation;
@class OWMMain;
@class OWMWinds;
@protocol OWMWeatherForecast;

@interface OWMToday : OWMBaseModel
@property (strong, nonatomic) NSString<Optional> *base;
@property (strong, nonatomic) OWMClouds<Optional> *clouds;
@property (strong, nonatomic) NSNumber<Optional> *cod;
@property (strong, nonatomic) OWMWeatherLocation<Optional> *coord;
@property (strong, nonatomic) NSDate<Optional> *dt;
@property (strong, nonatomic) OWMMain<Optional> *main;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSDictionary<Optional> *sys;
@property (strong, nonatomic) NSNumber<Optional> *visibility;
@property (strong, nonatomic) NSArray<OWMWeatherForecast, Optional> *weather;
@property (strong, nonatomic) OWMWinds<Optional> *wind;
@end
