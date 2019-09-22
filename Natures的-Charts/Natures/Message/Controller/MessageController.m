//
//  MessageController.m
//  Natures
//
//  Created by sjty on 2019/7/10.
//  Copyright © 2019 com.sjty. All rights reserved.
#import "MessageController.h"
#import "MessageTableViewCell.h"
#import "NSDate+Helper.h"
#import "MJRefresh.h"
#import "MessageDetailViewController.h"
#import "UIColor+HW.h"
@interface MessageController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIAlertController *alertView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray<MessageModel *> *msgDatas;
@end

@implementation MessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = [MessageTableViewCell cellHight];
    //self.tabBarItem.badgeValue = @"111";
    //self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self getH]];
    //self.tabBarController.tabBarItem.badgeValue = @"2+";
    [self setupUI];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 找到
//    NSArray *element = [MessageModel findAll].reverseObjectEnumerator.allObjects;
//    self.msgDatas = [NSMutableArray arrayWithArray:element];
//    [self.tableView reloadData];
    
}

- (void)loadMoreData
{
    
    __weak typeof(self) weakSelf = self;
    // 默认请求10条数据
    NSString *updateTime = [self.msgDatas lastObject].createTime;
    NSMutableArray *newMessageData = [NSMutableArray array];
    [HttpTool getUpsMessageListWithLimited:10 newOrOld:OldMessage startTime:updateTime Success:^(id  _Nonnull responseObject) {
        for (NSDictionary *jsonModel in responseObject[@"data"])
        {
            //已经被删除的不用保存到数组中的
            MessageModel *model = [[MessageModel alloc] initWithDictionary:jsonModel];
            if([model.status intValue] != 2) [self.msgDatas addObject:model];
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError* error, NSString * message) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}
- (void)setupData
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *allMsg = [NSMutableArray array];
    
    [HttpTool getUpsMessageListWithStatus:3 Success:^(id  _Nonnull responseObject) {
        for (NSDictionary *jsonModel in responseObject[@"data"])
        {
            //已经被删除的不用保存到数组中的
            MessageModel *model = [[MessageModel alloc] initWithDictionary:jsonModel];
            if([model.status intValue] != 2) [allMsg addObject:model];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.msgDatas removeAllObjects];
        self.msgDatas = allMsg;
        //[weakSelf.msgDatas addObjectsFromArray:allMsg];
        [weakSelf.tableView reloadData];
        [MBProgressHUD showSuccess:@"Refresh Finished" toView:self.view];
    } failure:^(NSError * _Nonnull error, NSString * _Nonnull message) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"Network Error!" toView:self.view];
    }];
}

badgeMarco
-(void)setupUI
{
    
    self.title=@"Message";
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"2C303C"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tableviewBeginEditing)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
        //        __weak typeof(self) weakSelf = self;
//        NSMutableArray *newMsg = [NSMutableArray array];
//
//        [HttpTool getUpsMessageListWithStatus:3 Success:^(id  _Nonnull responseObject) {
//            for (NSDictionary *jsonModel in responseObject[@"data"])
//            {
//                //已经被删除的不用保存到数组中的
//                MessageModel *model = [[MessageModel alloc] initWithDictionary:jsonModel];
//                if([model.status intValue] != 2) [newMsg addObject:model];
//            }
//
//            [weakSelf.tableView.mj_header endRefreshing];
//            [newMsg addObjectsFromArray:self.msgDatas];
//            self.msgDatas = newMsg;
//            //[weakSelf.msgDatas addObjectsFromArray:allMsg];
//            [weakSelf.tableView reloadData];
//            [MBProgressHUD showSuccess:@"Refresh Finished!"];
//        } failure:^(NSError * _Nonnull error, NSString * _Nonnull message) {
//            [weakSelf.tableView.mj_header endRefreshing];
//            [MBProgressHUD showError:@"Network Error!"];
//        }];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 添加刷新控件到上面
    //[footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
    [footer setTitle:@"Loading more data ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    footer.stateLabel.textColor = [UIColor blueColor];
    //self.tableView.mj_footer = footer;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Operation" style:UIBarButtonItemStylePlain target:self action:@selector(markAsReadedAction)];
}

