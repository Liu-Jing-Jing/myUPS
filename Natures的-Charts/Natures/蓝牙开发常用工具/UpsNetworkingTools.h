//
//  UpsNetwroTools.h
//  Natures
//
//  Created by 柏霖尹 on 2019/8/30.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "HttpTool.h"
@class UpsModel, MessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface UpsNetworkingTools : HttpTool
/** 上传新的消息数据的请求接口*/
+ (void)upsReadallMessage:(NSArray<MessageModel *> *)modelArray success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSDictionary *message)) failure;
+ (void)upsAddNewMessageModel:(NSArray<MessageModel *> *)modelArray withUUIDString:(NSString *)guid success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSDictionary *message)) failure
+ (void)upsAddNewMessageMode:(NSArray<MessageModel *> *)modelArray success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSDictionary *message)) failure;
/** 上传历史数据的请求接口*/
+ (void)postManyUPSDataToServer:(NSArray *)models success:(void (^)(id resultDict))success failure:(void (^)(NSError * error))failure;
/** 上传历史数据的请求接口*/
+ (void)postUPSDataToServer:(UpsModel *)model success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;
/**
 应急电源测试账号登录 返回是否成功
 */
+ (void)addUPSSignleData:(NSString *)str;

/** 返回模型 不给我时间,返回当天的时间数据*/
+ (void)getUpsRangeDataWithStartDate:(NSDate *)start endDate:(NSDate *)endDate UUIDString:(NSString *)gud success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;
+ (void)getUpsRangeDataWithCurrentDay:(NSDate *)start UUIDString:(NSString *)gud success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;
+ (void)getUpsDateWithUUIDString:(NSString *)gud byYYYYstring:(NSString *)yyyy success:(void (^)(NSArray *response))success failure:(void (^)(NSError * error))failure;

+ (void)getUpsDateWithUUIDString:(NSString *)gud byYYYYMMstring:(NSString *)month success:(void (^)(NSArray *response))success failure:(void (^)(NSError * error))failure;
+ (void)upsLoginAction:(void(^)(BOOL state, NSString *message))resultBlock;
@end

NS_ASSUME_NONNULL_END
