//
//  HttpTool.h
//  junhua
//
//  Created by sjty on 2019/7/24.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    NewMessage = 0,
    OldMessage = 1
}NewOrOld;
#define Host @"http://app.f-union.com"//@"http://sjtyservice.shfch.net" //http://app.f-union.com/
#define TIMEOUT @"Request timed out, please try again later"
#define NONETWORK  @"No network, please check the network"
#define ERROR @"Request failed, try again later"
#define SUCCESS @"Success request!"
#define PRODUCTID @"1147401843442315265"
#define FileHost @"http://app.shfch.net/webFile/file/"
NS_ASSUME_NONNULL_BEGIN
@interface HttpTool : NSObject
+(instancetype)shareInstance;


#pragma - mark 通用接口
/**Current 验证Session是否过期*/
+(void)checkSessionVerify:(void (^)(BOOL))resultBlock failure:(void (^)(NSError * error))failureBlock;
// 注销当前登陆的用户
+ (void)logoutSessionAction:(void(^)(BOOL))resultBlock failure:(void (^)(NSError * error))failureBlock;
-(void)login:(NSString *)email Password:(NSString *)password Block:(void(^)(NSDictionary *  dictionary)) block;

-(void)getCode:(NSString *)email Block:(void(^)(NSDictionary * dictionary)) block;

/* 新的注册接口,可以提示用户是否存在*/
-(void)registerNewuser:(NSString *)email withName:(NSString *)firstAndLastName Password:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * dictionary))block;
-(void)registerUser:(NSString *)email withName:(NSString *)firstAndLastName Password:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * dictionary))block;

/**  修改的名字放到ClientUserInfo模型中的name字段*/
+ (void)modifyUserName:(NSString *)newName success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure;


/**
 通用的POST 请求方法

 @param URLString 请求路径
 @param parameters 请求参数
 @param success 成功的Block
 @param failure 失败的Block
 */
-(void)postRequest:(NSString *)URLString  parameters:(id)parameters success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure;


/**
 带有Session的的POST 请求方法
 
 @param URLString 请求路径
 @param parameters 请求参数
 @param success 成功的Block
 @param failure 失败的Block
 */
-(void)postWithSessionRequest:(NSString *)URLString  parameters:(id)parameters success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure;
/**
 通用的GET 请求方法
 
 @param URLString 请求路径
 @param parameters 请求参数
 @param success 成功的Block
 @param failure 失败的Block
 */
-(void)getRequest:(NSString *)URLString  parameters:(NSDictionary *)parameters success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure;
/**
 用户的注册和登录
 @param email 1
 @param firstAndLastName 拼接号的名字
 @param password 密码
 @param code 验证码
 @param block 返回结果的回调
 */
-(void)registerUser:(NSString *)email withName:(NSString *)firstAndLastName Password:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * dictionary))block;
-(void)devicePassword:(NSArray *)macArray Password:(NSString *)password Block:(void(^)(NSDictionary * dictionary)) block;



/**
 忘记设备的密码
 @param macArray Mac列表里的数据
 @param block 成功的毁掉
 */
- (void)getFogetDevicePasswordCode:(NSArray *)macArray Block:(void(^)(NSDictionary * dictionary)) block;
- (void)forgetDevicePassword:(NSString *)code Password:(NSString *)password Block:(void(^)(NSDictionary * dictionary)) block;
- (void)checkPassword:(NSString *)mac Password:(NSString *)password Block:(void(^)(NSDictionary * dictionary)) block;
- (void)changePasswordUsingEmail:(NSString *)email newPassword:(NSString *)password Code:(NSString *)code Block:(void (^)(NSDictionary * _Nonnull))block;


//+ (void)facebookLoginWithParam:(NSDictionary *)result; //http://app.shfch.net/sjtyApi/app/loginWithTripartite
// 第三方登录Facebook的 具体参数
+ (void)facebookLoginWithParam:(NSDictionary *)params success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error)) failure;
+ (void)currentUserInformationWithSessionAction:(void(^)(BOOL state, NSDictionary *data))resultBlock;
+ (void)uploadFile_SessionWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;

/* 这个是Put上传图片的方法*/
+ (void)PUT:(NSString *)URLString data:(NSData *)data parameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;
+ (void)uploadPUT:(NSString *)URLString data:(NSData *)data parameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;


/**
 修改用户头像的 PUT请求方式

 @param userIcon image对象
 @param params 附加参数
 @param block 成功回调的Block
 */
+ (void)changeAvatarImage:(UIImage *)userIcon params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObject))block failure:(void (^)(NSError *error)) failure;
+ (void)uploadIconImage:(UIImage *)image success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;
+ (void)uploadPUT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError * error))failure;

/**
 获得消息列表 获得未读传0 已读传1 被删除
 
 @param unread 未读的status默认是0
 @param success 成功数据
 @param failure 失败的
 */
+ (void)getUpsMessageListWithStatus:(int)unread Success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSString *message)) failure;

+ (void)getUpsMessageListWithLimited:(int)count newOrOld:(NewOrOld)flag startTime:(NSString *)dateStr Success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSString *message)) failure;
+ (void)upsDeleteWidthMessageModelID:(NSArray *)modelIDs success:(void (^)(id responseObject)) success failure:(void (^)(NSError *error, NSDictionary *message)) failure;

@end

/**
 *  用来封装文件数据的模型
 */
@interface HTTPFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
+ (HTTPFormData *)instanceWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mineType:(NSString *)mineType;
@end
NS_ASSUME_NONNULL_END
