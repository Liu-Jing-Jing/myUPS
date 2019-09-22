//
//  OWMWinds.h
//  openweather-ios
//
//  Created by Harry Singh on 20/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMBaseModel.h"

@interface OWMWinds : OWMBaseModel
@property (strong, nonatomic) NSString<Optional> *speed;
@property (strong, nonatomic) NSString<Optional> *deg;
@end
