
//
//  UpsNetwroTools.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/30.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "UpsNetworkingTools.h"
#import "UpsModel.h"
#import "MessageModel.h"
#import "SymbolsValueFormatter.h"
#import "DateValueFormatter.h"
#import "AFNetworking.h"
@implementation UpsNetworkingTools
+ (void)postUPSDataToServer:(UpsModel *)model success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    model.elec = @0.0; // 不全一个参数
    model.mac = @"08:7C:BE:CA:BF:63";//,08:7C:BE:CA:BF:63,GUD2800102
    NSArray* upsPropertys = [model getAllObjCIvarList];
    upsPropertys = [upsPropertys subarrayWithRange:NSMakeRange(1, 24)];
    NSMutableString *param = [NSMutableString string];
    for (NSString *varName in upsPropertys)
    {
        NSString *value = [NSString stringWithFormat:@"%@", [model valueForKey:varName]];
        if([varName isEqualToString:@"elec"]) value = @"0";
        [param appendString: value];
        [param appendString:@","];
    }
    [param deleteCharactersInRange:NSMakeRange(param.length-1, 1)];
    //[param appendString:@";"];
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/add",Host];
    
    
    [[self shareInstance] postWithSessionRequest:urlString parameters:@{@"str": param} success:^(id responseObject) {
        NSLog(@"%@---%@", responseObject[@"message"]);
        if(success)
        {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        // 错误的处理方法
        if(failure)
        {
            failure(error);
        }
    }];
}



+ (void)postManyUPSDataToServer:(NSArray *)models success:(void (^)(id resultDict))success failure:(void (^)(NSError * error))failure
{
    NSMutableString *upsHistoryStr = [NSMutableString string];
    for (UpsModel *model in models)
    {
        model.elec = @0.0; // 不全一个参数
        model.mac = @"08:7C:BE:CA:BF:63";//,08:7C:BE:CA:BF:63,GUD2800102
        NSArray* upsPropertys = [model getAllObjCIvarList];
        upsPropertys = [upsPropertys subarrayWithRange:NSMakeRange(0, 24)]; //需要上传的24个值
        if([[upsPropertys firstObject] isEqualToString:@"temperature"] && [[upsPropertys lastObject] isEqualToString:@"uuids"]) NSLog(@"有效的model参数");
        
        NSMutableString *param = [NSMutableString string];
        for (NSString *varName in upsPropertys)
        {
            NSString *value = [NSString stringWithFormat:@"%@", [model valueForKey:varName]];
            [param appendString: value];
            [param appendString:@","];
        }
        [param deleteCharactersInRange:NSMakeRange(param.length-1, 1)];
        [param appendString:@";"];
        
        [upsHistoryStr appendString:param];
    }
    //3.创建request
    NSMutableURLRequest * requst = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://app.f-union.com/sjtyApi/app/upsData/addbatch"]];
    //4.设置请求方式，默认为GET
    requst.HTTPMethod = @"POST";
    [requst setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    requst.HTTPBody = [upsHistoryStr dataUsingEncoding:NSUTF8StringEncoding];
    //6.创建请求。self.session为AFNSessionManager的对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",nil];
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil) {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [requst setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    __block NSURLSessionDataTask *task;
    task = [manager dataTaskWithRequest:requst completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //to do ，请求返回
        NSDictionary *dict;
        if([responseObject[@"status"] intValue] == 200)
        {
            dict=@{@"status":@"200",
                   @"message":@"同步成功"
                   };
        }
        else if(error.code==-1001)
        {
            dict=@{@"status":@"-1001",
                   @"message":TIMEOUT
                   };
        }else if (error.code==-1009)
        {
            dict=@{@"status":@"-1009",
                   @"message":NONETWORK
                   };
        }
        else
        {
            dict=@{@"status":@"-1001",
                   @"message":ERROR
                   };
        }
            
            if(error)
            {
                if(failure)
                {
                    failure(error);
                }
            }
            else
            {
                if(success)
                {
                    
                    success(dict);
                }
            }
    }];
    //发起请求，千万不要忘了这句话
    [task resume];
}


+ (void)upsAddNewMessageModel:(NSArray<MessageModel *> *)modelArray withUUIDString:(NSString *)guid success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSDictionary *message)) failure
{
    NSString *urlString =[NSString stringWithFormat:@"http://app.f-union.com/sjtyApi/app/message/addBatch"];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<modelArray.count; i++) {
        MessageModel *model = modelArray[i];
        //model.productId = PRODUCTID.stringValue;
        NSMutableDictionary *dict= [[model toDictionary] mutableCopy];
        [dict setObject:@"上传正确的mac" forKey:@"mac"];
        [dict setObject:guid forKey:@"uuid"];
        [array addObject:dict];
    }
    
    [[self shareInstance] postWithSessionRequest:urlString parameters:array success:^(id responseObject) {
        //
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        //
        NSDictionary *dict;
        if (error.code==-1001) {
            dict=@{@"status":@"-1001",
                   @"message":TIMEOUT
                   };
        }else if (error.code==-1009) {
            dict=@{@"status":@"-1009",
                   @"message":NONETWORK
                   };
        }else{
            dict=@{@"status":@"-1001",
                   @"message":ERROR
                   };
        }
        if (failure)
        {
            failure(error, dict);
        }
    }];
}

