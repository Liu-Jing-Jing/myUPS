//
//  PopUpDatePickerView.m
//  Natures
//
//  Created by 柏霖尹 on 2019/9/17.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "PopUpDatePickerView.h"

@implementation PopUpDatePickerView
+ (instancetype)popViewInstance
{
    NSBundle *bundle = [NSBundle mainBundle];
    PopUpDatePickerView *view = [[bundle loadNibNamed:@"PopUpDatePickerView" owner:self options:nil] lastObject];
    view.layer.cornerRadius = 5.0;
    [view.datePickerView addTarget:self action:@selector(dataPickeViewAction:) forControlEvents:UIControlEventValueChanged];
    return view;
}

- (void)dataPickeViewAction:(UIDatePicker *)sender
{
    self.selectDate = sender.date;
    NSLog(@"%@", sender.date);
}

- (IBAction)confirmAction:(id)sender
{
    if(self.ConfirmBlock)
    {
        self.ConfirmBlock();
    }
}



@end
