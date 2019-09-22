//
//  ParserDataTool.h
//  Natures
//
//  Created by 柏霖尹 on 2019/8/16.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UpsModel;
@interface ParserDataTool : NSObject
+ (UpsModel *)parseData:(Byte *)byte;
@end

NS_ASSUME_NONNULL_END
