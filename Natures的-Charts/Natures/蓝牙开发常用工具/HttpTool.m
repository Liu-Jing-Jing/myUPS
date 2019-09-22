//
//  HttpTool.m
//  junhua
//
//  Created by sjty on 2019/7/24.
//  Copyright © 2019 com.sjty. All rights reserved.
//
#import "SVProgressHUD.h"
#import "HttpTool.h"
#import "AFNetworking.h"
#import <CoreTelephony/CTCellularData.h>
NSString * const responseSuccess[2] =
{
    @"200",
    @"201"
};
NSString * const responseError[3] =
{
    @"300",
    @"301",
    @"302"
};
static HttpTool *httpToolInstance = nil;
@interface HttpTool()
@property(nonatomic)NSURLSessionDataTask *task;
@end
@implementation HttpTool
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (httpToolInstance == nil) {
            httpToolInstance = [[self alloc]init];
            [httpToolInstance loadNetwork];
        }
    });
    return httpToolInstance;
}

-(void)loadNetwork
{
//    [self loadHtml];
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
                [self loadHtml];
                break;
            case kCTCellularDataNotRestricted:
                // 没有网络的时候提示用户
                break;
            case kCTCellularDataRestrictedStateUnknown:
                
                break;
            default:
                break;
        };
    };
}


