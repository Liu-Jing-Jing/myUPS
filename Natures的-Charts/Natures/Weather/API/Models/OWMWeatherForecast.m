//
//  OWMWeatherForecast.m
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMWeatherForecast.h"
#import "OWMConstants.h"

@implementation OWMWeatherForecast

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"desc": @"description"
                                                                  }];
}

-(void)setIcon:(NSString *)icon{
    if (icon && icon.length) {
        _icon = kWeatherIconURLString(icon);
    }    
}

@end
