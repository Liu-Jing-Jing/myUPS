//
//  OWMWeatherData.h
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMBaseModel.h"
@class OWMCity;
@protocol OWMForecast;

@interface OWMWeatherData : OWMBaseModel
@property (strong, nonatomic) OWMCity *city;
@property (strong, nonatomic) NSNumber<Optional> *cnt;
@property (strong, nonatomic) NSNumber<Optional> *cod;
@property (strong, nonatomic) NSString<Optional> *message;
@property (strong, nonatomic) NSArray<OWMForecast> *list;

@end
