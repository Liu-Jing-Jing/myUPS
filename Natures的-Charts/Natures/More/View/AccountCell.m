//
//  AccountCell.m
//  UPS
//
//  Created by Mark on 2019/8/4.
//  Copyright © 2019年 Mark. All rights reserved.
//

#import "AccountCell.h"
#import "UIColor+HW.h"
@interface AccountCell()<UITextFieldDelegate>
@end
@implementation AccountCell
+(instancetype)cellforTableView:(UITableView *)tableView
{
    static NSString *ID = @"AccountCell";
    //1.判断是否存在可重用cell
    AccountCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.backgroundColor = [UIColor colorWithHexString:@"2C303C"];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    //__weak typeof(self) weakSelf = cell;
    cell.textField.delegate = cell;
    [cell.textField addTarget:cell action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    NSLog(@"textField - 正在编辑, 当前输入框内容为: %@", textField.text);
    // 通知代理我在修改内容
    
    if([self.delegate respondsToSelector:@selector(accountCell:changeTextField:)])
    {
        [self.delegate accountCell:self changeTextField:textField];
        // 开始编辑文字
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
