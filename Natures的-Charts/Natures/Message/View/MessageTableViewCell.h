//
//  MessageTableViewCell.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/20.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, assign, getter=isRead) BOOL readed;
@property (nonatomic, strong) MessageModel *model;

+ (instancetype)cellforTableView:(UITableView *)tableView;
+ (CGFloat)cellHight;
@end

NS_ASSUME_NONNULL_END
