//
//  MKMapView+ZoomLevel.h
//  Demo3_MapKit
//
//  Created by liusiyuan on 16/3/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MapKit.h>
@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
