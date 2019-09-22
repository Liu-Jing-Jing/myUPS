//
//  PWDResetViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/22.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "PWDResetViewController.h"
#import "FormTextField.h"
@interface PWDResetViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resetPwdButton;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet FormTextField *emailTF;
@property (weak, nonatomic) IBOutlet FormTextField *pwdTF;
- (IBAction)sendNewPasswordAction:(id)sender;
- (IBAction)getCodeAction:(id)sender;
@end

@implementation PWDResetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setupUI];
}

- (void)setupUI
{
    self.getCodeButton.layer.cornerRadius = 10.0;
    self.resetPwdButton.layer.cornerRadius = 10.0;
}



- (IBAction)sendNewPasswordAction:(id)sender {
    //
    if(self.emailTF.text.length <= 0)
    {
        NSLog(@"请输入新密码和邮箱");
        [MBProgressHUD showError:@"No email"];
        return;
    }
    
    if(self.pwdTF.text.length <=0)
    {
        [MBProgressHUD showError:@"Please input your New Password"];
        return;
    }
    
    NSString *email = [self.emailTF.text trimeLeftAndRightWhitespace];
    NSString *newPWD = [self.pwdTF.text trimeLeftAndRightWhitespace];
#warning 修改成正确的邮箱验证码
    [[HttpTool shareInstance] changePasswordUsingEmail:email newPassword:newPWD Code:@"0000" Block:^(NSDictionary * obj) {
        //
        NSLog(@"%@", obj);
    }];
}

- (IBAction)getCodeAction:(id)sender {
    if(self.emailTF.text.length <= 0)
    {
        NSLog(@"请输入邮箱");
        return;
    }
    
    NSString *email = [self.emailTF.text trimeLeftAndRightWhitespace];
    [[HttpTool shareInstance] getCode:email Block:^(NSDictionary * _Nonnull dictionary) {
        //
        self.resetPwdButton.enabled = YES;
    }];
}
@end
