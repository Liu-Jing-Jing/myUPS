//
//  HistoryController.m
//  Natures
//
//  Created by sjty on 2019/7/10.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "HistoryController.h"
#import "HistoryTitleView.h"
#import "HistoryChartViewController.h"
#import "JXCategoryView.h"
#import "UpsModel.h"
#import "NSDate+Helper.h"
#import "UpsNetworkingTools.h"
#import "CWPopMenu.h"
#import "CWPopMenuCell.h"
#import "BleDeviceModel.h"
#define kListName @"bleDeviceList"
// 分隔符试用^
@interface HistoryController ()
<UIViewControllerTransitioningDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet HistoryTitleView *outputHistoryView;
@property (weak, nonatomic) IBOutlet HistoryTitleView *batteryHistoryView;
@property (weak, nonatomic) IBOutlet HistoryTitleView *tempHistoryView;
@property (weak, nonatomic) IBOutlet HistoryTitleView *powerUseHistoryView;
@property (weak, nonatomic) IBOutlet HistoryTitleView *windHistoryView;
@property (nonatomic, strong) NSMutableDictionary *nameDict;
@property (weak, nonatomic) IBOutlet HistoryTitleView *solarHistoryView;
@property (weak, nonatomic) IBOutlet HistoryTitleView *acHistoryView;
@property (nonatomic, strong) NSArray *titleViewNameArray;
@property (nonatomic, strong)CWPopMenu *menu;
@property (nonatomic, strong)NSArray *array;
@property (nonatomic, assign) BOOL isSelectDevice;
@property (nonatomic, strong) NSString *selectID;
@property (nonatomic, assign)CGFloat sumHeight;
//------------------------------数据处理的相关属性
@property (nonatomic, strong) NSMutableArray <UpsModel *>*modelArray;
@end

@implementation HistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.view.backgroundColor = kThemeColor;
//    self.view.backgroundColor = LLColor(28, 36, 51);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择设备" style:UIBarButtonItemStyleDone target:self action:@selector(selectDeviceUUID:)];
    for (UIView *sub in self.view.subviews)
    {
        if([sub isKindOfClass:[HistoryTitleView class]])
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewDidClicked:)];
            [sub addGestureRecognizer:tap];
        }
    }
    
    
    
//    [UpsNetworkingTools getUpsRangeDataWithStartDate:nil endDate:nil success:^(NSArray * _Nonnull response) {
//        NSLog(@"%@", response);
//        for (NSDictionary *dict in response) {
//            UpsModel *upsModel = [[UpsModel alloc] initWithDictionary:dict];
//            [self.modelArray addObject:upsModel];
//        }
//        //NSLog(@"%d", _modelArray.count);
//    } failure:^(NSError * _Nonnull error) {
//        //
//    }];
}

/**
 NSString *dateStr = @"2019-01-01 11:11:11";
 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
 [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
 [formatter setDateFormat:@"MMM dd"];
 for(int i=0;i<365;i++)
 {
 
 NSDate *newDate = [NSDate getDateFromDate:[NSDate convertSJTYServerFormatToNSDateWithStr:dateStr] withDay:i];
 NSString *str = [formatter stringFromDate:newDate];
 printf("\n %s", [str UTF8String]);
 }
*/
- (void)selectDeviceUUID:(UIBarButtonItem *)sender
{
    //NSLog(@"%@", sender.title);
    NSDictionary *nameModels = [[NSUserDefaults standardUserDefaults] valueForKey:kListName];
    if(nameModels.count == 0) return;
    self.menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(self.view.frame.size.width-25, _sumHeight) menuSize:CGSizeMake(130, 44*self.array.count) arrowStyle:CWPopMenuArrowTopfooter];
    
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.menuViewBgColor = [UIColor whiteColor];
    _menu.alpha = 0.1;
    [_menu showMenu:YES];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CWPopMenuCell *cell = [CWPopMenuCell cellWithTableView:tableView];
    cell.labText.text = self.array[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"点击了%@",self.array[indexPath.row]);
    self.selectID = self.nameDict[(NSString *)self.array[indexPath.row]];
    self.navigationItem.rightBarButtonItem.title=(NSString *)self.array[indexPath.row];
    [self.menu closeMenu:NO];
}

-(NSArray *)array
{
    if (!_array)
    {
        self.nameDict = [NSMutableDictionary dictionary];
        NSDictionary *nameModels = [[NSUserDefaults standardUserDefaults] valueForKey:kListName];
        NSMutableArray *names = [NSMutableArray array];
        [nameModels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *name = obj;
            
            if (name)
            {
                if([name componentsSeparatedByString:@"^"].count>1)
                {
                    NSString *uuID =[name componentsSeparatedByString:@"^"][1];
                    
                    name = [[name componentsSeparatedByString:@"^"] firstObject];
                    //找到了存在的蓝牙模块
                    self.nameDict[name] = uuID;
                    [names addObject:name];
                }
            }
            
        }];
        _array = [NSArray arrayWithArray:names.copy];
    }
    return _array;
}


