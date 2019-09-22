#import <UIKit/UIKit.h>
///sjtyApi/app/loginWithTripartite
// 第三方登录,注意查看WebAPI底部的Models中ClientUserLoginVo的说明
@interface ClientUserInfo : NSObject
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, assign) NSInteger channelId;
@property (nonatomic, assign) NSInteger childNum;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * contactKey;
@property (nonatomic, strong) NSString * extJson;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger isLogin;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * skin;

/** 第三方登录的Key*/
@property (nonatomic, strong) NSString * tripartiteLoginKey;
/** 第三方登录的类型 Facebook*/
@property (nonatomic, strong) NSString * tripartiteLoginType;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, assign) NSInteger weight;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