#warning 从服务器获取最新数据
- (void)addNewMessage:(NSNotification *)note
{
    //添加新数据
    MessageModel *model = [[MessageModel alloc] init];
    model.title = [NSString stringWithFormat:@"System Tests"];
    model.icon = @(1);
    model.status = @(0);
    //model.content = @"System Test Detail Message";
    [self.msgDatas insertObject:model
                        atIndex:0];
    [self.tableView reloadData];
    if([model save])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
        
    }
    
    
    [UpsNetworkingTools upsAddNewMessageMode:@[model] success:^(id  _Nonnull responseObject) {
        NSLog(@"Message\n%@", responseObject);
    } failure:^(NSError * _Nonnull error, NSDictionary * _Nonnull message) {
        NSLog(@"添加Message数据失败%d---%@", error.code, message);
    }];

    //model.createDateString = [[NSDate date] convertToMessageFormat]
}

- (void)markAsReadedAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want" message:nil preferredStyle:UIAlertControllerStyleAlert];
//依次创建不同样式的按钮和对应的事件Block,并添加到alertController对象上.
    UIAlertAction* actionDefault = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"titleOne is pressed");
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete readed" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除按钮被点击");
        NSMutableArray *delAllArray = [NSMutableArray array];
        for (MessageModel *delObject in self.msgDatas)
        {
            //判断是否为已经
            if(delObject.status.intValue == 1)
            {
                [delAllArray addObject:delObject.messageID];
            }
        }
        [HttpTool upsDeleteWidthMessageModelID:delAllArray success:^(id  _Nonnull responseObject) {
            //
            NSLog(@"%@", responseObject);
            [MBProgressHUD showMessage:@"Delete successful" toView:self.view];
            
        } failure:^(NSError * _Nonnull error, NSDictionary * _Nonnull message) {
            // sanchu shibai
            [MBProgressHUD showError:@"Delete failed" toView:self.view];
        }];
        
    }];
    
    UIAlertAction* actionDestructive = [UIAlertAction actionWithTitle:@"All read" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"titleTwo is pressed");
        [self.msgDatas makeObjectsPerformSelector:@selector(setMessageReaded)];
        [self.msgDatas makeObjectsPerformSelector:@selector(saveOrUpdate)];
        [self.tableView reloadData];
        //将所有的image设为不高亮
    }];
    
    [alert addAction:actionDestructive];
    [alert addAction:actionDefault];
    [alert addAction:deleteAction];
    self.alertView = alert;
    [self presentViewController:alert animated:YES completion:^{}];
}
#pragma mark - Lazy Init
- (NSMutableArray *)msgDatas
{
    if(_msgDatas == nil)
    {
        _msgDatas = [NSMutableArray array];
    }
    
    return _msgDatas;
}

#pragma mark - TableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Model 取出来
//    MessageModel *selectM = self.msgDatas[indexPath.row];
//    selectM.status = MESSAGE_READED;
//    [selectM update];
//    MessageDetailViewController *msgDetailVC = [[MessageDetailViewController alloc] init];
//    msgDetailVC.title = @"Detail";
//#warning Detail
//    [self.tableView reloadData];
//    if([self currentBadgeValue])
//    {
//        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self currentBadgeValue]];
//    }
//    else
//    {
//        self.navigationController.tabBarItem.badgeValue = nil;
//    }
    [self performSegueWithIdentifier:@"msgDetailSegue" sender:self];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [MessageTableViewCell cellforTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置具体的数据模型
    MessageModel *model = self.msgDatas[indexPath.row];
    cell.model = model;
    // setting Cell
//    cell.titleLabel

    //systemOK    cell.detailLabel
//    cell.timeDetailLabel
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle)
    {
        case UITableViewCellEditingStyleNone:
        {
        }
            break;
        case UITableViewCellEditingStyleDelete:
        {
            //修改数据源，在刷新 tableView
            MessageModel *delObject = [self.msgDatas objectAtIndex:indexPath.row];
            
            //发送删除的网络请求
            if(delObject.messageID && delObject.messageID.length>0){
            [HttpTool upsDeleteWidthMessageModelID:@[delObject.messageID] success:^(id  _Nonnull responseObject) {
                //
                NSLog(@"%@", responseObject);
                
            } failure:^(NSError * _Nonnull error, NSDictionary * _Nonnull message) {
                // sanchu shibai
                [MBProgressHUD showError:message[@"message"]];
            }];
            [self.msgDatas removeObjectAtIndex:indexPath.row];
            //让表视图删除对应的行
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
            break;
        default:
            break;
    }
    
    
}

-(void)tableviewBeginEditing
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

// 改变分割线的长度
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


@end
