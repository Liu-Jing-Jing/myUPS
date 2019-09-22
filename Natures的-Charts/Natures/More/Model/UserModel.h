#import <UIKit/UIKit.h>
#import "ClientUserInfo.h"
@interface UserModel : NSObject

@property (nonatomic, strong) ClientUserInfo * clientUserInfo;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) BOOL del;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * phone;

/* Avatar Image*/
@property (nonatomic, strong) NSString * portrait;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString * salt;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * tripartiteLoginKey;
@property (nonatomic, strong) NSString * tripartiteLoginType;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * username;

+ (instancetype)userModelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;
@end
