//
//  UnsyncUPSModel.h
//  Natures
//
//  Created by 柏霖尹 on 2019/9/15.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UnsyncUPSModel : JKDBModel
@property (nonatomic, strong) NSString *historyString;
@end

NS_ASSUME_NONNULL_END
