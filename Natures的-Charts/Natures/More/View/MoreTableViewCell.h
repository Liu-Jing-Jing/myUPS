//
//  MoreTableViewCell.h
//  Natures
//
//  Created by sjty on 2019/7/19.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreTableViewCell : UITableViewCell
+cellforTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

@end

NS_ASSUME_NONNULL_END
