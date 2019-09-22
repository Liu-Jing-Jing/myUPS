//
//  NSLoginViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/22.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "NSLoginViewController.h"
#import "SignupFormViewController.h"
#import "BaseNavigationController.h"
#import "UIViewController+Extension.h"
#import "TTTAttributedLabel.h"
#import "HomeLoginViewController.h"
#import "HttpTool.h"
#import "MainTabBarController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface NSLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoButtonCenterX;
@end

@implementation NSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.facebookButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.facebookButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.facebookButton.layer.cornerRadius = 5;
    
    [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 5;
    
    [self.signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    self.signupButton.layer.cornerRadius = 5;
    self.enableHiddenNavBar = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loginButton.hidden = NO;
        self.facebookButton.hidden = NO;
        self.signupButton.hidden = NO;
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.hiddenAllButtons== YES)
    {
        self.loginButton.hidden = YES;
        self.facebookButton.hidden = YES;
        self.signupButton.hidden = YES;
    }
}
- (IBAction)loginButtonClicked:(id)sender
{
    //[HttpTool]
    // 进入登陆界面
    __weak typeof(self) weakSelf = self;
    HomeLoginViewController *homeLogin = [[HomeLoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:homeLogin];
    homeLogin.CancelLgoinAction = ^{
        weakSelf.hiddenAllButtons = NO;
    };
    [self presentViewController:nav animated:NO completion:^{}];
    
    
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
//    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBarController"];

}

- (IBAction)signupAction:(id)sender
{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    __weak typeof(self) weakSelf = self;
    SignupFormViewController *formVC = [[SignupFormViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:formVC];
    formVC.showButtons = ^{
        weakSelf.hiddenAllButtons = NO;
    };
    [self presentViewController:nav animated:NO completion:^{}];
}

- (void)setHiddenAllButtons:(BOOL)hiddenAllButtons
{
    _hiddenAllButtons = hiddenAllButtons;
    
    if(hiddenAllButtons== YES)
    {
        self.loginButton.hidden = YES;
        self.facebookButton.hidden = YES;
        self.signupButton.hidden = YES;
    }
}

- (IBAction)facebookLoginAction:(id)sender
{
    self.hiddenAllButtons = NO; // 显示所有的按钮
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    FBSDKLoginManager *fbManager = [[FBSDKLoginManager alloc] init];
    //[fbManager logOut];
    //fbManager.loginBehavior = FBSDKLoginBehaviorBrowser;
    [fbManager logInWithPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        //
        [self getUserInfoWithResult:result];
    }];
}



//获取用户信息 picture用户头像
- (void)getUserInfoWithResult:(FBSDKLoginManagerLoginResult *)fbResult
{
    NSDictionary*params= @{@"fields":@"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:fbResult.token.userID
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        //
        NSString *name = result[@"name"];
        NSString *avatarUrlString = result[@"picture"][@"data"][@"url"];
        NSString *email = result[@"email"];
        
        if(name==nil|| email==nil||fbResult.token.userID==nil)
        {
            //显示授权失败
            [MBProgressHUD showMessage:@"Auth Failure, Please try again."];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
        else
        {
        NSDictionary *dict=@{
                             @"name":name,
                             @"email": email,
                             @"productId":PRODUCTID,
                             @"portrait":avatarUrlString,
                             @"tripartiteLoginKey":fbResult.token.userID,
                             @"tripartiteLoginType": @"facebook",
                             };
        // 开始登录
        [HttpTool facebookLoginWithParam:dict success:^(id  _Nonnull responseObject) {
            //
            NSLog(@"%@", responseObject);
            NSLog(@"第三方授权登录%@", responseObject[@"message"]);
            [[NSUserDefaults standardUserDefaults] setValue:@"On" forKey:kAutoLogin];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        } failure:^(NSError * _Nonnull error) {
            //
        }];
        }
        //NSLog(@"%@",result);
        /*
         {
         "age_range" =     {
         min = 21;
         };
         "first_name" = "\U6dd1\U5a1f";
         gender = female;
         id = 320561731689112;
         "last_name" = "\U6f58";
         link = "https://www.facebook.com/app_scoped_user_id/320561731689112/";
         locale = "zh_CN";
         name = "\U6f58\U6dd1\U5a1f";
         picture =     {
         data =         {
         "is_silhouette" = 0;
         url = "https://fb-s-c-a.akamaihd.net/h-ak-fbx/v/t1.0-1/p50x50/18157158_290358084709477_3057447496862917877_n.jpg?oh=01ba6b3a5190122f3959a3f4ed553ae8&oe=5A0ADBF5&__gda__=1509731522_7a226b0977470e13b2611f970b6e2719";
         };
         };
         timezone = 8;
         "updated_time" = "2017-04-29T07:54:31+0000";
         verified = 1;
         }
         */
    }];
}
@end
