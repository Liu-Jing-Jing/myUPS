//
//  HitoryTitleView.m
//  Natures
//
//  Created by sjty on 2019/7/18.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "HistoryTitleView.h"

@interface HistoryTitleView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)UIView *contentView;

@end

@implementation HistoryTitleView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.contentView];
        
    }
    return self;
}


-(void)setTitle:(NSString *)title{
    _title=title;
    self.titleLabel.text=title;
}

-(void)setImage:(UIImage *)image{
    _image=image;
    self.imageView.image=image;
}


-(UIView *)contentView{
    if (_contentView==nil) {
        _contentView=[[NSBundle mainBundle] loadNibNamed:@"HistoryTitleView" owner:self options:nil].lastObject;
    }
    return _contentView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _contentView.frame=self.bounds;
}

@end