+ (void)upsReadallMessage:(NSArray<MessageModel *> *)modelArray success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSDictionary *message)) failure
{
    NSString *urlString =[NSString stringWithFormat:@"http://app.f-union.com/sjtyApi/app/message/readBatch"];
    
    [[HttpTool shareInstance] postWithSessionRequest:urlString parameters:modelIDs success:^(id responseObject) {
        //
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        //
        NSDictionary *dict;
        if (error.code==-1001) {
            dict=@{@"status":@"-1001",
                   @"message":TIMEOUT
                   };
        }else if (error.code==-1009) {
            dict=@{@"status":@"-1009",
                   @"message":NONETWORK
                   };
        }else{
            dict=@{@"status":@"-1001",
                   @"message":ERROR
                   };
        }
        if (failure)
        {
            failure(error, dict);
        }
    }];
}

#pragma mark - 功率接口
+ (void)getUpsPowerUsedWithYYYY:(NSString *)yyyyString UUIDString:(NSString *)gud success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    {
        //http://app.shfch.net/sjtyApi/app/upsData/selectByDate
        NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectPowerByYYYY",Host];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //获得这个月的PowerUsed
#warning 修改新的接口 得到的是年字符串
        [params setObject:yyyyString];
        [params setObject:gud forKey:@"guid"];
        
        
        [[self shareInstance] getRequest:urlString parameters:params success:^(id responseObject) {
            NSLog(@"Range data-------response   %@", responseObject[@"message"]);
            //        NSMutableArray *models = [NSMutableArray arrayWithCapacity:100];
            //        for (NSDictionary *upsDic in responseObject[@"data"])
            //        {
            //            UpsModel *upsMode = [[UpsModel alloc] initWithDictionary:upsDic];
            //            [models addObject:upsMode];
            //        }
            if(success && models)
            {
                success(models);
            }
        } failure:^(NSError *error) {
#warning 出错的处理
            if(failure)
            {   //
                failure(error);
            }
        }];
    }
}

