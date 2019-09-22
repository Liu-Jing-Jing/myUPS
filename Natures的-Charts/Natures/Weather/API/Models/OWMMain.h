//
//  OWMMain.h
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMBaseModel.h"

@interface OWMMain : OWMBaseModel
@property (strong, nonatomic) NSNumber<Optional> *temp;
@property (strong, nonatomic) NSNumber<Optional> *tempMin;
@property (strong, nonatomic) NSNumber<Optional> *tempMax;
@property (strong, nonatomic) NSNumber<Optional> *pressure;
@property (strong, nonatomic) NSNumber<Optional> *seaLevel;
@property (strong, nonatomic) NSNumber<Optional> *grndLevel;
@property (strong, nonatomic) NSNumber<Optional> *humidity;
@property (strong, nonatomic) NSNumber<Optional> *tempKf;
@end
