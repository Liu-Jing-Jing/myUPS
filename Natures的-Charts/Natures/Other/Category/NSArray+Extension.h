//
//  NSArray+Extension.h
//  EMS
//
//  Created by 柏霖尹 on 2019/6/27.
//  Copyright © 2019 work. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Extension)
+ (instancetype)getProperties:(Class)cls;
+ (instancetype)createNewArrayWithSize:(int)length sameValues:(id)obj;
@end

NS_ASSUME_NONNULL_END
