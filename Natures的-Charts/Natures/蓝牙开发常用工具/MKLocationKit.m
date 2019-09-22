//
//  MKLocationKit.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/3.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MKLocationKit.h"
@interface MKLocationKit()<CLLocationManagerDelegate>

@property (nonatomic, strong, readonly)CLLocationManager *locationManager;
@property (nonatomic, strong, readonly)CLLocation *location;
@property (nonatomic, copy)LocationCallBackWithCoordinateBlock locationCallbackBlock;
@property (nonatomic, copy)LocationCallBackWithLocationBlock locationWithLocationCallBackBlock;
@end


@implementation MKLocationKit
@synthesize locationManager = _locationManager;
@synthesize location = _location;
single_implementation(MKLocationKit)
- (void)startUpdateLocationWithCoordinateCompletion:(LocationCallBackWithCoordinateBlock) locationCallBack {
    
    self.locationCallbackBlock = locationCallBack;
    
    [self requestLocationAuthorized];
    
}

- (void)startUpdateLocationWithLocationCompletion:(LocationCallBackWithLocationBlock) locationCallBack {
    self.locationWithLocationCallBackBlock = locationCallBack;
    
    [self requestLocationAuthorized];
}

- (void)startUpdateLocation {
    
    if ([self canUseLocation]) {
        [self.locationManager startUpdatingLocation];
    }else {
        if (self.locationCallbackBlock) {
            self.locationCallbackBlock(NO, kCLLocationCoordinate2DInvalid, nil);
        }
        
        if (self.locationWithLocationCallBackBlock) {
            self.locationWithLocationCallBackBlock(NO, nil, nil);
        }
    }
    
}

- (void)requestLocationAuthorized {
    
    if ([CLLocationManager locationServicesEnabled]) {
        if(@available(iOS 8.0,*)) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }else {
        
#ifdef DEBUG
        NSLog(@"地理位置服务不可用");
#endif
        if (self.locationCallbackBlock) {
            self.locationCallbackBlock(NO, kCLLocationCoordinate2DInvalid, nil);
        }
        if (self.locationWithLocationCallBackBlock) {
            self.locationWithLocationCallBackBlock(NO, nil, nil);
        }
    }
    
}


/**
 是否可以使用定位
 
 即授权未拿到或者未定义plist文件里的授权描述
 info.plist里需要定义的两个key-value信息如下：
 <key>NSLocationAlwaysUsageDescription</key>
 <string>我们将使用你的位置为你提供就近咨询和信息服务</string>
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>我们将使用你的位置为你提供就近咨询和信息服务</string>
 @return YES表示可以使用，NO表示不可以使用，
 */
- (BOOL)canUseLocation {
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        return NO;
    }
    return YES;
}


#pragma mark- CLLocationManagerDelegate
/**
 授权状态变更代理回调
 
 @param manager 位置管理器
 @param status 状态值
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSString *message = nil;
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            [self startUpdateLocation];
            message = @"一直使用地理位置";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self startUpdateLocation];
            message = @"使用期间使用地理位置";
            break;
        case kCLAuthorizationStatusDenied:
            message = @"用户禁用地理位置访问服务";
            break;
        case kCLAuthorizationStatusRestricted:
            message = @"系统定位服务功能被限制";
            break;
        case kCLAuthorizationStatusNotDetermined:
            message = @"用户未决定地理位置的使用";
            break;
        default:
            break;
    }
#ifdef DEBUG
    NSLog(@"地理位置授权状态变化：%@", message);
#endif
    
}
/*
 获取到了定位数据
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    _location = [locations lastObject];
#ifdef DEBUG
    NSLog(@"经纬度可能会获取多次");
    NSLog(@"纬度 = %f", _location.coordinate.latitude);
    NSLog(@"经度  = %f", _location.coordinate.longitude);
#endif
    [self.locationManager stopUpdatingLocation];
    if (self.locationCallbackBlock) {
        self.locationCallbackBlock(YES, _location.coordinate, nil);
    }
    
    if (self.locationWithLocationCallBackBlock) {
        self.locationWithLocationCallBackBlock(YES, _location, nil);
    }
}

/*
 *定位失败
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"定位失败 error: %@", [error description]);
#endif
    if (self.locationCallbackBlock) {
        self.locationCallbackBlock(YES, kCLLocationCoordinate2DInvalid, error);
    }
    if (self.locationWithLocationCallBackBlock) {
        self.locationWithLocationCallBackBlock(YES, nil, error);
    }
}

#pragma mark- getter
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = CLLocationManager.new;
        _locationManager.delegate = self;
        ///期望的精准度。有五个选项值。我们使用的是最好精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        ///刷新距离
        _locationManager.distanceFilter = 10;
    }
    return _locationManager;
}

- (void)setLocationCallbackBlock:(LocationCallBackWithCoordinateBlock) locationCallBack {
    _locationCallbackBlock = locationCallBack;
}

- (void)setLocationWithLocationCallBackBlock:(LocationCallBackWithLocationBlock) locationCallBack {
    _locationWithLocationCallBackBlock = locationCallBack;
}
@end