-(void)loadHtml{
    
    NSURL *url = [NSURL URLWithString:@"http://sjtyservice.shfch.net"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}
#pragma mark - SJTY session 通用接口
-(void)postRequest:(NSString *)URLString  parameters:(id)parameters success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", nil];
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    _task =[manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse*)task.response;
        NSDictionary *dictTTTTTEMP = httpURLResponse.allHeaderFields;
        [[NSUserDefaults standardUserDefaults] setObject:[[dictTTTTTEMP valueForKey:@"Cookie"] substringFromIndex:9] forKey:@"SessionID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
-(void)postWithSessionRequest:(NSString *)URLString  parameters:(id)parameters success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure{//@"a,b,c,d,e;a,b,c,d,e;a,b,c,d,e;"
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",nil];
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil)
    {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    
    NSLog(@"发送了POST %@-------params:%@", URLString, parameters);
    _task =[manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)getRequest:(NSString *)URLString  parameters:(NSDictionary *)parameters success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer new];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet
                                                         setWithObject:@"application/json"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.0f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil)
    {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    
    
    _task =[manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)deleteRequest:(NSString *)URLString  parameters:(NSDictionary *)parameters success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer new];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet
                                                         setWithObject:@"application/json"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.0f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    
    _task =[manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


#pragma mark - 用户账号密码相关的模块
+ (void)facebookLoginWithParam:(NSDictionary *)params success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure
{
    NSString *urlstring = [NSString stringWithFormat:@"%@/sjtyApi/app/loginWithTripartite", Host];
    [[HttpTool shareInstance] postRequest:urlstring
                               parameters:params success:^(id responseObject) {
                                   //
                                   NSLog(@"Facebook---------%@", responseObject);
                                   if (success)
                                   {
                                       success(responseObject);
                                   }
                                   
                               } failure:^(NSError *error) {
                                   if(failure)
                                   {
                                       failure(error);
                                   }
                               }];
}
-(void)login:(NSString *)email Password:(NSString *)password Block:(void(^)(NSDictionary * dictionary)) block
{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/login?contactKey=%@&password=%@&productId=%@",Host,email,password,PRODUCTID];
//#warning 要修改的部分
//    NSDictionary *params = @{@"contactKey": email, @"password":password, @"productId": [NSString stringWithFormat:@"%@", PRODUCTID]};
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"contactKey"];
    [params setObject:password forKey:@"password"];
    [params setObject:PRODUCTID forKey:@"productId"];
    
    [self postRequest:url parameters:params success:^(id responseObject) {
        NSDictionary *dict;
        if ([[responseObject valueForKey:@"status"] integerValue]==201) {
            dict=@{@"status":[responseObject valueForKey:@"status"],
                   @"message":[responseObject valueForKey:@"message"]
                   };
            [[NSUserDefaults standardUserDefaults] setObject: [responseObject valueForKey:@"data"] forKey:@"SessionID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else if ([[responseObject valueForKey:@"status"] integerValue]==300){
            dict=@{@"status":[responseObject valueForKey:@"status"],
                   @"message":@"Login failed"
                   };
        }
        if (block) {
            block(dict);
        }
    } failure:^(NSError *error) {
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
        if (block) {
            block(dict);
        }
    }];
}


-(void)registerNewuser:(NSString *)email withName:(NSString *)firstAndLastName Password:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * dictionary))block
{
    NSString *url=[NSString stringWithFormat:@"http://app.f-union.com/sjtyApi/app/register"];
    NSDictionary *dict=@{@"contactKey":email,
                         @"password":password,
                         @"code":code,
                         @"productId":PRODUCTID
                         };
    [self postWithSessionRequest:url parameters:dict success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        if ([[responseObject valueForKey:@"status"] integerValue]==201)
        {
            [[NSUserDefaults standardUserDefaults] setObject: [responseObject valueForKey:@"data"] forKey:@"SessionID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (block)
        {
            
            NSDictionary *dict;
            if ([[responseObject valueForKey:@"status"] integerValue]==201) {
                dict=@{@"status":[responseObject valueForKey:@"status"],
                       @"message":[responseObject valueForKey:@"message"]
                       };
            }else if ([[responseObject valueForKey:@"status"] integerValue]==201){
                dict=@{@"status":[responseObject valueForKey:@"status"],
                       @"message":[responseObject valueForKey:@"message"]
                       };
            }
            
            block(dict);
        }
    } failure:^(NSError *error) {
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
        
        if (block) {
            block(dict);
        }
    }];
}


-(void)registerUser:(NSString *)email withName:(NSString *)firstAndLastName Password:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * dictionary))block
{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/loginAndReg",Host];
    NSDictionary *dict=@{@"contactKey":email,
                         @"password":password,
                         @"code":code,
                         @"productId":PRODUCTID,
                         @"userName": firstAndLastName
                         };
    [self postWithSessionRequest:url parameters:dict success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        if ([[responseObject valueForKey:@"status"] integerValue]==201)
        {
            [[NSUserDefaults standardUserDefaults] setObject: [responseObject valueForKey:@"data"] forKey:@"SessionID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (block)
        {
            
            NSDictionary *dict;
            if ([[responseObject valueForKey:@"status"] integerValue]==201) {
                dict=@{@"status":[responseObject valueForKey:@"status"],
                       @"message":[responseObject valueForKey:@"message"]
                       };
            }else if ([[responseObject valueForKey:@"status"] integerValue]==201){
                dict=@{@"status":[responseObject valueForKey:@"status"],
                       @"message":[responseObject valueForKey:@"message"]
                       };
            }
            
            block([responseObject valueForKey:@"status"]);
        }
    } failure:^(NSError *error) {
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
        
        if (block) {
            block(dict);
        }
    }];
}
//y蔡工的注册模块
-(void)orgRegisterUser2:(NSString *)email Password:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * dictionary))block{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/loginAndReg",Host];
    NSDictionary *dict=@{@"contactKey":email,
                         @"password":password,
                         @"code":code,
                         @"productId":PRODUCTID
                         };
    //NSString *str = @"\{\"code\": \"0000\",\"contactKey\": \"1515352281@qq.com\",\"password\": \"111111\",\"productId\": 1147401843442315265}";
    //NSLog(@"%@\n", str);
    //dict = @{@"clientUserLoginVo": @"\{\"code\": \"0000\",\"contactKey\": \"1515352281@qq.com\",\"password\": \"111111\",\"productId\": 1147401843442315265}"};
    [self postWithSessionRequest:url parameters:dict success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        if ([[responseObject valueForKey:@"status"] integerValue]==201) {
            [[NSUserDefaults standardUserDefaults] setObject: [responseObject valueForKey:@"data"] forKey:@"SessionID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if (block) {
            
            NSDictionary *dict;
            if ([[responseObject valueForKey:@"status"] integerValue]==201) {
                dict=@{@"status":[responseObject valueForKey:@"status"],
                       @"message":[responseObject valueForKey:@"message"]
                       };
            }else if ([[responseObject valueForKey:@"status"] integerValue]==201){
                dict=@{@"status":[responseObject valueForKey:@"status"],
                       @"message":[responseObject valueForKey:@"message"]
                       };
            }
            
            block(dict);
        }
    } failure:^(NSError *error) {
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
        if (block) {
            block(dict);
        }
    }];
}

