//
//  MessageDetailViewController.h
//  Natures
//
//  Created by 柏霖尹 on 2019/7/22.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

/**
 显示标题字符串
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 显示内容字符串
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


/**
 显示时间字符串
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) MessageModel *msgModel;
@end

NS_ASSUME_NONNULL_END
