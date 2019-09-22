#import "UserModel.h"
#define FileHost @""//@"http://app.shfch.net/webFile/file/"
NSString *const kRootClassClientUserInfo = @"clientUserInfo";
NSString *const kRootClassCreateTime = @"createTime";
NSString *const kRootClassDel = @"del";
NSString *const kRootClassEmail = @"email";
NSString *const kRootClassIdField = @"id";
NSString *const kRootClassPassword = @"password";
NSString *const kRootClassPhone = @"phone";
NSString *const kRootClassPortrait = @"portrait";
NSString *const kRootClassProductId = @"productId";
NSString *const kRootClassSalt = @"salt";
NSString *const kRootClassSex = @"sex";
NSString *const kRootClassTripartiteLoginKey = @"tripartiteLoginKey";
NSString *const kRootClassTripartiteLoginType = @"tripartiteLoginType";
NSString *const kRootClassUpdateTime = @"updateTime";
NSString *const kRootClassUsername = @"name";

@interface UserModel()
@end

@implementation UserModel
+ (instancetype)userModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}
/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kRootClassClientUserInfo] isKindOfClass:[NSNull class]]){
		self.clientUserInfo = [[ClientUserInfo alloc] initWithDictionary:dictionary[kRootClassClientUserInfo]];
	}

	if(![dictionary[kRootClassCreateTime] isKindOfClass:[NSNull class]]){
		self.createTime = dictionary[kRootClassCreateTime];
	}	
	if(![dictionary[kRootClassDel] isKindOfClass:[NSNull class]]){
		self.del = [dictionary[kRootClassDel] boolValue];
	}

	if(![dictionary[kRootClassEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kRootClassEmail];
	}	
	if(![dictionary[kRootClassIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kRootClassIdField] integerValue];
	}

	if(![dictionary[kRootClassPassword] isKindOfClass:[NSNull class]]){
		self.password = dictionary[kRootClassPassword];
	}	
	if(![dictionary[kRootClassPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kRootClassPhone];
	}	
	if(![dictionary[kRootClassPortrait] isKindOfClass:[NSNull class]]){
		self.portrait = [NSString stringWithFormat:@"%@%@", FileHost, dictionary[kRootClassPortrait]];
	}	
	if(![dictionary[kRootClassProductId] isKindOfClass:[NSNull class]]){
		self.productId = [dictionary[kRootClassProductId] integerValue];
	}

	if(![dictionary[kRootClassSalt] isKindOfClass:[NSNull class]]){
		self.salt = dictionary[kRootClassSalt];
	}	
	if(![dictionary[kRootClassSex] isKindOfClass:[NSNull class]]){
		self.sex = [dictionary[kRootClassSex] integerValue];
	}

	if(![dictionary[kRootClassTripartiteLoginKey] isKindOfClass:[NSNull class]]){
		self.tripartiteLoginKey = dictionary[kRootClassTripartiteLoginKey];
	}	
	if(![dictionary[kRootClassTripartiteLoginType] isKindOfClass:[NSNull class]]){
		self.tripartiteLoginType = dictionary[kRootClassTripartiteLoginType];
	}	
	if(![dictionary[kRootClassUpdateTime] isKindOfClass:[NSNull class]]){
		self.updateTime = dictionary[kRootClassUpdateTime];
	}	
	if(![dictionary[kRootClassUsername] isKindOfClass:[NSNull class]]){
		self.username = dictionary[kRootClassUsername];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.clientUserInfo != nil){
		dictionary[kRootClassClientUserInfo] = [self.clientUserInfo toDictionary];
	}
	if(self.createTime != nil){
		dictionary[kRootClassCreateTime] = self.createTime;
	}
	dictionary[kRootClassDel] = @(self.del);
	if(self.email != nil){
		dictionary[kRootClassEmail] = self.email;
	}
	dictionary[kRootClassIdField] = @(self.idField);
	if(self.password != nil){
		dictionary[kRootClassPassword] = self.password;
	}
	if(self.phone != nil){
		dictionary[kRootClassPhone] = self.phone;
	}
	if(self.portrait != nil){
		dictionary[kRootClassPortrait] = self.portrait;
	}
	dictionary[kRootClassProductId] = @(self.productId);
	if(self.salt != nil){
		dictionary[kRootClassSalt] = self.salt;
	}
	dictionary[kRootClassSex] = @(self.sex);
	if(self.tripartiteLoginKey != nil){
		dictionary[kRootClassTripartiteLoginKey] = self.tripartiteLoginKey;
	}
	if(self.tripartiteLoginType != nil){
		dictionary[kRootClassTripartiteLoginType] = self.tripartiteLoginType;
	}
	if(self.updateTime != nil){
		dictionary[kRootClassUpdateTime] = self.updateTime;
	}
	if(self.username != nil){
		dictionary[kRootClassUsername] = self.username;
	}
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
	if(self.clientUserInfo != nil){
		[aCoder encodeObject:self.clientUserInfo forKey:kRootClassClientUserInfo];
	}
	if(self.createTime != nil){
		[aCoder encodeObject:self.createTime forKey:kRootClassCreateTime];
	}
	[aCoder encodeObject:@(self.del) forKey:kRootClassDel];	if(self.email != nil){
		[aCoder encodeObject:self.email forKey:kRootClassEmail];
	}
	[aCoder encodeObject:@(self.idField) forKey:kRootClassIdField];	if(self.password != nil){
		[aCoder encodeObject:self.password forKey:kRootClassPassword];
	}
	if(self.phone != nil){
		[aCoder encodeObject:self.phone forKey:kRootClassPhone];
	}
	if(self.portrait != nil){
		[aCoder encodeObject:self.portrait forKey:kRootClassPortrait];
	}
	[aCoder encodeObject:@(self.productId) forKey:kRootClassProductId];	if(self.salt != nil){
		[aCoder encodeObject:self.salt forKey:kRootClassSalt];
	}
	[aCoder encodeObject:@(self.sex) forKey:kRootClassSex];	if(self.tripartiteLoginKey != nil){
		[aCoder encodeObject:self.tripartiteLoginKey forKey:kRootClassTripartiteLoginKey];
	}
	if(self.tripartiteLoginType != nil){
		[aCoder encodeObject:self.tripartiteLoginType forKey:kRootClassTripartiteLoginType];
	}
	if(self.updateTime != nil){
		[aCoder encodeObject:self.updateTime forKey:kRootClassUpdateTime];
	}
	if(self.username != nil){
		[aCoder encodeObject:self.username forKey:kRootClassUsername];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.clientUserInfo = [aDecoder decodeObjectForKey:kRootClassClientUserInfo];
	self.createTime = [aDecoder decodeObjectForKey:kRootClassCreateTime];
	self.del = [[aDecoder decodeObjectForKey:kRootClassDel] boolValue];
	self.email = [aDecoder decodeObjectForKey:kRootClassEmail];
	self.idField = [[aDecoder decodeObjectForKey:kRootClassIdField] integerValue];
	self.password = [aDecoder decodeObjectForKey:kRootClassPassword];
	self.phone = [aDecoder decodeObjectForKey:kRootClassPhone];
	self.portrait = [aDecoder decodeObjectForKey:kRootClassPortrait];
	self.productId = [[aDecoder decodeObjectForKey:kRootClassProductId] integerValue];
	self.salt = [aDecoder decodeObjectForKey:kRootClassSalt];
	self.sex = [[aDecoder decodeObjectForKey:kRootClassSex] integerValue];
	self.tripartiteLoginKey = [aDecoder decodeObjectForKey:kRootClassTripartiteLoginKey];
	self.tripartiteLoginType = [aDecoder decodeObjectForKey:kRootClassTripartiteLoginType];
	self.updateTime = [aDecoder decodeObjectForKey:kRootClassUpdateTime];
	self.username = [aDecoder decodeObjectForKey:kRootClassUsername];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	UserModel *copy = [UserModel new];

	copy.clientUserInfo = [self.clientUserInfo copy];
	copy.createTime = [self.createTime copy];
	copy.del = self.del;
	copy.email = [self.email copy];
	copy.idField = self.idField;
	copy.password = [self.password copy];
	copy.phone = [self.phone copy];
	copy.portrait = [self.portrait copy];
	copy.productId = self.productId;
	copy.salt = [self.salt copy];
	copy.sex = self.sex;
	copy.tripartiteLoginKey = [self.tripartiteLoginKey copy];
	copy.tripartiteLoginType = [self.tripartiteLoginType copy];
	copy.updateTime = [self.updateTime copy];
	copy.username = [self.username copy];

	return copy;
}
@end