/**  修改密码  @param email 需要修改的账号  @param password 新密码  @param code 需要提前发送验证码  @param block 成功后的回调*/
- (void)changePasswordUsingEmail:(NSString *)email newPassword:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * _Nonnull))block{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/updatePwdByCode?contactKey=%@&newPwd=%@&code=%@&productId=%@",Host,email,password,code,PRODUCTID];
    NSDictionary *dict=@{};
    
    [self postWithSessionRequest:url parameters:dict success:^(id responseObject) {
        
        if ([[responseObject valueForKey:@"status"] integerValue]==200) {
            if (block) {
                NSDictionary *dict=@{@"status":[responseObject valueForKey:@"status"],
                                    @"message":[responseObject valueForKey:@"message"]
                                    };
                block(dict);
            }
//            [[NSUserDefaults standardUserDefaults] setObject: [responseObject valueForKey:@"data"] forKey:@"SessionID"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            if (block) {
                
                NSDictionary *dict;
                if ([[responseObject valueForKey:@"status"] integerValue]==201) {
                    dict=@{@"status":[responseObject valueForKey:@"status"],
                           @"message":[responseObject valueForKey:@"message"]
                           };
                }else if ([[responseObject valueForKey:@"status"] integerValue]==201){
                    dict=@{@"status":[responseObject valueForKey:@"status"],
                           @"message":[responseObject valueForKey:@"message"]
                           };
                }
                
                block(dict);
            }
        }
        
    } failure:^(NSError *error) {
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
        if (block) {
            block(dict);
        }
    }];
    
}

/**第一个参数是邮箱 Email告诉我 @param email 第一个参数是邮箱  @param block 返回成功*/
- (void)getCode:(NSString *)email Block:(void (^)(NSDictionary * dictionary))block{
    
    NSString *url =[NSString stringWithFormat:@"%@/sjtyApi/app/sendCode_1?contactKey=%@&productId=%@&language=en_US&simulation=0",Host,email, PRODUCTID];
    
    //url = [NSString stringWithFormat:@"%@/sjtyApi/app/sendCode_1",Host];
    //NSDictionary *dict=@{@"contactKey": email, @"productId" : PRODUCTID, @"language": @"en_US", @"simulation": @"0"};
    [self postRequest:url parameters:@{} success:^(id responseObject)
     {
         
         NSLog(@"%@", responseObject);
         if ([[responseObject objectForKey:@"status"] integerValue]==200)
         {
             if (block)
             {
                 NSDictionary *dic=@{@"status":[responseObject objectForKey:@"status"]};
                 block(dic);
             }
         }
     } failure:^(NSError *error) {
         NSDictionary *dict;
         if (error.code==-1001)
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
         if (block) {
             block(dict);
         }
     }];
}




-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+(void)checkSessionVerify:(void (^)(BOOL))resultBlock failure:(void (^)(NSError * error))failureBlock
{
    __block BOOL flag = NO;
    NSString *urlString  = [NSString stringWithFormat:@"%@/sjtyApi/app/checkSession", Host];
    [[HttpTool shareInstance] postWithSessionRequest:urlString parameters:nil success:^(id responseObject) {
        int code = [responseObject[@"status"] intValue];
        
        NSLog(@"Session =======%d", code);
        
        if(code == 201 || code == 200)
        {
            flag = YES;
            //            成功
            if(resultBlock)
            {
                resultBlock(flag);
            }
        }
        else
        {
            flag = NO;
            // 重进入登录界面
            if(resultBlock)
            {
                resultBlock(flag);
            }
        }
    } failure:^(NSError *error) {
#warning 错误处理的地方
        if(failureBlock)
        {
            failureBlock(error);
        }
        
    }];
    //没有失效
    //错误处理
}

