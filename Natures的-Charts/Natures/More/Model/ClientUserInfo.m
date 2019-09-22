#import "ClientUserInfo.h"
NSString *const kClientUserInfoAddress = @"address";
NSString *const kClientUserInfoAge = @"age";
NSString *const kClientUserInfoBirthday = @"birthday";
NSString *const kClientUserInfoChannelId = @"channelId";
NSString *const kClientUserInfoChildNum = @"childNum";
NSString *const kClientUserInfoCode = @"code";
NSString *const kClientUserInfoContactKey = @"contactKey";
NSString *const kClientUserInfoExtJson = @"extJson";
NSString *const kClientUserInfoHeight = @"height";
NSString *const kClientUserInfoIsLogin = @"isLogin";
NSString *const kClientUserInfoName = @"name";
NSString *const kClientUserInfoPassword = @"password";
NSString *const kClientUserInfoPhone = @"phone";
NSString *const kClientUserInfoProductId = @"productId";
NSString *const kClientUserInfoSex = @"sex";
NSString *const kClientUserInfoSkin = @"skin";
NSString *const kClientUserInfoTripartiteLoginKey = @"tripartiteLoginKey";
NSString *const kClientUserInfoTripartiteLoginType = @"tripartiteLoginType";
NSString *const kClientUserInfoUserName = @"name";
NSString *const kClientUserInfoWeight = @"weight";

