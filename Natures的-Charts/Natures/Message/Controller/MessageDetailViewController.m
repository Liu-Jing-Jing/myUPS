//
//  MessageDetailViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/22.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController


- (void)setMsgModel:(MessageModel *)msgModel
{
    _msgModel = msgModel;
    
    //
    [self updateUIForModel];
}

- (void)updateUIForModel
{
    if(self.msgModel)
    {
        // 设置子控件
        #warning ss
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUIForModel];
    self.view.backgroundColor = kThemeColor;
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