// 需要yyyy MM格式的字符串
+ (void)getUpsPowerUsedWithCurrentMonthYYYYMM:(NSString *)yyyyMMString UUIDString:(NSString *)gud success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    //http://app.shfch.net/sjtyApi/app/upsData/selectByDate
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectPowerByMM",Host];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获得这个月的PowerUsed
    //[params setObject:[theMonth convertToNumberStringYYYYmmDD] forKey:@"yyyyMM"];
    [params setObject:yyyyMMString forKey:@"yyyyMM"];
    [params setObject:gud forKey:@"guid"];
    
    
    [[self shareInstance] getRequest:urlString parameters:params success:^(id responseObject) {
        NSLog(@"Range data-------response   %@", responseObject[@"message"]);
//        NSMutableArray *models = [NSMutableArray arrayWithCapacity:100];
//        for (NSDictionary *upsDic in responseObject[@"data"])
//        {
//            UpsModel *upsMode = [[UpsModel alloc] initWithDictionary:upsDic];
//            [models addObject:upsMode];
//        }
        if(success && models)
        {
            success(models);
        }
    } failure:^(NSError *error) {
#warning 出错的处理
        if(failure)
        {   //
            failure(error);
        }
    }];
}
#pragma - mark
+ (void)getUpsDataByMonth:(NSDate *)yyyyMM success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectByMM",Host];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[NSDate getDateFromDate:<#(NSDate *)#> withDay:<#(NSInteger)#>]
    [[self shareInstance] getRequest:urlString parameters:params success:^(id responseObject) {
        NSLog(@"Range data-------response   %@", responseObject[@"message"]);
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:100];
        for (NSDictionary *upsDic in responseObject[@"data"])
        {
            UpsModel *upsMode = [[UpsModel alloc] initWithDictionary:upsDic];
            [models addObject:upsMode];
        }
        if(success && models)
        {
            success(models);
        }
    } failure:^(NSError *error) {
#warning 出错的处理
        if(failure)
        {   //
            failure(error);
        }
    }];
}


/**
 获得当前日期的dl历史数据信息

 @param start k当天的Date对象
 @param gud 设备的唯一SN
 @param success 成功
 @param failure 失败
 */
+ (void)getUpsRangeDataWithCurrentDay:(NSDate *)start UUIDString:(NSString *)gud success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    //http://app.shfch.net/sjtyApi/app/upsData/selectByDate
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectByDay",Host];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获得当天的数据
    [params setObject:[start convertToNumberStringYYYYmmDD] forKey:@"yyyyMMdd"];
    [params setObject:gud forKey:@"guid"];
    
    [[self shareInstance] getRequest:urlString parameters:params success:^(id responseObject) {
        NSLog(@"Range data-------response   %@", responseObject[@"message"]);
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:100];
        for (NSDictionary *upsDic in responseObject[@"data"])
        {
            UpsModel *upsMode = [[UpsModel alloc] initWithDictionary:upsDic];
            [models addObject:upsMode];
        }
        if(success && models)
        {
            success(models);
        }
    } failure:^(NSError *error) {
#warning 出错的处理
        if(failure)
        {   //
            failure(error);
        }
    }];
}
+ (void)getUpsRangeDataWithStartDate:(NSDate *)start endDate:(NSDate *)endDate UUIDString:(NSString *)gud success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    //http://app.shfch.net/sjtyApi/app/upsData/selectByDate
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectByDate",Host];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(start && endDate)
    {
        //拼上参数
        [params setObject:[start convertToNumberStringYYYYmmDD] forKey:@"startyyyyMMdd"];
        [params setObject:[endDate convertToNumberStringYYYYmmDD] forKey:@"endyyyyMMdd"];
        [params setObject:gud forKey:@"gud"];
    }
    else
    {
        //获得当天的数据
        NSDate *now = [NSDate date];
        [params setObject:[now convertToNumberStringYYYYmmDD] forKey:@"yyyyMMdd"];
        [params setObject:gud forKey:@"guid"];
        urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectByDay",Host];
    }
    
    [[self shareInstance] getRequest:urlString parameters:params success:^(id responseObject) {
        NSLog(@"Range data-------response   %@", responseObject[@"message"]);
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:100];
        for (NSDictionary *upsDic in responseObject[@"data"])
        {
            UpsModel *upsMode = [[UpsModel alloc] initWithDictionary:upsDic];
            [models addObject:upsMode];
        }
        if(success && models)
        {
            success(models);
        }
    } failure:^(NSError *error) {
#warning 出错的处理
        if(failure)
        {   //
            failure(error);
        }
    }];
}

