//
//  AccountTableViewCell.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/3.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell
+(id)cellforTableView:(UITableView *)tableView
{
    static NSString *ID = @"AccountTableViewCell";
    //1.判断是否存在可重用cell
    AccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
