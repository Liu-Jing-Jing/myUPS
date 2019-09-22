//
//  AvatarCell.h
//  UPS
//
//  Created by Mark on 2019/8/5.
//  Copyright © 2019年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *avatarImage;
@property (nonatomic, strong) UIImage *iconImage;
@property (weak, nonatomic) IBOutlet UIView *iconBackView;

+(instancetype)cellforTableView:(UITableView *)tableView;
@end
