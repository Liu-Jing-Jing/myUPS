
//
//  EMSTwoButtonPopView.m
//  EMS
//
//  Created by 柏霖尹 on 2019/7/16.
//  Copyright © 2019 work. All rights reserved.
//

#import "EMSTwoButtonPopView.h"

@implementation EMSTwoButtonPopView

+ (instancetype)twoButtonPopViewInstance
{
    NSBundle *bundle = [NSBundle mainBundle];
    EMSTwoButtonPopView *view = [[bundle loadNibNamed:@"EMSTwoButtonPopView" owner:self options:nil] lastObject];
    view.layer.cornerRadius = 5.0;
    view.calendarManager = [[JTCalendarManager alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"] andTimeZone:[NSTimeZone timeZoneWithName:@"en_US"]];
    [view.calendarManager setContentView:view.calContentView];
    [view.calendarManager setMenuView:view.topMenuView];
//    [view.calendarManager. ]
    view.calendarManager.delegate = view;
    [view.calendarManager setDate:[NSDate date]];
    view.layer.cornerRadius = 5.0;
    return view;
}

- (IBAction)buttonAction1:(id)sender
{
    // left
    if(self.firstBlock)
    {
        self.firstBlock();
    }
}

- (IBAction)buttonAction2:(id)sender
{
    // right
    if(self.secondBlock)
    {
        self.secondBlock();
    }
}

//改变日历的代理方法
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    //日期为今天的样式
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = LLColor(172, 176, 177);
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor redColor];
        
    }
    //日期为选中模式的样式
//    else if([self isInDatesSelected:dayView.date]){
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = LLColor((227, 114, 127, 1);
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//    }
    //这个为本月内第一个星期里上月日期的样式
    else if(![_calendarManager.dateHelper date:self.calContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // 这个为下月内第一个星期里今天的样式
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    //日期有事件则显示个小红点，没有就不显示
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
}


- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView
{
    NSLog(@"%@", [dayView date]);
    
    if(self.selectCalendarBlock)
    {
        //修改了日期
        self.selectCalendarBlock([dayView date]);
    }
}
@end
