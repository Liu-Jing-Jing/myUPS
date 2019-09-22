//
//  OWMWeatherForecast.h
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMBaseModel.h"

@interface OWMWeatherForecast : OWMBaseModel
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *icon;
@end
