//
//  PopUpDatePickerView.h
//  Natures
//
//  Created by 柏霖尹 on 2019/9/17.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopUpDatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (nonatomic, strong) NSDate *selectDate;
+ (instancetype)popViewInstance;
@property (nonatomic, copy) void(^ConfirmBlock)(void);
@end

NS_ASSUME_NONNULL_END
