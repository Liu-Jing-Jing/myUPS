//
//  MKLocationKit.h
//  Natures
//
//  Created by 柏霖尹 on 2019/8/3.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN
/**
 地理位置获取之后的回调block
 @param isAuthorized 是否授权
 @param coordinate 获取CLLocation的属性coordinate坐标信息，是个结构体，内部包含经纬度。当为kCLLocationCoordinate2DInvalid表示未定位
 @param error 定位失败时返回的信息，成功时为nil
 */
typedef void(^LocationCallBackWithCoordinateBlock) (BOOL isAuthorized,CLLocationCoordinate2D coordinate ,  NSError * _Nullable error);

/**
 地理位置获取之后的回调block
 
 
 @param isAuthorized 是否授权
 @param location 获取的CLLocation，失败时为nil
 @param error 定位失败时返回的信息，成功时为nil
 */
typedef void(^LocationCallBackWithLocationBlock) (BOOL isAuthorized,CLLocation * _Nullable location ,  NSError * _Nullable error);


@interface MKLocationKit : NSObject
single_interface(MKLocationKit)

/**
 请求对地理位置获取的授权
 第一次创建kit对象时，会做授权操作，授权结束后我们会去做一次定位。但是授权结束后，不会再去做定位了。如果再想拿同一个对象获取获取定位信息，请使用开始定位来获取
 */
- (void)requestLocationAuthorized;


/**
 开启地理位置获取，并且传递地理位置获取成功后的回调block
 
 因为地理位置的获取是异步的，所以等拿到数据之后再上传
 
 
 @param locationCallBack 地理位置获取成功后的回调
 */
- (void)startUpdateLocationWithCoordinateCompletion:(LocationCallBackWithCoordinateBlock) locationCallBack;

- (void)startUpdateLocationWithLocationCompletion:(LocationCallBackWithLocationBlock) locationCallBack;


/**
 设置定位成功之后回调，通过回调获取数据
 
 @param locationCallBack 回调block
 */
- (void)setLocationCallbackBlock:(LocationCallBackWithCoordinateBlock) locationCallBack;

- (void)setLocationWithLocationCallBackBlock:(LocationCallBackWithLocationBlock) locationCallBack;

/**
 开始更新定位信息。当授权完成之后，仍然使用当前定位对象时，可以使用该方法更新定位数据
 */
- (void)startUpdateLocation;
@end

NS_ASSUME_NONNULL_END
