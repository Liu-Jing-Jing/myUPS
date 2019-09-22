//
//  OWMLocation.m
//  openweather-ios
//
//  Created by Harry Singh on 19/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "OWMLocation.h"
@import CoreLocation;
@import MapKit;

NSString * const kLocationStatus = @"com.owm.location.status";

@interface OWMLocation() <CLLocationManagerDelegate, MKLocalSearchCompleterDelegate> {
    NSNumber *_internalStatus;
}

@property (strong, nonatomic) NSNumber *internalStatus;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) MKLocalSearchCompleter *searchCompleter;
@property (strong, nonatomic, nullable) PermissionCompletionHandler permissionHandler;
@property (strong, nonatomic) NSDate *lastTimestamp;
@property (strong, nonatomic) CLLocation *lastLocation;
@end

@implementation OWMLocation

#pragma mark - Instance

+(instancetype)manager{
    static dispatch_once_t onceToken;
    static OWMLocation *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[OWMLocation alloc] init];
    });
    
    return sharedManager;
}

-(instancetype)init{
    if(self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        [self startUpdatingLocation];
        
        self.searchCompleter = [[MKLocalSearchCompleter alloc] init];
        self.searchCompleter.filterType = MKSearchCompletionFilterTypeLocationsOnly;
        self.searchCompleter.delegate = self;
        self.geocoder = [[CLGeocoder alloc] init];
    }

    return self;
}

- (void)startUpdatingLocation{
    if (self.status == StatusGranted) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *mostRecentLocation = locations.lastObject;
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval = self.lastTimestamp ? [now timeIntervalSinceDate:self.lastTimestamp] : 0;
    
    if (!self.lastLocation || (!self.lastTimestamp || interval >= 5 * 60)){
        self.lastTimestamp = now;
        
        if (self.delegate && [((NSObject *)self.delegate) respondsToSelector:@selector(didUpdateLocation:)]) {
            [self.delegate didUpdateLocation:mostRecentLocation];
        }
    }
    
    self.lastLocation = mostRecentLocation;
}

#pragma mark - Permission

- (void)requestPermission {
    //Already have permission. Bail.
    if (self.status == StatusGranted) {
        return;
    }
    
    if (self.status == StatusUnknown) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self updateInternalStatusWithStatus:[CLLocationManager authorizationStatus]];
    }
}

-(void)updateInternalStatusWithStatus:(CLAuthorizationStatus)status{
    //Shouldnt reach here. Update status now that we are here.
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        self.internalStatus = @(StatusDenied);
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        self.internalStatus = @(StatusUnknown);
    } else {
        self.internalStatus = @(StatusGranted);
    }
    
    [self startUpdatingLocation];
    [self checkAndFirePermissionHandler];
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [self updateInternalStatusWithStatus:status];
}

#pragma mark - Reverce gerocode

-(void)revergeGeocodeAddress:(NSString *)address withCompletion:(void(^)(CLPlacemark *placemark))completion{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (completion) {
            completion(placemarks.firstObject);
        }
    }];
}

#pragma mark - Search

-(void)searchLocation:(NSString *)location{
    self.searchCompleter.queryFragment = location;
}

#pragma mark - Getters/Setters

-(NSNumber *)internalStatus{
    if (!_internalStatus && [[NSUserDefaults standardUserDefaults] objectForKey:kLocationStatus]) {
        _internalStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationStatus];
    } else if (!_internalStatus) {
        _internalStatus = @(StatusUnknown);
    }
    
    return _internalStatus;
}

-(void)setInternalStatus:(NSNumber *)internalStatus{
    _internalStatus = internalStatus;
    
    [[NSUserDefaults standardUserDefaults] setObject:internalStatus forKey:kLocationStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(Status)status{
    if (self.internalStatus && self.internalStatus.integerValue) {
        return self.internalStatus.integerValue;
    }
    
    return StatusUnknown;
}

#pragma mark - Permission Protocol

- (NSAttributedString *)message {
    return [[NSAttributedString alloc] initWithString:@"Location permission is required to display your local weather." attributes:nil];
}

-(void)checkAndFirePermissionHandler{
    if (self.permissionHandler) {
        self.permissionHandler(self.status == StatusUnknown ? PermissionDenied : PermissionGranted);
        self.permissionHandler = nil;
    }
}

-(void)requestPermissionWithCompletion:(PermissionCompletionHandler)completion{
    if (self.permissionHandler) {
        return;
    }
    
    self.permissionHandler = completion;
    [self requestPermission];
}

#pragma mark - MKLocationCompleter Protocol

- (void)completerDidUpdateResults:(MKLocalSearchCompleter *)completer{
    if (self.delegate) {
        [self.delegate searchResults:completer.results];
    }
}

@end
