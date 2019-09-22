//
//  SignupFormViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/23.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "SignupFormViewController.h"
#import "FormTextField.h"
#import "IQKeyboardManager.h"
#import "REValidation.h"
#import "TTTAttributedLabel.h"
#import "PolicyWebViewController.h"
#import "INTULocationManager.h"
#define kLengthLimited 6


@interface SignupFormViewController ()<TTTAttributedLabelDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(FormTextField) NSArray *formTextField;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;
@property (weak, nonatomic) IBOutlet FormTextField *fNameTF;
@property (weak, nonatomic) IBOutlet FormTextField *lNameTF;
@property (weak, nonatomic) IBOutlet FormTextField *emailAddress;
@property (weak, nonatomic) IBOutlet FormTextField *pwdTF;
@property (weak, nonatomic) IBOutlet FormTextField *pwdTF2;
@property (weak, nonatomic) IBOutlet FormTextField *locationTF;
@property (nonatomic, strong) CLGeocoder *geoC; //地理编码工具类
@property (nonatomic, strong) INTULocationManager *locMgr; //
@property (weak, nonatomic) IBOutlet UIButton *startButton; // 开始注册的按钮
@property (weak, nonatomic) IBOutlet UIView *labelContainerView; //富文本容器view
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton; //获取验证码的按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeAction;

@end

@implementation SignupFormViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.geoC = [[CLGeocoder alloc] init];
    self.getCodeAction.enabled = NO;
    //self.startButton.hidden = YES;
    self.startButton.enabled = NO;
    [weakSelf.getCodeButton setTitle:@"Obtain" forState:UIControlStateNormal];
    //开始定位
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    // delayUntilAuthorized 超时时间从什么时候开始计算
    // true , 从用户选择授权之后开始计算
    // false, 从执行这个代码开始计算

    
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:5 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if(status == INTUHeadingStatusSuccess)
        {
            [self geoDECode:currentLocation
                     resuit:^(NSString *cityName) {
                         self.locationTF.text = cityName;
                         //cell.textField.text = cityName;
                     }];
        }
    }];
    
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

