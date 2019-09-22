//
//  SignupFormViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/23.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SignupFormViewController : BaseViewController
@property (nonatomic, copy) void(^showButtons)(void);
@end

NS_ASSUME_NONNULL_END