+ (void)getUpsDateWithUUIDString:(NSString *)gud byYYYYstring:(NSString *)yyyy success:(void (^)(NSArray *response))success failure:(void (^)(NSError * error))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectByYYYY",Host];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if([yyyy length] == 4 && [yyyy intValue])
    {
        //拼上参数
        [params setObject:yyyy forKey:@"yyyy"];
        [params setObject:gud forKey:@"guid"];

    }
    else
    {
        //获得今年d的数据
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY"];
        [params setObject:gud forKey:@"guid"];
        [params setObject:[formatter stringFromDate:now] forKey:@"yyyy"];
    }
    
    [[HttpTool shareInstance] getRequest:urlString parameters:params success:^(id responseObject) {
        NSLog(@"Range data-------response   %@", responseObject[@"message"]);
        if(success)
        {
            if([responseObject[@"message"] isEqualToString:@"请求成功"])
            {
                NSMutableArray *models = [NSMutableArray arrayWithCapacity:100];
                for (NSDictionary *upsDic in responseObject[@"data"])
                {
                    UpsModel *upsMode = [[UpsModel alloc] initWithDictionary:upsDic];
                    [models addObject:upsMode];
                }
                success(models);
            }
        }
    } failure:^(NSError *error) {
#warning 出错的处理
        if(failure)
        {   //
            failure(error);
        }
    }];
}


/**
 获得月的数据
 */
+ (void)getUpsDateWithUUIDString:(NSString *)gud byYYYYMMstring:(NSString *)month success:(void (^)(NSArray *response))success failure:(void (^)(NSError * error))failure;
{
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/upsData/selectByMM",Host];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if([month length] == 6 && [month intValue])
    {
        //拼上参数
        [params setObject:month forKey:@"yyyyMM"];
        [params setObject:gud forKey:@"guid"];
    }
    
    [[HttpTool shareInstance] getRequest:urlString parameters:params success:^(id responseObject) {
        NSLog(@"当月数据的接口response   %@", responseObject[@"message"]);
        if(success)
        {
            if([responseObject[@"message"] isEqualToString:@"请求成功"])
            {
                NSMutableArray *models = [NSMutableArray arrayWithCapacity:100];
                for (NSDictionary *upsDic in responseObject[@"data"])
                {
                    UpsModel *upsMode = [[UpsModel alloc] initWithDictionary:upsDic];
                    [models addObject:upsMode];
                }
                success(models);
            }
        }
    } failure:^(NSError *error) {
#warning 出错的处理
        if(failure)
        {   //
            failure(error);
        }
    }];
}


+ (void)upsLoginAction:(void(^)(BOOL state, NSString *message))resultBlock
{
    __block BOOL flag = NO;
    NSString *param1 = @"2860797579@qq.com"; //@"2860797579@qq.com";
    NSString *param2 = @"123456";
    [[HttpTool shareInstance] login:param1 Password:param2 Block:^(NSDictionary * _Nonnull dictionary) {
        //NSLog(@"OKKKKK  登录啦---%@", dictionary[@"status"]);
        NSString *msg = [NSString stringWithFormat:@"%@", dictionary[@"message"]];
        
        // 服务器返回的状态码
        NSString *code = [NSString stringWithFormat:@"%@", dictionary[@"status"]];
        if([code isEqualToString:@"201"] || [code isEqualToString:@"200"] || [msg isEqualToString:@"登录成功"])
        {
            flag = YES;
            if(resultBlock)
            {
                return resultBlock(flag, dictionary[@"message"]);
            }
        }
        else
        {
            if(resultBlock)
            {
                resultBlock(flag, dictionary[@"message"]);
            }
            
        }
    }];
}
@end
