//
//  ViewController.h
//  Natures
//
//  Created by sjty on 2019/7/10.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BleAutoConnectionViewController.h"
@interface ViewController : BaseViewController

// WATTS上方的4个按钮 开始时隐藏.然后根据状态显示1-4号按钮
@property (weak, nonatomic) IBOutlet UIImageView *batteryLeftView;
@property (weak, nonatomic) IBOutlet UIImageView *batteryRightView;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *fourStatusButton;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *rightViews;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *leftViews;

- (void)setBatteryLeftGradeWithValue:(int)value;
- (void)setBatteryRightGradeWithValue:(int)value;
@end

