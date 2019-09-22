//
//  MoreController.m
//  Natures
//
//  Created by sjty on 2019/7/10.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MoreController.h"
#import "MoreTableViewCell.h"
#import "AccountViewController.h"
#import "AboutController.h"
#import "FeedBackController.h"
#import "UserModel.h"
#import "MyWeatherViewController.h"
#import "UIImageView+WebCache.h"
#import "DetailWebViewController.h"
#import "UnsyncUPSModel.h"
@interface MoreController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *leftImageArray;
@property (nonatomic, strong) NSString *iconUrlString;
// 用户模型数据
@property (nonatomic, strong) UserModel *currentUser;
@end



@implementation MoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.view.backgroundColor = kThemeColor;
    // data
    
    __weak typeof(self) weakSelf = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)setupUI{
    self.title=@"More";
    self.moreTableView.delegate=self;
    self.moreTableView.dataSource=self;
    
    self.moreTableView.backgroundColor=[UIColor clearColor];
    self.moreTableView.separatorColor=[UIColor blackColor];
    self.titleArray=@[@"My Profile",@"About",@"Contact Us",@"FAQ",@"Feedback",@"Privacy Statement",@"Store",@"Unsynced History Data"];
    self.leftImageArray= [NSMutableArray arrayWithArray:@[@"me_kong",@"icon_about",@"icon_contactus",@"icon_faq",@"icon_feedback",@"icon_yinsi",@"icon_store",@"icon_synchronize"]];
    
}

- (void)setCurrentUser:(UserModel *)currentUser
{
    _currentUser = currentUser;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreTableViewCell *cell=[MoreTableViewCell cellforTableView:tableView];
    cell.cellTitleLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.cellTitleLabel.text=self.titleArray[indexPath.row];
    if(indexPath.row !=0)
    {
        cell.leftImageView.image=[UIImage imageNamed:self.leftImageArray[indexPath.row]];
        cell.leftImageView.layer.cornerRadius = 0;
    }
    else
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"My Profile";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = UIColor.clearColor;
        //cell.imageView.image = [UIImage imageNamed:@"avatar.jpg"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==1)
    {
        AboutController *aboutController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutController"];
        self.hidesBottomBarWhenPushed=YES;
        aboutController.title=self.titleArray[indexPath.row];
        UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:aboutController animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    else if(indexPath.row==2)
    {
        // CONTANCT 我们
        DetailWebViewController *webVC = [[DetailWebViewController alloc] init];
        webVC.title = @"Contact Us";
        webVC.url = [NSURL URLWithString:@"https://naturesgenerator.com/pages/contact-us"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if(indexPath.row==3)
    {
//        FAQ
        
        DetailWebViewController *webVC = [[DetailWebViewController alloc] init];
        webVC.title = @"FAQ";
        webVC.url = [NSURL URLWithString:@"https://naturesgenerator.com/apps/help-center"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if(indexPath.row==4)
    {
        // Feedback
        
    }
    else if(indexPath.row==5)
    {
        //Privacy
        DetailWebViewController *webVC = [[DetailWebViewController alloc] init];
        webVC.title = @"Privacy Statement";
        webVC.url = [NSURL URLWithString:@"https://naturesgenerator.com/pages/terms-of-use"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if(indexPath.row==6)
    {
        // Store页面
        DetailWebViewController *webVC = [[DetailWebViewController alloc] init];
        webVC.title = @"Store";
        webVC.url = [NSURL URLWithString:@"https://naturesgenerator.com/collections/all"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if (indexPath.row==7)
    {
        // 手动点击了同步历史的按钮
        NSArray *unsyncModels = [UnsyncUPSModel findAll];
        UnsyncUPSModel *firstM = [unsyncModels firstObject];
        if([firstM.historyString isEqualToString:@"feef010f41adfddf"])
        {
            [MBProgressHUD showSuccess:@"云同步完成"];
        }
        else if(unsyncModels.count == 0)
        {
            [MBProgressHUD showSuccess:@"No Data"];
        }
        
    }
    else
    {
        AccountViewController *webController=[[AccountViewController alloc] init];
        [self.navigationController pushViewController:webController animated:YES];
        //加载用户头像的模块
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HttpTool currentUserInformationWithSessionAction:^(BOOL state, NSDictionary *  data) {
                //
                [MBProgressHUD hideHUD];
                UserModel *user = [UserModel userModelWithDictionary:data];
                self.iconUrlString = user.portrait;
                weakSelf.currentUser = user;
                
                if(weakSelf.currentUser) webController.userModel = weakSelf.currentUser;
                webController.title=weakSelf.titleArray[indexPath.row];
                
                weakSelf.hidesBottomBarWhenPushed=NO;
            }];
        });
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) return 70.0;
    return 60.0;
}

@end
