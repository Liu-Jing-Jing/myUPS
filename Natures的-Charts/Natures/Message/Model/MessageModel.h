//
//  MessageModel.h
//  Natures
//
//  Created by 柏霖尹 on 2019/8/12.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"
#import "JKDBModel.h"
NS_ASSUME_NONNULL_BEGIN
#define MESSAGE_READED @(0)
#define MESSAGE_UNREADED @(1)
@interface MessageModel : JKDBModel
//@property (nonatomic, assign) BOOL unread;
//@property (nonatomic, copy) NSString *titles;
//@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) NSNumber *  status;
@property (nonatomic, assign) NSNumber *  icon;

@property (nonatomic, copy) NSString * messageID;
/** 把Mac地址保存在这个字段*/
@property (nonatomic, copy)   NSString * mac;
@property (nonatomic, copy) NSString * summary;
@property (nonatomic, assign) NSNumber * userId;
-(NSDictionary *)toDictionary;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)setMessageReaded;
- (instancetype)initWithTitle:(NSString *)title andSubTitle:(NSString *)subtitle isUnreaded:(BOOL)unread;
@end

NS_ASSUME_NONNULL_END
