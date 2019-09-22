//
//  AppDelegate.m
//  Natures
//
//  Created by sjty on 2019/7/10.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "AppDelegate.h"
#import "GuidelineViewController.h"
#import "NSLoginViewController.h"
#import "BaseNavigationController.h"
#import "BaseUtils.h"
#import "HttpTool.h"
#import "LaunchViewController.h"
#import "INTULocationManager.h"
#import "NewFeatureViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)isFirstUsageTheVersion
{
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:5 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        NSLog(@"申请定位权限");
        if(status != INTULocationStatusSuccess)
        {
            //
            NSLog(@"重新申请s定位权限");
        }
    }];
    
    NSString *key = @"CFBundleVersion";
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion])
    {
        // 不是第一次使用这个版本
        return NO;
    }
    else
    {
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if DEBUG
    // iOS
    //[[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    application.statusBarStyle = UIStatusBarStyleLightContent;
#endif
    self.themeColor = LLColor(44, 48, 60);
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootVC;
//#warning 测试
//    //登录成功之后的页面哦
//    rootVC= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
//    self.window.rootViewController = rootVC;
//    [self.window makeKeyAndVisible];
//    return YES;
//
//#warning 测试
    if([self isFirstUsageTheVersion])
    {
        rootVC = [[NewFeatureViewController alloc] init];
    }
    
    if(YES)
    {
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        //NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
        //第二次之后的页面哦
//         rootVC= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        NSString *switchAuto = [[NSUserDefaults standardUserDefaults] valueForKey:kAutoLogin];
        if([switchAuto isEqualToString:@"On"])// 开启自动登啰
        {
            [HttpTool checkSessionVerify:^(BOOL isValid) {
                if(isValid)
                {
                    [MBProgressHUD showSuccess:@"Welcome"];
                    self.window.rootViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
                }
                else
                {
                    // 过期或出错了
                    NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
                    self.window.rootViewController = loginVC;
                }
            } failure:^(NSError * _Nonnull error) {
                //
                [MBProgressHUD showError:@"网络出现错误, 请稍后再试"];
                
            }];
        }
        else
        {
            //没有自动登录
            NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
            self.window.rootViewController = loginVC;
            [self.window makeKeyAndVisible];
            return YES;
        }
    }
    
    NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
    loginVC.hiddenAllButtons = YES;
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)autoAccoutLogic
{
    //#warning 判断是否登录成功了
    
    NSString *switchAuto = [[NSUserDefaults standardUserDefaults] valueForKey:kAutoLogin];
    if([switchAuto isEqualToString:@"On"])// 开启自动登啰
    {
        [HttpTool checkSessionVerify:^(BOOL isValid) {
            if(isValid)
            {
                [MBProgressHUD showSuccess:@"Welcome"];
                self.window.rootViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
            }
            else
            {
                // 过期或出错了
                NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
                self.window.rootViewController = loginVC;
            }
        } failure:^(NSError * _Nonnull error) {
            //
            [MBProgressHUD showError:@"网络出现错误, 请稍后再试"];
            
        }];
    }
    else
    {
        //没有自动登录
        NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
        self.window.rootViewController = loginVC;
        [self.window makeKeyAndVisible];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}
@end
