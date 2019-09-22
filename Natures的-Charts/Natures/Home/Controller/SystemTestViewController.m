//
//  SystemTestViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/20.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "SystemTestViewController.h"
#define Ftext(value) [NSString stringWithFormat:@"%d°F", (value)]
#import "TTTAttributedLabel.h"
#import "DetailWebViewController.h"
#import "MessageModel.h"
@interface SystemTestViewController ()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *inverterImage;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (copy, nonatomic) NSString *systemTestResString;
@end

@implementation SystemTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = kThemeColor;
    [self createFooterView];
    int temperatureValue = 0;
    if(self.model){
        UILabel * l = self.statusLabelArray[Temperature];
        UILabel * wLabel= self.waitingLabel[Temperature];
        wLabel.hidden = YES;
        temperatureValue = self.model.temperature.intValue;
        l.text = Ftext(temperatureValue);
    }
    
    if(self.model)
    {
        NSArray *array = [self judgeUPSmodel:self.model];
        int flag = 0;
        for(int i=0;i<array.count;i++)
        {
            if([array[i] intValue] == 1) flag++;
        }

        
        if(flag == 6)
        {
            NSLog(@"System Test  is OK");
            if(self.model) [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemTestPushVCNotification" object:nil userInfo:@{@"model": self.model}];
            // 状态OK
        }
    }
}

- (void)createFooterView
{
//    [self.view addSubview:footerView];
//    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, 50));
//    }];
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    [self.footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
    [label setTextInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    
    NSString *text = @"if you have any questions or concerns, please contact us.";
    NSRange selRange = [text rangeOfString:@"please contact us."];
    
    NSMutableAttributedString *mutableAS = [[NSMutableAttributedString alloc] initWithString:@"if you have any questions or concerns, please contact us."];
    [mutableAS addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)} range:selRange];
    [mutableAS setAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor} range:[text rangeOfString:text]];
    label.attributedText = mutableAS;
    label.numberOfLines = 0;
    label.delegate = self;
    [label addLinkToTransitInformation:@{@"select":@"policy"} withRange:selRange];
    
    label.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    label.inactiveLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
    label.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName: [UIColor whiteColor]};
}

#pragma mark - TableView
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    NSLog(@"处理联系我的界面");
    DetailWebViewController *webVC = [[DetailWebViewController alloc] init];
    webVC.title = @"Contact Us";
    webVC.url = [NSURL URLWithString:@"https://naturesgenerator.com/pages/contact-us"];
    [self.navigationController pushViewController:webVC animated:YES];
}

/** 返回状态信息*/
- (NSArray *)judgeUPSmodel:(UpsModel *)model
{
    11
    self.systemTestResString = @"System Test is All OK";
    NSMutableArray *statusFlags = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0)]];
    // 修改电池的状态信息
    for (UILabel *label in self.waitingLabel)
    {
        label.hidden = YES;
    }
    
    {
        statusFlags[0] = @(1);
        UILabel *label = self.statusLabelArray[BatteryType];
        label.text  = @"Good";
        label.hidden = NO;
        
        UIImageView *imageView = self.statusImageViews[BatteryType]; //只有前四种状态的图标
        imageView.hidden = NO;
    }
    
    //电压状态
    if ([model.voltage isEqualToString:@"0"])
    {
        NSLog(@"1Good");
        statusFlags[1] = @(1);
    }
    else
    {
        //Battery.setText("failure");
    }
    
    
    //usb状态
    if (model.usb.intValue == 1)
    {
        NSLog(@"2Good");
        UILabel *label = self.statusLabelArray[1];
        label.text  = @"Good";
        statusFlags[2] = @(1);
        label.hidden = NO;
        
        UIImageView *imageView = self.statusImageViews[1]; //只有前四种状态的图标
        imageView.hidden = NO;
    }
    else
    {
        NSLog(@"Failure");
        UILabel *label = self.statusLabelArray[1];
        label.text  = @"Failure";
        label.hidden = NO;
        
        UIImageView *imageView = self.statusImageViews[1]; //只有前四种状态的图标
        imageView.hidden = NO;
    }
    
    //12vDc状态
    if (model.dc.intValue == 1) {
        NSLog(@"3Good");
        UILabel *label = self.statusLabelArray[2];
        label.text  = @"Good";
        label.hidden = NO;
        statusFlags[3] = @(1);
        UIImageView *imageView = self.statusImageViews[2]; //只有前四种状态的图标
        imageView.hidden = NO;
    }
    else
    {
        NSLog(@"Failure");
        UILabel *label = self.statusLabelArray[2];
        label.text  = @"Failure";
        label.hidden = NO;
        
        UIImageView *imageView = self.statusImageViews[2]; //只有前四种状态的图标
        imageView.hidden = NO;
    }
    
    //Fuse状态
    if(model.fuse.intValue == 0)
    {
        NSLog(@"4Good");
        UILabel *label = self.statusLabelArray[Fuse];
        label.text  = @"Good";
        label.hidden = NO;
        statusFlags[4] = @(1);
        UIImageView *imageView = self.statusImageViews[Fuse]; //只有前四种状态的图标
        imageView.hidden = NO;
    }
    else
    {
        NSLog(@"Failure");
        UILabel *label = self.statusLabelArray[Fuse];
        label.text  = @"Failure";
        label.hidden = NO;
        
        UIImageView *imageView = self.statusImageViews[Fuse]; //只有前四种状态的图标
        imageView.hidden = NO;
    }
    
    
    //逆变器状态
    if(model.inverter.intValue == 0)
    {
        NSLog(@"5Good");
        UILabel *label = self.statusLabelArray[Inverter];
        label.text  = @"Good";
        label.hidden = NO;
        statusFlags[5] = @(1);
        UIImageView *imageView = self.inverterImage;
        imageView.hidden = NO;
    }
    else
    {
        UILabel *label = self.statusLabelArray[Inverter];
        label.text  = @"Good";
        label.hidden = NO;
        
        UIImageView *imageView = self.inverterImage;
        self.inverterImageView.hidden = NO;
    }
    
    
    //扩展端口
    if(model.plug.intValue == 0)
    {
        NSLog(@"Never");
        UILabel *label = self.statusLabelArray[ExpansionPort];
        label.text  = @"Never";
        label.hidden = NO;
    }
    else
    {
        UILabel *label = self.statusLabelArray[ExpansionPort];
        label.text  = @"Connect";
        label.hidden = NO;
    }
    
    
    //太阳能扩展端口
    if(model.tian.intValue == 0)
    {
        NSLog(@"Never");
        UILabel *label = self.statusLabelArray[SolarPort];
        label.text  = @"Never";
        label.hidden = NO;
    }
    else
    {
        UILabel *label = self.statusLabelArray[SolarPort];
        label.text  = @"Connect";
        label.hidden = NO;
    }
    
    
    //风能扩展端口
    if(model.threeFan.intValue == 0)
    {
        NSLog(@"Never");
        UILabel *label = self.statusLabelArray[WindGeneratorPort];
        label.text  = @"Never";
        label.hidden = NO;
    }
    else
    {
        UILabel *label = self.statusLabelArray[WindGeneratorPort];
        label.text  = @"Connect";
        label.hidden = NO;
    }
    
    return statusFlags;
}

@end
