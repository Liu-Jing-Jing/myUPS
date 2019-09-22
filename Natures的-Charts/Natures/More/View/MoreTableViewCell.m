//
//  MoreTableViewCell.m
//  Natures
//
//  Created by sjty on 2019/7/19.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

+(id)cellforTableView:(UITableView *)tableView
{
    static NSString *ID = @"MoreTableViewCell";
    //1.判断是否存在可重用cell
    MoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
    }
    return cell;
}

@end
