//
//  OWMLocation.h
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWMPermissionProtocol.h"
@class MKLocalSearchCompletion;
@class CLPlacemark;
@class CLLocation;

typedef enum : NSInteger {
    StatusUnknown = -1,
    StatusDenied,
    StatusGranted
} Status;

@protocol OWMLocationProtocol
@optional
-(void)searchResults:(NSArray<MKLocalSearchCompletion *> *)results;
-(void)didUpdateLocation:(CLLocation *)location;
@end

@interface OWMLocation : NSObject <OWMPermissionProtocol>
@property (weak, nonatomic) id<OWMLocationProtocol> delegate;
@property (readonly, nonatomic) Status status;
@property (readonly, nonatomic) CLLocation *lastLocation;

+(instancetype)manager;
-(void)searchLocation:(NSString *)location;
-(void)revergeGeocodeAddress:(NSString *)address withCompletion:(void(^)(CLPlacemark *placemark))completion;
@end
