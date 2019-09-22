
//
//  AccountViewController.m
//  UPS
//
//  Created by Mark on 2019/8/4.
//  Copyright © 2019年 Mark. All rights reserved.
//

#import "AccountViewController.h"
#import "UITableViewCell+GroupStytleSeparatoe.h"
#import "AccountCell.h"
#import "AvatarCell.h"
#import "Masonry.h"
#import "UIColor+HW.h"
#import "MBProgressHUD+MJ.h"
#import "OWMWeather.h"
#import "OWMLocation.h"
#import "FooterView.h"
#import "HomeLoginViewController.h"
#import "BaseNavigationController.h"
#import "SDWebImageManager.h"
#import "UIButton+WebCache.h"
@interface AccountViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, FooterViewDelegate, AccountCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) UIImage *avatarImage;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, strong) CLGeocoder *geoC;
@property (nonatomic, strong) INTULocationManager *locMgr;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSString *currentModifyName;
@property (nonatomic, assign) BOOL isModify;
@end

@implementation AccountViewController
- (void)setupData
{
    self.menu = @[@[@"Avatar"], @[@"Name", @"Location", @"Account"]];
    self.avatarImage = [UIImage imageNamed:@"icon"];
}

- (void)setupUI
{
    // 初始化 tableView 
    self.view.backgroundColor = kThemeColor;
    self.tableView.backgroundColor = kThemeColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = UIColor.blackColor;
    self.tableView.tableFooterView = [self createFooterView];
    self.defaultImage = [UIImage imageNamed:@"me_kong"];
    self.geoC = [[CLGeocoder alloc] init];

    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(userInfoEditAction:)];
}
#warning Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    获取图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.defaultImage = image;
    //上传到服务器中
    self.avatarImage = image;
    [self uploadToServerImageIcon];
    
    //    获取图片后返回
    [UIApplication sharedApplication].statusBarHidden=NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    返回
    [UIApplication sharedApplication].statusBarHidden=NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        
// 会出现卡顿的现象
        _picker.delegate = self;
        _picker.allowsEditing = YES;
    }
    return _picker;
}


#warning ViewController Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //加载用户头像的模块
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HttpTool currentUserInformationWithSessionAction:^(BOOL state, NSDictionary *  data) {
            //
            UserModel *user = [UserModel userModelWithDictionary:data];
            self.userModel = user;
            [self.tableView reloadData];
        }];
    });
    
    [self setupData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#warning TableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        [self openCameraTookPhotoForAvatar];
    }
    
    if(indexPath.row ==1)
    {
        NSLog(@"11111");
        //开始定位

    }
}


- (void)openCameraTookPhotoForAvatar
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Change Avatar" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Open Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        //            判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [UIApplication sharedApplication].statusBarHidden=YES;
            [self presentViewController:self.picker animated:YES completion:NULL];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [UIApplication sharedApplication].statusBarHidden=YES;
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }]];
    
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Open Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:NULL];
    }]];
    //    BOOL isPicker = NO;
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // Cancel
    }]];
    
    [self presentViewController:alertVC animated:YES completion:NULL];
}

// 改变分割线的长度
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
}
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == 0)
    {
        cell = [AvatarCell cellforTableView:tableView];
        AvatarCell *aCell  = (AvatarCell *)cell;
        [aCell.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.userModel.portrait] forState:UIControlStateNormal];
//        [aCell.imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.portrait] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            aCell.avatarImage.image = [UIImage circleimageWithIconImage:image borderImage:image border:0];
//        }];
//
        cell.shouldRemoveFirstAndLastSeparatorLine = YES;
