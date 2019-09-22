//
//  DeviceViewCell.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/24.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (instancetype)cellforTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
