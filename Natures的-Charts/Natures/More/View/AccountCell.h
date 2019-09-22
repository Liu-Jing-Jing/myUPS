//
//  AccountCell.h
//  UPS
//
//  Created by Mark on 2019/8/4.
//  Copyright © 2019年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountCell;
@protocol AccountCellDelegate<NSObject>
@required
- (void)accountCell:(AccountCell *)cell changeTextField:(UITextField *)textField;
@end

@interface AccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *aTFLine; // 显示编辑状态的view
@property (nonatomic, assign) BOOL beginEdit;
@property (nonatomic, weak) id<AccountCellDelegate> delegate;
+(instancetype)cellforTableView:(UITableView *)tableView;
@end
