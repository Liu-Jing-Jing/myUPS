//
//  MonthPickerPopupView.m
//  Natures
//
//  Created by 柏霖尹 on 2019/9/18.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MonthPickerPopupView.h"

@implementation MonthPickerPopupView

+ (instancetype)popViewInstance
{
    NSBundle *bundle = [NSBundle mainBundle];
    MonthPickerPopupView *view = [[bundle loadNibNamed:@"MonthPickerPopupView" owner:self options:nil] lastObject];
    view.layer.cornerRadius = 5.0;
    
    for(int i=0;i<12;i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        NSString *monthName = [NSString stringWithFormat:@"%d", i+1];
        [btn setTitle:monthName forState:UIControlStateNormal];
        [view addSubview:btn];
    }
    return view;
}

-(void)layoutSubviews
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