//        aCell.avatarImage.layer.masksToBounds=YES;
//        aCell.avatarImage.clipsToBounds = YES;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [HttpTool uploadIconImage:aCell.avatarImage.image success:^(id  _Nonnull response) {
//                //
//                NSLog(@"修改用户头像的请求结果%@", response);
//            } failure:^(NSError * _Nonnull error) {}];
//        });
    }
    else
    {
        cell = [AccountCell cellforTableView:tableView];
        NSArray *names = self.menu[indexPath.section];
        AccountCell *firstCell = cell;
        firstCell.cellTitleLabel.text = names[indexPath.row];
        if(self.userModel)
        {
            //设置不同的cell的信息
            AccountCell *accountCell  = (AccountCell *)cell;
            if(indexPath.row == 0)
            {
                accountCell.textField.text = self.userModel.clientUserInfo.name;
                accountCell.delegate = self;
                accountCell.textField.enabled = YES;
                accountCell.textField.placeholder = @"Input your user-name";
                accountCell.aTFLine.hidden = NO;
            }
            else if(indexPath.row == 1)
            {
                 NSString *mylocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLocationKey"];
                if(mylocation.length)
                {
                    accountCell.textField.text = mylocation;
                }
                else
                {
                    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
                    // delayUntilAuthorized 超时时间从什么时候开始计算
                    // true , 从用户选择授权之后开始计算
                    // false, 从执行这个代码开始计算
                    
                    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:5 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                        if(status == INTUHeadingStatusSuccess)
                        {
                            [self geoDECode:currentLocation
                                     resuit:^(NSString *cityName) {
                                         AccountCell *cell = (AccountCell *)[tableView cellForRowAtIndexPath:indexPath];
                                         cell.textField.text = cityName;
                                         
                                         if(cityName.length)
                                         {
                                             [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"kLocationKey"];
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                         }
                                     }];
                        }
                    }];
                }
                
            }
            else if(indexPath.row == 2)
            {
                accountCell.textField.text = self.userModel.email;
            }
        }
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = self.themeColor;
    // setting Cell
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 100.0;
    }
    
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        });
        if(block)
        {
            block(placemark.locality);
        }
    }];
}
#warning 添加一个底部的退出按钮
// Delegate
- (UIView *)createFooterView
{
    FooterView *view = [FooterView footerView];
    view.footerDelegate = self;
    
    return view;
}

- (void)footerViewLogoutButtonClicked:(FooterView *)sender
{
    // 发送请求注销
    
    [HttpTool logoutSessionAction:^(BOOL result)
     {
         // 注销成功
         UIViewController *rootVC = [[HomeLoginViewController alloc] init];
         //rootVC.navigation
         BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:rootVC];
         [UIApplication sharedApplication].keyWindow.rootViewController = nav;
     } failure:^(NSError * _Nonnull error) {
         NSLog(@"%@", error);
     }];
}

-(void)footerViewSaveButtonClicked:(FooterView *)sender
{
    // shez
    if(_isModify == NO) return;
    // 保存用户信息
    //NSString *name = [NSString stringWithFormat:@"修改的次数---%d", arc4random_uniform(100)];
    if([self.currentModifyName isEqualToString:self.userModel.username] || self.currentModifyName.length==0)
    {
        return;
    }
    else
    {
        [MBProgressHUD showSuccess:@"Change name!"];
        [HttpTool modifyUserName:self.currentModifyName success:^(id  _Nonnull responseObject) {
            [self updateCurrentUserInfo];
            [MBProgressHUD hideHUD];
        } failure:^(NSError * _Nonnull error) {[MBProgressHUD hideHUD];}];
    }
}

- (void)uploadToServerImageIcon
{
//    [HttpTool uploadIconImage:self.avatarImage success:^(id  _Nonnull response) {
//        //
//        NSLog(@"修改用户头像的请求结果%@", response);
//        [MBProgressHUD showSuccess:@"Change Avatar"];
//    } failure:^(NSError * _Nonnull error) {}];
    [MBProgressHUD showSuccess:@"change user icon!"];
    
    [HttpTool changeAvatarImage:self.avatarImage params:@{} success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"修改用户头像的请求结果%@", responseObject);
        [self.tableView reloadData];
        [MBProgressHUD showSuccess:responseObject[@"message"]];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark ----
- (void)accountCell:(AccountCell *)cell changeTextField:(UITextField *)textField
{
    //保存编辑的文字到服务器
    self.currentModifyName = textField.text;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.isModify = YES;
    });
}

- (void)updateCurrentUserInfo
{
    [HttpTool currentUserInformationWithSessionAction:^(BOOL state, NSDictionary * _Nonnull data) {
        //
        self.userModel = [UserModel userModelWithDictionary:data];
        [self.tableView reloadData];
    }];
}


@end