+ (void)logoutSessionAction:(void(^)(BOOL))resultBlock  failure:(void (^)(NSError * error))failureBlock
{
    __block BOOL flag = NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@/sjtyApi/app/logout", Host];
    [[HttpTool shareInstance] postWithSessionRequest:urlStr parameters:nil success:^(id responseObject) {
        int code = [responseObject[@"status"] intValue];
        
        NSLog(@"Logout Session =======%d", code);
        
        if(code == 201 || code == 200)
        {
            flag = YES;
            //            成功
            if(resultBlock)
            {
                resultBlock(flag);
            }
        }
        else
        {
            flag = NO;
            // 重进入登录界面
            if(resultBlock)
            {
                resultBlock(flag);
            }
        }
    } failure:^(NSError *error) {
#warning 错误处理的地方
        //没有失效
        //错误处li
        
    }];
    
}

/**  修改的名字放到ClientUserInfo模型中的name字段*/
+ (void)modifyUserName:(NSString *)newName success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@/sjtyApi/app/clientUser/update",Host];
    
    [HttpTool uploadPUT:urlString parameters:@{@"clientUserInfo": @{@"name": newName}}success:^(id  _Nonnull response) {
        //修改成功
        if(success)
        {
            success(response);
        }
    } failure:^(NSError * _Nonnull error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

#pragma mark - 设置蓝牙模块的网络请求 Mac参数相关的URL
//设置蓝牙设备密码
-(void)devicePassword:(NSArray *)macArray Password:(NSString *)password Block:(void (^)(NSDictionary * dictionary))block{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/distributorMac/addBatch",Host];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<macArray.count; i++) {
        NSDictionary *dict=@{@"mac":macArray[i],
                             @"password":password
                             };
        [array addObject:dict];
    }
//    NSDictionary *dict=@{@"macPwds":array};
    
//    NSString *s=[self DataTOjsonString:dict];
    
    [self postWithSessionRequest:url parameters:array success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==200) {
           
            if (block) {
                block(responseObject);
            }
        }else{
            if (block) {
                block(responseObject);
            }
        }
    } failure:^(NSError *error) {
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
        if (block) {
            block(dict);
        }
    }];
}
-(void)checkPassword:(NSString *)mac Password:(NSString *)password Block:(void (^)(NSDictionary * _Nonnull))block{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/distributorMac/checkPwd",Host];
    NSMutableArray *array=[NSMutableArray array];
    NSDictionary *dicts=@{@"mac":mac,
                         @"password":password
                         };
    [array addObject:dicts];
//    NSDictionary *dict=@{@"macPwds":array};
    
    [self postWithSessionRequest:url parameters:array success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] ==200) {
            if (block ) {
                block(responseObject);
            }
        }else{
            if (block ) {
                block(responseObject);
            }
        }
    } failure:^(NSError *error) {
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
        if (block) {
            block(dict);
        }
    }];
}
-(void)getFogetDevicePasswordCode:(NSArray *)macArray Block:(void (^)(NSDictionary * _Nonnull))block{
    NSMutableString *macString=[NSMutableString string];
    
    for (int i=0; i<macArray.count; i++)
    {
        if (i==0) {
            [macString appendString:macArray[i]];
        }else{
            [macString appendString:[NSString stringWithFormat:@",%@",macArray[i]]];
        }
        
    }
    NSDictionary *dict=@{};
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/distributorMac/sendCode?macs=%@&language=en_US&simulation=1",Host,macString];
    
    [self postWithSessionRequest:url parameters:dict success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue]==200) {
            if (block) {
                NSDictionary *dic=@{@"status":[responseObject objectForKey:@"status"]};
                block(dic);
            }
        }else{
            
        }
    } failure:^(NSError *error) {
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
        if (block) {
            block(dict);
        }
    }];
}
-(void)forgetDevicePassword:(NSString *)code Password:(NSString *)password Block:(void (^)(NSDictionary * _Nonnull))block{
    NSDictionary *dict=@{};
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/distributorMac/updatePwd?code=%@&password=%@",Host,code,password];
    
    [self postWithSessionRequest:url parameters:dict success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue]==200) {
            if (block) {
                NSDictionary *dic=@{@"status":[responseObject objectForKey:@"status"]};
                block(dic);
            }
        }else{
            block(responseObject);
        }
    } failure:^(NSError *error) {
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
        if (block) {
            block(dict);
        }
    }];
}

