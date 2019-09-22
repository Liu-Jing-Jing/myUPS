//
//  EMSTwoButtonPopView.h
//  EMS
//
//  Created by 柏霖尹 on 2019/7/16.
//  Copyright © 2019 work. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JTVerticalCalendarView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^btn1ClickBlock)(void);
typedef void(^changeDateClickBlock)(NSDate *date);
@class EMSTwoButtonPopView;
@protocol EMSTwoButtonPopViewDelegate <NSObject>
- (void)emsPopView:(EMSTwoButtonPopView *)popupView didSelectdDate:(NSDate *)currentDate;
@end

@interface EMSTwoButtonPopView : UIView<JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
+ (instancetype)twoButtonPopViewInstance;
@property (nonatomic, copy) btn1ClickBlock firstBlock;
@property (nonatomic, copy) btn1ClickBlock secondBlock;
@property (nonatomic, copy) changeDateClickBlock selectCalendarBlock;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calContentView;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *topMenuView;

@end

NS_ASSUME_NONNULL_END
