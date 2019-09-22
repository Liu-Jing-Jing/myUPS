//
//  MessageTableViewCell.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/20.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "WBBadgeButton.h"
@interface MessageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *msgImage;

@end

@implementation MessageTableViewCell

+ (instancetype)cellforTableView:(UITableView *)tableView
{
    static NSString *ID = @"MessageTableViewCell";
    //1.判断是否存在可重用cell
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    
}
// Setter方法的实现
- (void)setModel:(MessageModel *)model
{
    _model = model;
    if(model)
    {
        //设置模型的属性值//开始显示数据
        self.titleLabel.text = model.title;
        self.detailLabel.text = model.content;
        self.timeDetailLabel.text = model.createTime;
        self.readed = model.status.intValue;
    }
}

- (void)setReaded:(BOOL)readed
{
    _readed = readed;
    
    
    self.msgImage.highlighted = !readed;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


+ (CGFloat)cellHight
{
    return 70.0;
}
@end
