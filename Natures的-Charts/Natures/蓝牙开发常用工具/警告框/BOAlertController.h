//
//  BOAlertController.h
//  ControllerCar
//
//  Created by sjty on 16/8/19.
//  Copyright © 2016年 sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIButtonItem.h"

typedef enum {
    RIButtonItemType_Cancel         = 1,
    RIButtonItemType_Destructive       ,
    RIButtonItemType_Other
}RIButtonItemType;

typedef enum {
    BOAlertControllerType_AlertView    = 1,
    BOAlertControllerType_ActionSheet
}BOAlertControllerType;

#define isIOS8  ([[[UIDevice currentDevice]systemVersion]floatValue]>=8)

@interface BOAlertController : UIViewController
- (id)initWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)inViewController;
- (void)addButton:(RIButtonItem *)button type:(RIButtonItemType)itemType;

//Show ActionSheet in all versions
- (void)showInView:(UIView *)view;

//Show AlertView in all versions
- (void)show;
@end
