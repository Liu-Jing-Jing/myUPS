//
//  MyWeatherViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/5.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MyWeatherViewController.h"
#import "OWMWeather.h"
#import "OWMToday.h"
#import "OWMMain.h"
#import "OWMConstants.h"
#import "OWMAPIClient.h"
#import "FooterView.h"
#import "MBProgressHUD+MJ.h"
#import <CoreLocation/CoreLocation.h>
@interface MyWeatherViewController ()<OWMWeatherProtocol>
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) OWMAPIClient *client;
@end

@implementation MyWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:-74.1207946 longitude:40.6980146]; // NY 大学
    self.client = [[OWMAPIClient alloc] initWithBaseURL:kWeatherAPIBaseURL];
    NSMutableDictionary *paramas = [self baseParams];
    [paramas setObject:@(location.coordinate.latitude).stringValue forKey:@"lat"];
    [paramas setObject:@(location.coordinate.longitude).stringValue forKey:@"lon"];
    [self.client performGETCallToEndpoint:@"weather" withParameters:paramas andSuccess:^(id  _Nullable responseObject) {
        //NSLog(@"response %@", responseObject);
        NSError *error;
        OWMToday *today = [[OWMToday alloc] initWithDictionary:responseObject error:&error];
        self.messageLabel.text = [NSString stringWithFormat:@"当前温度: %@", [OWMConstants kelvinToDefaultTemprature:today.main.temp]];
        NSLog(@"%@", today);
    } andFailure:^(NSError * _Nullable error) {
        //错误处理
    }];
    
    [self currentWeather:nil];
}

-(NSMutableDictionary *)baseParams{
    return @{ @"APPID" : kWeatherAPIKey }.mutableCopy;
}

- (void)currentWeather:(CLLocation *)obj
{
    
    // 强制 成 简体中文
    [[NSUserDefaults
      standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en-US",
                                       nil] forKey:@"AppleLanguages"];
    
#warning 得到当前的天气信息
    CLLocation *location = [[CLLocation alloc] initWithLatitude:-74.1207946 longitude:40.6980146];
    
    __weak typeof(self) weakSelf = self;
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //
        CLPlacemark *pm = placemarks.firstObject;
        NSLog(@"%@", pm.locality);
    }];
}

- (void)didUpdateForecaset:(OWMWeather *)weather
{
    NSLog(@"%@", weather.currentTemp);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
