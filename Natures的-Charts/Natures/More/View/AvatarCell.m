//
//  AvatarCell.m
//  UPS
//
//  Created by Mark on 2019/8/5.
//  Copyright © 2019年 Mark. All rights reserved.
//

#import "AvatarCell.h"

#define kCornerRadius 33
#define kBorderCornerRadius 35
@interface AvatarCell()
@end

@implementation AvatarCell
+(instancetype)cellforTableView:(UITableView *)tableView
{
    static NSString *ID = @"AvatarCell";
    //1.判断是否存在可重用cell
    AvatarCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        cell.avatarImage.clipsToBounds = YES;
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.height/2;
        cell.avatarImage.clipsToBounds = YES;
        cell.avatarImage.layer.masksToBounds = YES;
    }
    return cell;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.avatarImage.layer.cornerRadius = kCornerRadius;
//    self.iconBackView.layer.cornerRadius = kBorderCornerRadius;
}

@end