@interface ClientUserInfo ()
@end
@implementation ClientUserInfo
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kClientUserInfoAddress] isKindOfClass:[NSNull class]])
    {
        self.address = dictionary[kClientUserInfoAddress];
    }
    if(![dictionary[kClientUserInfoAge] isKindOfClass:[NSNull class]]){
        self.age = [dictionary[kClientUserInfoAge] integerValue];
    }
    
    if(![dictionary[kClientUserInfoBirthday] isKindOfClass:[NSNull class]]){
        self.birthday = dictionary[kClientUserInfoBirthday];
    }
    if(![dictionary[kClientUserInfoChannelId] isKindOfClass:[NSNull class]]){
        self.channelId = [dictionary[kClientUserInfoChannelId] integerValue];
    }
    
    if(![dictionary[kClientUserInfoChildNum] isKindOfClass:[NSNull class]]){
        self.childNum = [dictionary[kClientUserInfoChildNum] integerValue];
    }
    
    if(![dictionary[kClientUserInfoCode] isKindOfClass:[NSNull class]]){
        self.code = dictionary[kClientUserInfoCode];
    }
    if(![dictionary[kClientUserInfoContactKey] isKindOfClass:[NSNull class]]){
        self.contactKey = dictionary[kClientUserInfoContactKey];
    }
    if(![dictionary[kClientUserInfoExtJson] isKindOfClass:[NSNull class]]){
        self.extJson = dictionary[kClientUserInfoExtJson];
    }
    if(![dictionary[kClientUserInfoHeight] isKindOfClass:[NSNull class]]){
        self.height = [dictionary[kClientUserInfoHeight] integerValue];
    }
    
    if(![dictionary[kClientUserInfoIsLogin] isKindOfClass:[NSNull class]]){
        self.isLogin = [dictionary[kClientUserInfoIsLogin] integerValue];
    }
    
    if(![dictionary[kClientUserInfoName] isKindOfClass:[NSNull class]]){
        self.name = dictionary[kClientUserInfoName];
    }
    if(![dictionary[kClientUserInfoPassword] isKindOfClass:[NSNull class]]){
        self.password = dictionary[kClientUserInfoPassword];
    }
    if(![dictionary[kClientUserInfoPhone] isKindOfClass:[NSNull class]]){
        self.phone = dictionary[kClientUserInfoPhone];
    }
    if(![dictionary[kClientUserInfoProductId] isKindOfClass:[NSNull class]]){
        self.productId = [dictionary[kClientUserInfoProductId] integerValue];
    }
    
    if(![dictionary[kClientUserInfoSex] isKindOfClass:[NSNull class]]){
        self.sex = [dictionary[kClientUserInfoSex] integerValue];
    }
    
    if(![dictionary[kClientUserInfoSkin] isKindOfClass:[NSNull class]]){
        self.skin = dictionary[kClientUserInfoSkin];
    }
    if(![dictionary[kClientUserInfoTripartiteLoginKey] isKindOfClass:[NSNull class]]){
        self.tripartiteLoginKey = dictionary[kClientUserInfoTripartiteLoginKey];
    }
    if(![dictionary[kClientUserInfoTripartiteLoginType] isKindOfClass:[NSNull class]]){
        self.tripartiteLoginType = dictionary[kClientUserInfoTripartiteLoginType];
    }
    if(![dictionary[kClientUserInfoUserName] isKindOfClass:[NSNull class]]){
        self.userName = dictionary[kClientUserInfoUserName];
    }
    if(![dictionary[kClientUserInfoWeight] isKindOfClass:[NSNull class]]){
        self.weight = [dictionary[kClientUserInfoWeight] integerValue];
    }
    
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.address != nil){
        dictionary[kClientUserInfoAddress] = self.address;
    }
    dictionary[kClientUserInfoAge] = @(self.age);
    if(self.birthday != nil){
        dictionary[kClientUserInfoBirthday] = self.birthday;
    }
    dictionary[kClientUserInfoChannelId] = @(self.channelId);
    dictionary[kClientUserInfoChildNum] = @(self.childNum);
    if(self.code != nil){
        dictionary[kClientUserInfoCode] = self.code;
    }
    if(self.contactKey != nil){
        dictionary[kClientUserInfoContactKey] = self.contactKey;
    }
    if(self.extJson != nil){
        dictionary[kClientUserInfoExtJson] = self.extJson;
    }
    dictionary[kClientUserInfoHeight] = @(self.height);
    dictionary[kClientUserInfoIsLogin] = @(self.isLogin);
    if(self.name != nil){
        dictionary[kClientUserInfoName] = self.name;
    }
    if(self.password != nil){
        dictionary[kClientUserInfoPassword] = self.password;
    }
    if(self.phone != nil){
        dictionary[kClientUserInfoPhone] = self.phone;
    }
    dictionary[kClientUserInfoProductId] = @(self.productId);
    dictionary[kClientUserInfoSex] = @(self.sex);
    if(self.skin != nil){
        dictionary[kClientUserInfoSkin] = self.skin;
    }
    if(self.tripartiteLoginKey != nil){
        dictionary[kClientUserInfoTripartiteLoginKey] = self.tripartiteLoginKey;
    }
    if(self.tripartiteLoginType != nil){
        dictionary[kClientUserInfoTripartiteLoginType] = self.tripartiteLoginType;
    }
    if(self.userName != nil){
        dictionary[kClientUserInfoUserName] = self.userName;
    }
    dictionary[kClientUserInfoWeight] = @(self.weight);
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.address != nil){
        [aCoder encodeObject:self.address forKey:kClientUserInfoAddress];
    }
    [aCoder encodeObject:@(self.age) forKey:kClientUserInfoAge];
    if(self.birthday != nil){
        [aCoder encodeObject:self.birthday forKey:kClientUserInfoBirthday];
    }
    [aCoder encodeObject:@(self.channelId) forKey:kClientUserInfoChannelId];
    [aCoder encodeObject:@(self.childNum) forKey:kClientUserInfoChildNum];
    
    if(self.code != nil){
        [aCoder encodeObject:self.code forKey:kClientUserInfoCode];
    }
    if(self.contactKey != nil){
        [aCoder encodeObject:self.contactKey forKey:kClientUserInfoContactKey];
    }
    if(self.extJson != nil){
        [aCoder encodeObject:self.extJson forKey:kClientUserInfoExtJson];
    }
    [aCoder encodeObject:@(self.height) forKey:kClientUserInfoHeight];
    [aCoder encodeObject:@(self.isLogin) forKey:kClientUserInfoIsLogin];
    
    if(self.name != nil){
        [aCoder encodeObject:self.name forKey:kClientUserInfoName];
    }
    if(self.password != nil){
        [aCoder encodeObject:self.password forKey:kClientUserInfoPassword];
    }
    if(self.phone != nil){
        [aCoder encodeObject:self.phone forKey:kClientUserInfoPhone];
    }
    [aCoder encodeObject:@(self.productId) forKey:kClientUserInfoProductId];
    [aCoder encodeObject:@(self.sex) forKey:kClientUserInfoSex];    if(self.skin != nil){
        [aCoder encodeObject:self.skin forKey:kClientUserInfoSkin];
    }
    if(self.tripartiteLoginKey != nil){
        [aCoder encodeObject:self.tripartiteLoginKey forKey:kClientUserInfoTripartiteLoginKey];
    }
    if(self.tripartiteLoginType != nil){
        [aCoder encodeObject:self.tripartiteLoginType forKey:kClientUserInfoTripartiteLoginType];
    }
    if(self.userName != nil){
        [aCoder encodeObject:self.userName forKey:kClientUserInfoUserName];
    }
    [aCoder encodeObject:@(self.weight) forKey:kClientUserInfoWeight];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.address = [aDecoder decodeObjectForKey:kClientUserInfoAddress];
    self.age = [[aDecoder decodeObjectForKey:kClientUserInfoAge] integerValue];
    self.birthday = [aDecoder decodeObjectForKey:kClientUserInfoBirthday];
    self.channelId = [[aDecoder decodeObjectForKey:kClientUserInfoChannelId] integerValue];
    self.childNum = [[aDecoder decodeObjectForKey:kClientUserInfoChildNum] integerValue];
    self.code = [aDecoder decodeObjectForKey:kClientUserInfoCode];
    self.contactKey = [aDecoder decodeObjectForKey:kClientUserInfoContactKey];
    self.extJson = [aDecoder decodeObjectForKey:kClientUserInfoExtJson];
    self.height = [[aDecoder decodeObjectForKey:kClientUserInfoHeight] integerValue];
    self.isLogin = [[aDecoder decodeObjectForKey:kClientUserInfoIsLogin] integerValue];
    self.name = [aDecoder decodeObjectForKey:kClientUserInfoName];
    self.password = [aDecoder decodeObjectForKey:kClientUserInfoPassword];
    self.phone = [aDecoder decodeObjectForKey:kClientUserInfoPhone];
    self.productId = [[aDecoder decodeObjectForKey:kClientUserInfoProductId] integerValue];
    self.sex = [[aDecoder decodeObjectForKey:kClientUserInfoSex] integerValue];
    self.skin = [aDecoder decodeObjectForKey:kClientUserInfoSkin];
    self.tripartiteLoginKey = [aDecoder decodeObjectForKey:kClientUserInfoTripartiteLoginKey];
    self.tripartiteLoginType = [aDecoder decodeObjectForKey:kClientUserInfoTripartiteLoginType];
    self.userName = [aDecoder decodeObjectForKey:kClientUserInfoUserName];
    self.weight = [[aDecoder decodeObjectForKey:kClientUserInfoWeight] integerValue];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    ClientUserInfo *copy = [ClientUserInfo new];
    copy.address = [self.address copy];
    copy.age = self.age;
    copy.birthday = [self.birthday copy];
    copy.channelId = self.channelId;
    copy.childNum = self.childNum;
    copy.code = [self.code copy];
    copy.contactKey = [self.contactKey copy];
    copy.extJson = [self.extJson copy];
    copy.height = self.height;
    copy.isLogin = self.isLogin;
    copy.name = [self.name copy];
    copy.password = [self.password copy];
    copy.phone = [self.phone copy];
    copy.productId = self.productId;
    copy.sex = self.sex;
    copy.skin = [self.skin copy];
    copy.tripartiteLoginKey = [self.tripartiteLoginKey copy];
    copy.tripartiteLoginType = [self.tripartiteLoginType copy];
    copy.userName = [self.userName copy];
    copy.weight = self.weight;
    
    return copy;
}
@end
