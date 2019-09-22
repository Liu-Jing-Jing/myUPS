//
//  HomeLoginViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/27.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeLoginViewController : BaseViewController
@property (nonatomic, copy) void(^CancelLgoinAction)(void);
@property (nonatomic, assign, getter=isCleanPWD) BOOL cleanPWD;
@end

NS_ASSUME_NONNULL_END