#warning 用户信息模块
+ (void)currentUserInformationWithSessionAction:(void(^)(BOOL state, NSDictionary *data))resultBlock
{
    __block BOOL flag = NO;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/sjtyApi/app/clientUser/getSelfInfo", Host];
    [[HttpTool shareInstance] getRequest:urlStr
                              parameters:nil
                                 success:^(id responseObject) {
                                     //
                                     int code = [responseObject[@"status"] intValue];
                                     if(code == 201 || code == 200)
                                     {
                                         flag = YES;
                                         //            成功
                                         if(resultBlock)
                                         {
                                             resultBlock(flag, responseObject[@"data"]);
                                         }
                                     }
                                     else
                                     {
                                         flag = NO;
                                         // 重进入登录界面
                                         if(resultBlock)
                                         {
                                             resultBlock(flag, responseObject[@"data"]);
                                         }
                                     }
                                     NSLog(@"User Info Data = %@", responseObject[@"data"]);
                                     
                                     
                                 } failure:^(NSError *error) {
#warning  错误的处理方法
                                 }];
}
#pragma mark - PUT请求的多种可用方法
// SJTY可用的PUT 上传数据的方法
+ (void)PUT:(NSString *)URLString data:(NSData *)data parameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError * error))failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT"
                                                                                              URLString:URLString
                                                                                             parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (data) {
            [formData appendPartWithFileData:data name:@"file" fileName:@"userAvatar.png" mimeType:@"image/png"];
        }
    } error:nil];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil)
    {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    //        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (parameters && parameters.count > 0) {
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil]];
    }
    __block NSURLSessionDataTask *task;
    task = [manager uploadTaskWithStreamedRequest:request progress:NULL completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"UPLOAD success  ------%@", responseObject[@"code"]);
        if(success)
        {
            success(responseObject);
        }
    }];
    
    [task resume];
    //        __block NSURLSessionDataTask *task;
    //        task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    //        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    //
    //            if (!error) {
    //                NSLog(@"UPLOAD success  ------%@", responseObject[@"message"]);
    ////                [self requestSuccessWithSessionDataTask:task responseObject:responseObject success:success failure:failure];
    //            } else {
    ////                [self requestFailureWithSessionDataTask:task error:error failure:failure];
    //            }
    //        }];
    //        [task resume];
}

+ (void)changeAvatarImage:(UIImage *)userIcon params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObject))block failure:(void (^)(NSError *error)) failure
{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/clientUser/updatePortrait",Host];;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest * request=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:UIImagePNGRepresentation(userIcon) name:@"file" fileName:@"usericon.png" mimeType:@"image/png"];
        
    } error:nil];
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil) {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [request setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    __block NSURLSessionDataTask *task;
    task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
#warning responseObject可能为空
        if(response == nil) return;
        if (!error) {
            if ([[responseObject valueForKey:@"status"] integerValue]==200) {
                if(block){
                    NSDictionary *dict=@{@"status":[responseObject valueForKey:@"status"],
                                         @"message":@"上传成功"
                                         };
                    block(dict);
                }
            }else{
                if(block){
                    NSDictionary *dict=@{@"status":[responseObject valueForKey:@"status"],
                                         @"message":@"上传失败"
                                         };
                    block(dict);
                }
            }
        }else if(error && response != nil){
            if(block){
                 NSDictionary *dict=@{@"status":[responseObject valueForKey:@"status"],
                                     @"message":@"上传失败"
                                     };
                block(dict);
            }
        }
    }];
    [task resume];
}


/**
 带有Session的PUT文件方式
 */
+ (void)uploadFile_SessionWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    // AFNetWorking
    // 创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",nil];
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil)
    {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    
    // 发送请求
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull allFormData) {
        for (HTTPFormData *formData in formDataArray) {
            [allFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
        //
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 上传进度
        //[SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"Uploading"];
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            NSLog(@"upload file--%@", responseObject);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            failure(error);
        }
    }];
    
}
+ (void)uploadPUT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;
{
    // 创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",nil];
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil)
    {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送了PUT请求-----%@", responseObject[@"message"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)uploadFileUseRESTWithURLString:(NSString *)URLString rename:(NSString *)rename fromFile:(NSURL *)fileURL orFromData:(NSData *)data progress:(NSProgress * __autoreleasing *)progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",nil];
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]!=nil)
    {
        NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SessionID"]];
        [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (data) {
            [formData appendPartWithFileData:data name:@"file" fileName:@"img" mimeType:@"image/jpeg"];
        }
    } error:nil];
    
    //NSString *urlStringPath = [urlString stringByAppendingPathComponent:rename];
    request.HTTPMethod = @"PUT";
    // 身份验证 BASIC 方式
