//
//  AccountViewController.h
//  UPS
//
//  Created by Mark on 2019/8/4.
//  Copyright © 2019年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTULocationManager.h"
#import "BaseViewController.h"
#import "UserModel.h"
@interface AccountViewController : BaseViewController

@property (nonatomic, strong) UserModel *userModel;
@end
