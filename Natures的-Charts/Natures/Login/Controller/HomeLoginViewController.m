

//
//  HomeLoginViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/27.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "HomeLoginViewController.h"
#import "FormTextField.h"
#import "LaunchViewController.h"
#import "PWDResetViewController.h"
#import "REValidation.h"
#import "TTTAttributedLabel.h"
#define ON @"On"
#define OFF @"Off"
@interface HomeLoginViewController ()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet FormTextField *textField1;
@property (weak, nonatomic) IBOutlet FormTextField *textField2;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation HomeLoginViewController
#warning Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置导航栏的东西
    self.navigationItem.leftBarButtonItem = [self itemWithImageName:@"nva_back"
                                                      highImageName:@"nva_back"
                                                             target:self action:@selector(back)];
    self.title = NSStringLKV(@"Log in");
    //setupUI
    self.textField2.secureTextEntry = YES;
    self.loginButton.layer.cornerRadius = 10.0;
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.delegate = self;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.loginButton.mas_bottom).offset(5);
        make.height.mas_equalTo(30.0);
    }];
    
    
#warning bendi
    NSString *content = @"Forgot your Password?";
    label.font = [UIFont systemFontOfSize:11];
    label.numberOfLines = 0;
    label.contentMode = UIViewContentModeCenter;
    label.lineSpacing = 8;
    label.textColor = [UIColor whiteColor];
    label.delegate = self;
    //设置需要点击的文字的颜色大小
    NSMutableAttributedString *mAS = [[NSMutableAttributedString alloc] initWithString:content];
    [label setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont systemFontOfSize:11]} range:[content rangeOfString:content]];
        [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName value:@(1) range:[content rangeOfString:content]];
        return mutableAttributedString;
    }];
    
    label.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    label.inactiveLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    label.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    NSRange selRange=[content rangeOfString:content];
    [label addLinkToTransitInformation:@{@"select":@"policy"} withRange:selRange];
    
#warning 保存密码的具体操作
    // 设置按钮的状态
    NSString *state = [[NSUserDefaults standardUserDefaults] valueForKey:kSavePassword];
    if(state)
    {
        // 设置一下状态
        if ([state isEqualToString:ON]) {
            //设置选择
            self.rightButton.selected = YES;
            self.textField1.text = [[NSUserDefaults standardUserDefaults] valueForKey:kAccount];
            self.textField2.text = [[NSUserDefaults standardUserDefaults] valueForKey:kPWD];
            self.textField2.text = [[self.textField2.text componentsSeparatedByString:@"^"] firstObject];
        }
        else
        {
            self.rightButton.selected = NO;
        }
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    // 跳转到修改密码的页面,但是要判断这个Email是否存在
#warning 25-修改限制长度
    NSString *emailStr = [self.textField1.text trimeLeftAndRightWhitespace];
    NSArray *errors = [REValidation validateObject:emailStr name:@"Email" validators:@[ @"presence", @"length(3, 20)", @"email"]];
    for (NSError *error in errors) NSLog(@"Error: %@", error.localizedDescription);
    
    if(errors.count)
    {        // 提示用户
        NSString *msg = NSStringLKV(@"请输入正确的邮箱");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    }
    else
    {
        PWDResetViewController *resetVC = [[PWDResetViewController alloc] init];
        
        [self.navigationController pushViewController:resetVC animated:YES];
    }
}



- (IBAction)loginActionButton:(id)sender
{
    if(self.leftButton.selected)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(self.rightButton.selected)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:kSavePassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:kSavePassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *param1 = [self.textField1.text trimeLeftAndRightWhitespace];
    NSString *param2 = [self.textField2.text trimeLeftAndRightWhitespace];
    
    if(param1.length == 0){
        [MBProgressHUD showError:@"Format incorrect"];
    }
    
    if(param2.length == 0)
    {
        [MBProgressHUD showError:@"Format incorrect"];
    }
    
    if(param1.length && param2.length)
    {
        [[NSUserDefaults standardUserDefaults] setObject:param1 forKey:kAccount];
        [[NSUserDefaults standardUserDefaults] setObject:param2.add(@"^") forKey:kPWD];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
#warning 25-修改限制长度
    NSString *emailStr = param1;
    NSArray *errors = [REValidation validateObject:emailStr name:@"Email" validators:@[ @"presence", @"length(3, 25)", @"email"]];
    for (NSError *error in errors) NSLog(@"Error: %@", error.localizedDescription);
    if(errors.count) {[MBProgressHUD showError:@"邮箱格式不正确"];}
    
    [[HttpTool shareInstance] login:param1 Password:param2 Block:^(NSDictionary * _Nonnull dictionary) {
        //NSLog(@"OKKKKK  登录啦---%@", dictionary[@"status"]);
        NSString *msg = [NSString stringWithFormat:@"%@", dictionary[@"message"]];
        
        // 服务器返回的状态码
        NSString *code = [NSString stringWithFormat:@"%@", dictionary[@"status"]];
        if([code isEqualToString:@"201"] || [code isEqualToString:@"200"] || [msg isEqualToString:@"登录成功"])
        {
            //登录成功了
            [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        }
    }];
}

- (IBAction)leftButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if(sender.isSelected)
    {
        self.rightButton.selected = YES;

#warning 自动登录的处理f过程
        [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (IBAction)rightButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if(sender.selected)
    {
        self.leftButton.selected = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:kSavePassword];
        [[NSUserDefaults standardUserDefaults] setObject:@"On" forKey:kAutoLogin];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    else
    {
        self.leftButton.selected = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:kSavePassword];
        [[NSUserDefaults standardUserDefaults] setObject:@"Off" forKey:kAutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
#warning 记住密码的处理
}


- (void)back
{
#warning 这里用的是self
    if(self.CancelLgoinAction) self.CancelLgoinAction();
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    
    
    // 设置按钮的尺寸为背景图片的尺寸
    button.size = button.currentBackgroundImage.size;
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end