#pragma mark - 地理定位的处理
- (void)geoDECode:(CLLocation *)obj resuit:(void(^)(NSString *))block
{
    // 强制 成 简体中文
    [[NSUserDefaults
      standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en-US",
                                       nil] forKey:@"AppleLanguages"];
    
    
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:obj.coordinate.latitude longitude:obj.coordinate.longitude];
    
    [self.geoC reverseGeocodeLocation:obj completionHandler:^(NSArray<CLPlacemark *> * __nullable placemarks, NSError * __nullable error) {
        // 包含区，街道等信息的地标对象
        CLPlacemark *placemark = [placemarks firstObject];
        
        // 城市名称
        //        NSString *city = placemark.locality;
        // 街道名称
        //        NSString *street = placemark.thoroughfare;
        // 全称
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [MBProgressHUD showMessage:placemark.locality];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        });
        if(block)
        {
            block(placemark.locality);
        }
    }];
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    NSLog(@"textField - 正在编辑, 当前输入框内容为: %@", textField.text);
    if(textField ==_fNameTF)
    {
        if(!self.fNameTF.text.length)
        {
            UIButton *btn = self.starButtons[0];
            btn.selected = YES;
        }
        else
        {
            UIButton *btn = self.starButtons[0];
            btn.selected = NO;
        }
    }
    
    
    if(textField ==_lNameTF)
    {
        if(!self.lNameTF.text.length)
        {
            UIButton *btn = self.starButtons[1];
            btn.selected = YES;
        }
        else
        {
            UIButton *btn = self.starButtons[1];
            btn.selected = NO;
        }
    }
    
    
    if(textField == _emailAddress)
    {
        //email
        if(!self.emailAddress.text.length)
        {
            self.getCodeButton.enabled = YES;
            
            UIButton *btn = self.starButtons[2];
            btn.selected = YES;
            self.getCodeAction.enabled = NO;
        }
        else
        {
            self.getCodeButton.enabled = YES;
            NSString *emailStr = self.emailAddress.text;
            [REValidation registerDefaultValidators];
            NSArray *errors = [REValidation validateObject:emailStr name:@"Email" validators:@[ @"presence", @"length(3, 20)", @"email" ]];
            //for (NSError *error in errors) NSLog(@"Error: %@", error.localizedDescription);
            
            UIButton *btn = self.starButtons[2];
            if(errors.count >0)
            {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    
    if(textField == _pwdTF)
    {
        if(self.pwdTF.text.length < kLengthLimited)
        {
            UIButton *btn = self.starButtons[3];
            btn.selected = YES;
        }
        else
        {
            UIButton *btn = self.starButtons[3];
            btn.selected = NO;
        }
    }
    
    if(textField == _pwdTF2)
    {
        if([self.pwdTF.text isEqualToString:self.pwdTF2.text])
        {
            UIButton *btn = self.starButtons[4];
            btn.selected = NO;
        }
        else
        {
            UIButton *btn = self.starButtons[4];
            btn.selected = YES;
        }
    }
}


-(void)TraverseAllSubviews:(UIView *)view
{
    for (UIView *subView in view.subviews)
    {
        if (subView.subviews.count)
        {
            [self TraverseAllSubviews:subView];
        }
        //NSLog(@"%@",subView);[textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

        if([subView isKindOfClass:[FormTextField class]])[(FormTextField *)subView addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)setupUI
{
    for (UIButton *btn in self.starButtons)
    {
        btn.selected = YES;
    }
    [self TraverseAllSubviews:self.view];
    for (UITextField *tf in self.formTextField)
    {
        tf.layer.cornerRadius = 10.0;
        tf.layer.masksToBounds = YES;
    }
    self.startButton.layer.cornerRadius = 10.0;
    
    NSArray *textFields = @[self.fNameTF, self.lNameTF, self.emailAddress, self.pwdTF, self.pwdTF2];
    int tagIndex = 100;
    for (UIView *subview in textFields)
    {
        subview.tag = tagIndex++;
    }
    [IQKeyboardManager sharedManager].overrideKeyboardAppearance = NO;
    
    
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.delegate = self;
    [self.labelContainerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.labelContainerView);
    }];
#warning bendi
    NSString *content = @"By activating Nature's Pulse you agree to the Terms of Service and Privacy Policy";
    label.font = [UIFont systemFontOfSize:11];
    label.numberOfLines = 0;
    label.lineSpacing = 8;
    label.textColor = [UIColor whiteColor];
    //设置需要点击的文字的颜色大小
    NSMutableAttributedString *mAS = [[NSMutableAttributedString alloc] initWithString:content];
    [label setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont systemFontOfSize:11]} range:[content rangeOfString:content]];
        [mutableAttributedString addAttributes:@{NSFontAttributeName: [UIFont italicSystemFontOfSize:14]} range:[content rangeOfString:@"Nature's Pulse"]];
        [mutableAttributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)} range:[content rangeOfString:@"the Terms of Service and Privacy Policy"]];
        
        
        [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName value:@(1) range:[content rangeOfString:@"the Terms of Service and Privacy Policy"]];
        
        return mutableAttributedString;
    }];
    
    label.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    label.inactiveLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    label.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    NSRange selRange=[content rangeOfString:@"the Terms of Service and Privacy Policy"];
    [label addLinkToTransitInformation:@{@"select":@"policy"} withRange:selRange];
    // 设置导航栏的东西
    self.navigationItem.leftBarButtonItem = [self itemWithImageName:@"nva_back"
                                                      highImageName:@"nva_back"
                                                             target:self action:@selector(back)];
    self.title = NSStringLKV(@"Sign up");
    

    
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    NSLog(@"%@", components);
#warning 要判断是否惦记了点击
    
    PolicyWebViewController *vc = [[PolicyWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back
{
#warning 这里用的是self
    if(self.showButtons)self.showButtons();
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)buttonClicked:(id)sender
{
    // 注册之前检查密码的长度
    NSMutableString *message = [NSMutableString string];
    if(!self.fNameTF.text.length)
    {
        [message appendString:@"First name format incorrect\n"];
        UIButton *btn = self.starButtons[0];
        btn.selected = YES;
    }
    else
    {
        UIButton *btn = self.starButtons[0];
        btn.selected = NO;
    }
    
    if(!self.lNameTF.text.length)
    {
        [message appendString:@"Last name format incorrect\n"];
        
        UIButton *btn = self.starButtons[1];
        btn.selected = YES;
    }
    else
    {
        UIButton *btn = self.starButtons[1];
        btn.selected = NO;
    }
    
    //email
    if(!self.emailAddress.text.length)
    {
        [message appendString:@"No Email address \n"];
        UIButton *btn = self.starButtons[2];
        btn.selected = YES;
    }
    else
    {
        NSString *emailStr = self.emailAddress.text;
        [REValidation registerDefaultValidators];
        NSArray *errors = [REValidation validateObject:emailStr name:@"Email" validators:@[@"presence", @"length(3, 20)", @"email" ]];
        //for (NSError *error in errors) NSLog(@"Error: %@", error.localizedDescription);

        UIButton *btn = self.starButtons[2];
        if(errors.count >0)
        {
            [message appendString:@"Email format incorrect\n"];
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    
    if(self.pwdTF.text.length < kLengthLimited && self.pwdTF.text.length>16)
    {
        [message appendString:@"Please enter 6–16 legal characters\n"];
        UIButton *btn = self.starButtons[3];
        btn.selected = YES;
    }
    else
    {
        UIButton *btn = self.starButtons[3];
        btn.selected = NO;
    }
    
    if([self.pwdTF.text isEqualToString:self.pwdTF2.text])
    {
        UIButton *btn = self.starButtons[4];
        btn.selected = NO;
    }
    else
    {
        UIButton *btn = self.starButtons[4];
        btn.selected = YES;
        [message appendString:@"Password \n"];
    }
    
    if(message.length == 0)
    {
#warning 登录之前
        NSLog(@"没有错误");
        [self sendRegisterInfomation];
    }
    else
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Please input again"
                                            message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    
    
    // 设置按钮的尺寸为背景图片的尺寸
    button.size = button.currentBackgroundImage.size;
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

// 获取验证码
- (IBAction)btnClick:(UIButton *)sender
{
    __block int timeout = 10;
    //HUODEYANZHENGMA
    [[HttpTool shareInstance] getCode:[self.emailAddress.text trimeLeftAndRightWhitespace] Block:^(NSDictionary * _Nonnull dictionary) {
        //得到验证码 注册新的账号
//        [self.startButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        self.startButton.enabled = YES;
    }];
    
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

    __weak typeof(self)weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时
        
        //1. 每调用一次 时间-1s
        timeout --;
        
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout <= 0) {
            
            //停止倒计时，button打开交互，背景颜色还原，title还原
            
            //关闭定时器
            dispatch_source_cancel(timer);
            
            //MRC下需要释放，这里不需要
            // dispatch_realse(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.getCodeButton.userInteractionEnabled = YES;//开启交互性
                weakSelf.getCodeButton.backgroundColor = UIColor.clearColor;;
                [weakSelf.getCodeButton setTitle:@"Send again" forState:UIControlStateNormal];
            });
        }else {
            
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * title = [NSString stringWithFormat:@"Obtain",timeout];
                // [weakSelf.getCodeButton setTitle:@"Obtain" forState:UIControlStateNormal];
                weakSelf.getCodeButton.titleLabel.text = title;
                [weakSelf.getCodeButton setTitle:title forState:UIControlStateNormal];
                weakSelf.getCodeButton.userInteractionEnabled = NO;//关闭交互性
            });
        }
    });
    
    dispatch_resume(timer);
}
#pragma Networking part
- (void)sendRegisterInfomation
{
    NSString *param1 = [self.emailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *param2 = [self.pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", _fNameTF.text, _lNameTF.text];
    #warning 修改真的验证码给我

    // 判断获得的验证码是否准确
    [[HttpTool shareInstance] registerUser:param1 withName:fullName Password:param2 Code:@"" Block:^(id * _Nonnull dictionary) {
        // 注册新用户
        NSLog(@"%@", dictionary);
        if([dictionary isEqualToString:@"200"]&& [dictionary isEqualToString:@"201"])
        {
            [MBProgressHUD showSuccess@"Sign up successful" toView:self.view];
        }
        else
        {
            [MBProgressHUD showError:"Sign up failed" toView:self.view];
        }
        //成功就显示出来
    }];


}

////
//[[HttpTool shareInstance] registerUser:param1 withName:fullName Password:param2 Code:@"0000" Block:^(NSDictionary * _Nonnull data) {
//    if([data[@"status"] intValue] == 201 || [data[@"status"] intValue] == 200)
//    {
//        // 成功了
//
//        [MBProgressHUD showMessage:@"Loading..."];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//            UIViewController *rootVC= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//            [[UIApplication sharedApplication] keyWindow].rootViewController = rootVC;
//
//            [MBProgressHUD showSuccess:@"Successful"];
//        });
//
//    }
//}];
@end