//    NSString *usernameAndPassword = @"admin:123456";
//    NSData *data = [usernameAndPassword dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *authString = [@"BASIC " stringByAppendingString:[data base64EncodedStringWithOptions:0]];
//    [request setValue:authString forHTTPHeaderField:@"Authorization"];
    void (^completionBlock)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(responseObject);
            }
            
        }
    };
    if (fileURL) {
        [manager uploadTaskWithRequest:request fromFile:fileURL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            //completionBlock(responseObject, error);
        }];
        return;
    }
//    if (data) {
//        [manager uploadTaskWithRequest:request fromData:bodyData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//            //completionBlock(responseObject, error);
//        }];
//    }
    return;
}

#pragma mark - UPS应急电源网络接口
// 获得消息列表的消息
+ (void)getUpsMessageListWithStatus:(int)unread Success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSString *message)) failure;
{
    
    NSString *urlString =[NSString stringWithFormat:@"%@/sjtyApi/app/message/getList",Host];
    //默认获得10条数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"limit"] = @(10);
    if(unread == 1 ||unread == 0) param[@"status"] = @(unread);
    
    
    [[HttpTool shareInstance] getRequest:urlString parameters:param success:^(id responseObject) {
        NSLog(@"获取消息列表---%@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        NSString *message;
        if (error.code==-1001)
        {
            message = TIMEOUT;
        }
        else if (error.code==-1009)
        {
            message = NONETWORK;
        }
        else
        {
            message = ERROR;
        }
        if (failure)
        {
            failure(error, message);
        }
        
    }];
}


+ (void)getUpsMessageListWithLimited:(int)count newOrOld:(NewOrOld)flag startTime:(NSString *)dateStr Success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSString *message)) failure
{
    NSString *urlString =[NSString stringWithFormat:@"%@/sjtyApi/app/message/getList",Host];
//    NSDateFormatter *formatter
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"limit"] = @(10);
    param[@"getNew"] = @(flag);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *sss = [formatter dateFromString:dateStr];
    //去掉时间的updateTime字符串
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *updateTimeString = [formatter stringFromDate:sss];
    
    
#warning 修改为年月日
    if(updateTimeString.length) param[@"updateTime"] = updateTimeString;
    [[HttpTool shareInstance] getRequest:urlString parameters:param success:^(id responseObject) {
        NSLog(@"获取消息列表---%@---%@", responseObject[@"message"], responseObject);
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        NSString *message;
        if (error.code==-1001)
        {
            message = TIMEOUT;
        }
        else if (error.code==-1009)
        {
            message = NONETWORK;
        }
        else
        {
            message = ERROR;
        }
        if (failure)
        {
            failure(error, message);
        }
        
    }];
}


+ (void)upsDeleteWidthMessageModelID:(NSArray *)modelIDs success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSDictionary *message)) failure
{
    NSString *urlString =[NSString stringWithFormat:@"http://app.f-union.com/sjtyApi/app/message/delBatch"];
    
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

// 上传头像的数据信息
+ (void)uploadIconImage:(UIImage *)image success:(void (^)(id response))success failure:(void (^)(NSError * error))failure
{
    NSString *url=[NSString stringWithFormat:@"%@/sjtyApi/app/clientUser/updatePortrait",Host];
    [HttpTool PUT:url data:UIImagePNGRepresentation(image) parameters:nil success:^(id  _Nonnull response) {
        if(success)
        {
            success(response);
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}


// 获得当前服务器中存储的数据信息
@end

@implementation HTTPFormData
+ (HTTPFormData *)instanceWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mineType:(NSString *)mineType
{
    HTTPFormData *formData = [[HTTPFormData alloc] init];
    formData.data = data;
    formData.name = name;
    formData.filename = fileName;
    formData.mimeType = mineType;
    return formData;
}
@end