#warning UI
-(void)setupUI
{
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.sumHeight = statusHeight + navHeight;
    
    
    self.title=@"History";
    self.outputHistoryView.image=[UIImage imageNamed:@"history_output"];
    self.outputHistoryView.title=@"Output\nWattage";
    self.outputHistoryView.tag = 1;
    
    self.batteryHistoryView.image=[UIImage imageNamed:@"history_battery"];
    self.batteryHistoryView.title=@" Battery\nVoltage";
    self.batteryHistoryView.tag = 2;
    self.tempHistoryView.image=[UIImage imageNamed:@"history_internal"];
    self.tempHistoryView.title=@"Internal\nTemperature";
    self.tempHistoryView.tag = 3;
    
    self.powerUseHistoryView.image=[UIImage imageNamed:@"history_poweruser"];
    self.powerUseHistoryView.title=@"Power\nUsed";
    self.powerUseHistoryView.tag = 4;
    
    self.solarHistoryView.image=[UIImage imageNamed:@"history_solar"];
    self.solarHistoryView.title=@"Solar\nPanel";
    self.solarHistoryView.tag = 5;
    
    self.windHistoryView.image=[UIImage imageNamed:@"history_wind"];
    self.windHistoryView.title=@"Wind\nGenerator";
    self.windHistoryView.tag = 6;
    
    self.acHistoryView.image=[UIImage imageNamed:@"history_ac"];
    self.acHistoryView.title=@"AC\nCharger";
    self.acHistoryView.tag = 7;
}

- (void)titleViewDidClicked:(UITapGestureRecognizer *)sender
{
    if(self.selectID == nil)
    {
#warning 1111
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Please choose device for check history charts" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // Cancel
        }]];
        
        [self presentViewController:alertVC animated:YES completion:NULL];
    }
    if(self.modelArray == nil)
    {
        [MBProgressHUD showError:@"Error none history data!"];
        return;
    }
    
    if([sender.view isKindOfClass:[HistoryTitleView class]])
    {
        //
        HistoryTitleView *view = (HistoryTitleView *)sender.view;
        NSLog(@"%@", view.title);
#warning 传递模型数据给我
        
        HistoryChartViewController *vc = [[HistoryChartViewController alloc] init];
        vc.title = [view.title stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        UpsModel *test = UpsModel.new;
        NSArray *varNames = [test getAllObjCIvarList];
        for(int i=0;i<self.titleViewNameArray.count;i++)
        {
            if ([view.title isEqualToString:self.titleViewNameArray[i]])
            {
                //传模型
                vc.type = (HistoryType)view.tag;
                vc.modelArray = self.modelArray;
                vc.machineID = self.selectID;
            }
        }
        [self setupHCViewController:vc];
        
        UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationItem.backBarButtonItem=item;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupHCViewController:(HistoryChartViewController *)vc
{
    
    JXCategoryTitleView *titleCategoryView = (JXCategoryTitleView *)vc.categoryView;
    titleCategoryView.titleColorGradientEnabled = NO;
    titleCategoryView.titleLabelMaskEnabled = YES;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorWidthIncrement = 10;
    backgroundView.indicatorHeight = 20;
    titleCategoryView.indicators = @[backgroundView];
}

- (NSArray *)titleViewNameArray
{
    if(_titleViewNameArray == nil)
    {
        _titleViewNameArray =
        @[@"Internal\nTemperature",
          @"Output\nWattage",
          @"",
          @" Battery\nVoltage",
          @"Power\nUsed",
          @"",
          @"",
          @"",
          @"AC\nCharger",
          @"",
          @"",
          @"",
          @"",
          @"",
          @"",
          @"",
          @"",
          @"Wind\nGenerator",
          @"Solar\nPanel"];
    }
    
    return _titleViewNameArray;
}

- (NSMutableArray *)modelArray
{
    if(_modelArray == nil)
    {
        _modelArray = [NSMutableArray arrayWithCapacity:50];
        //        @"Output\nWattage",@" Battery\nVoltage",@"Internal\nTemperature",@"Power\nUsed",@"Solar\nPanel",@"Wind\nGenerator",@"AC\nCharger";
    }
    
    return _modelArray;
}
/*
 
 UpsModel *model = UpsModel.new;
 model.noMean = @"0";
 NSArray* upsPropertys = [model getAllObjCIvarList];
 upsPropertys = [upsPropertys subarrayWithRange:NSMakeRange(0, 24)];
 NSString *str = @"107,419,2017-07-31 13:59:07,14.1,0,1,0,1,0,0,0,0,0,1,0,0,0,0,1,0,3,5,08:7C:BE:CA:BC:22, 1";
 NSArray *strArray = [str componentsSeparatedByString:@","];
 for(int i=0;i<upsPropertys.count;i++)
 {
 if(i>4&&i<23)
 {
 NSString *num = [NSString stringWithFormat:@"%d", arc4random_uniform(9)+1];
 NSString * value = num.add(strArray[i]);
 [model setValue:value forKey:upsPropertys[i]];
 }
 else
 {
 NSString * value = strArray[i];
 [model setValue:value forKey:upsPropertys[i]];
 }
 }
 
 model.str = str;
 //    for(int i=0;i<10;i++)
 //    {
 //        model.createTime = [[NSDate dateWithTimeIntervalSinceNow:86400] convertToSJTYServerFormat];
 //        [HttpTool postUPSDataToServer:model success:^(NSArray * _Nonnull response) {
 //            //
 //            NSLog(@"---------------UPDAte UPS");
 //        } failure:^(NSError * _Nonnull error) {}];
 //    }
 */
@end
