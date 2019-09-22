//
//  OWMMain.m
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMMain.h"

@implementation OWMMain

+ (JSONKeyMapper *)keyMapper{
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
