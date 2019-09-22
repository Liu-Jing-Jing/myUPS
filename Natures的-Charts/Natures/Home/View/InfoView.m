//
//  InfoView.m
//  Natures
//
//  Created by sjty on 2019/7/18.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "InfoView.h"

@interface InfoView()
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;


@end

@implementation InfoView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.bgImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_bgImageView];
    self.bgImageView.layer.masksToBounds=YES;
    self.bgImageView.layer.shadowRadius=2;
    self.bgImageView.layer.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
//    self.bgImageView.layer.shadowOffset=CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.1, self.frame.size.width, self.frame.size.height*0.4)];
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.6, self.frame.size.width, self.frame.size.height*0.4)];
    [self addSubview:self.subTitleLabel];
    
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    
    self.subTitleLabel.textAlignment=NSTextAlignmentCenter;
    self.subTitleLabel.textColor=[UIColor whiteColor];
    self.subTitleLabel.font=[UIFont systemFontOfSize:13];
    
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text=title;
}


-(void)setSubTitle:(NSString *)subTitle{
    self.subTitleLabel.text=subTitle;
}

-(void)setBgImage:(UIImage *)bgImage{
    self.bgImageView.image=bgImage;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    self.bgImageView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLabel.frame=CGRectMake(0, self.frame.size.height*0.15, self.frame.size.width, self.frame.size.height*0.4);
    self.subTitleLabel.frame=CGRectMake(0, self.frame.size.height*0.6, self.frame.size.width, self.frame.size.height*0.4);
    
}



@end
