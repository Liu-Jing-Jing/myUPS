//
//  MessageModel.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/12.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MessageModel.h"

NSString *const kMessageModelContent = @"content";
NSString *const kMessageModelCreateTime = @"createTime";
NSString *const kMessageModelDel = @"del";
NSString *const kMessageModelIcon = @"icon";
//NSString *const kMessageModelIdField = @"id";
NSString *const kMessageModelProductId = @"id";
NSString *const kMessageModelStatus = @"status";
NSString *const kMessageModelSummary = @"summary";
NSString *const kMessageModelTitle = @"title";
NSString *const kMessageModelUpdateTime = @"updateTime";
NSString *const kMessageModelUserId = @"userId";

@implementation MessageModel
- (instancetype)initWithTitle:(NSString *)title andSubTitle:(NSString *)subtitle isUnreaded:(BOOL)unread
{
    self = [super init];
    if (self) {
        self.title = title;
        //self.unread = unread;
    }
    return self;
}
- (void)setMessageReaded
{
    self.icon = @(0);
}


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(![dictionary isKindOfClass:[NSDictionary class]]) return [MessageModel new];
    self = [super init];
    if(![dictionary[kMessageModelContent] isKindOfClass:[NSNull class]]){
        self.content = dictionary[kMessageModelContent];
    }
    if(![dictionary[kMessageModelCreateTime] isKindOfClass:[NSNull class]]){
        self.createTime = dictionary[kMessageModelCreateTime];
    }
    
    if(![dictionary[kMessageModelIcon] isKindOfClass:[NSNull class]]){
        self.icon = dictionary[kMessageModelIcon];
    }
    
    if(![dictionary[kMessageModelProductId] isKindOfClass:[NSNull class]]){
        self.messageID = dictionary[kMessageModelProductId];
    }
    
    if(![dictionary[kMessageModelStatus] isKindOfClass:[NSNull class]]){
        self.status = dictionary[kMessageModelStatus];
    }
    
    if(![dictionary[kMessageModelSummary] isKindOfClass:[NSNull class]]){
        self.summary = dictionary[kMessageModelSummary];
    }
    if(![dictionary[kMessageModelTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kMessageModelTitle];
    }
    
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.content != nil){
        dictionary[kMessageModelContent] = self.content;
    }
    if(self.createTime != nil){
        dictionary[kMessageModelCreateTime] = self.createTime;
    }
    dictionary[kMessageModelIcon] = self.icon;
    dictionary[kMessageModelProductId] = self.messageID;
    dictionary[kMessageModelStatus] = self.status;
    if(self.summary != nil)
    {
        dictionary[kMessageModelSummary] = self.summary;
    }
    if(self.title != nil)
    {
        dictionary[kMessageModelTitle] = self.title;
    }
    return dictionary;
    
}
@end
