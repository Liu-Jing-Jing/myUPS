//
//  MDPieView.h
//  MDPieView
//
//  Created by wenchao zeng on 2016/10/31.
//  Copyright © 2016年 wenchao zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPieView : UIView
-(instancetype)initWithFrame:(CGRect)frame andPercent:(float)percent andColor:(UIColor *)color;
-(void)reloadViewWithPercent:(float)percent;
@end
