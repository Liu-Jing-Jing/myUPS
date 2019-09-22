//
//  MainTabBarController.m
//  PrintApp
//
//  Created by sjty on 2019/2/12.
//  Copyright © 2019年 com.sjty. All rights reserved.
//

#import "MainTabBarController.h"
#import "MessageController.h"
#import "MessageModel.h"
#import "BaseNavigationController.h"

#import "UIImage+Color.h"
@interface MainTabBarController ()<UITabBarControllerDelegate>
@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    self.delegate=self;
    
//    [self.tabBar setBarTintColor:[UIColor colorWithRed:251/255.0 green:195/255.0 blue:61/255.0 alpha:1]];
//    [UITabBar appearance].clipsToBounds = YES;
    
    self.tabBar.backgroundImage = [self imageWithColor:[UIColor colorWithRed:34/255.0 green:37/255.0 blue:46/255.0 alpha:1]];
    self.tabBar.shadowImage = [self imageWithColor:[UIColor colorWithRed:34/255.0 green:37/255.0 blue:46/255.0 alpha:1]];
    

    self.viewControllers[0].tabBarItem.selectedImage=[[UIImage imageNamed:@"home_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[0].tabBarItem.image=[[[UIImage imageNamed:@"home_select"] imageChangeColor:[UIColor whiteColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[0].tabBarItem.title=@"Home";
    [self.viewControllers[0].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:43/255.0 green:148/255.0 blue:197/255.0 alpha:1]} forState:UIControlStateSelected];
    [self.viewControllers[0].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    self.viewControllers[1].tabBarItem.selectedImage=[[UIImage imageNamed:@"history_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[1].tabBarItem.image=[[UIImage imageNamed:@"history_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[1].tabBarItem.title=@"History";
    [self.viewControllers[1].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:43/255.0 green:148/255.0 blue:197/255.0 alpha:1]} forState:UIControlStateSelected];
    [self.viewControllers[1].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    self.viewControllers[2].tabBarItem.selectedImage=[[UIImage imageNamed:@"message_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[2].tabBarItem.image=[[UIImage imageNamed:@"message_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[2].tabBarItem.title=@"Message";
    [self.viewControllers[2].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:43/255.0 green:148/255.0 blue:197/255.0 alpha:1]} forState:UIControlStateSelected];
    [self.viewControllers[2].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.viewControllers[3].tabBarItem.selectedImage=[[UIImage imageNamed:@"more_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[3].tabBarItem.image=[[UIImage imageNamed:@"more_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers[3].tabBarItem.title=@"More";
    [self.viewControllers[3].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:43/255.0 green:148/255.0 blue:197/255.0 alpha:1]} forState:UIControlStateSelected];
    [self.viewControllers[3].tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageWithUPSmodelAction:) name:kSystemTestNotificationName object:nil];
    
//    [HttpTool getUpsMessageListSuccess:^(id  _Nonnull responseObject) {
//        NSLog(@"Message-List");
//    } failure:^(NSError * _Nonnull error, NSString * _Nonnull message) {
//        //
//    }];

#warning 气泡功能修改
//    [HttpTool getUpsMessageListWithStatus:3 Success:^(id  _Nonnull responseObject) {
//        int count = 0;
//        for (NSDictionary *jsonModel in responseObject[@"data"])
//        {
//            MessageModel *model = [[MessageModel alloc] initWithDictionary:jsonModel];
//            if([model.status intValue] == 0) count++;
//        }
//        if(count>0)
//        self.viewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
//    } failure:^(NSError * _Nonnull error, NSString * _Nonnull message) {}];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


//// 获得新的消息数据
- (void)newMessageWithUPSmodelAction:(NSNotification *)notification
{
    return;
    NSLog(@"Click");
    int count = 0;
    NSArray *models = [MessageModel findAll];
    for (MessageModel *model in models)
    {
        if(model.status.intValue == 1) count++;
    }
    self.viewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count+1];
    //add
    MessageModel *model = [[MessageModel alloc] init];
    model.title = [NSString stringWithFormat:@"System Tests %d", arc4random_uniform(10)];
    model.icon = @(1);
    model.status = @(1);
    model.content = @"System Test Detail Message";
}


@end
