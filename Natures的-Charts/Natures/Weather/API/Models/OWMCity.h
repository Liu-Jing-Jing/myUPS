//
//  OWMCity.h
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMBaseModel.h"
@class OWMWeatherLocation;

@interface OWMCity : OWMBaseModel
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber<Optional> *population;
@property (strong, nonatomic) OWMWeatherLocation *coord;

@end
