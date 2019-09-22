
//
//  FooterView.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/5.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "FooterView.h"
@interface FooterView()
- (IBAction)saveAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation FooterView
+ (instancetype)footerView
{
    NSBundle *bundle = [NSBundle mainBundle];
    // 读取xib文件(会创建xib中的描述的所有对象)
    NSArray *objs = [bundle loadNibNamed:@"FooterView" owner:self options:nil];
    FooterView *view = [objs lastObject];
    view.saveButton.layer.cornerRadius = 10;
    view.logoutButton.layer.cornerRadius = 10;
    return view;
}


- (IBAction)saveAction:(id)sender
{
    if([self.footerDelegate respondsToSelector:@selector(footerViewSaveButtonClicked:)])
    {
        [self.footerDelegate footerViewSaveButtonClicked:self];
    }
}

- (IBAction)logoutAction:(id)sender
{
    if([self.footerDelegate respondsToSelector:@selector(footerViewLogoutButtonClicked:)])
{
    [self.footerDelegate footerViewLogoutButtonClicked:self];
}
}
@end
