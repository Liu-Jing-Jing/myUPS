//
//  UIButton+CornerButton.h
//  KangNengWear
//
//  Created by liangss on 2017/10/18.
//  Copyright © 2017年 sjty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CornerButton)

-(void)setRornerLeftBottomOrRightBottom:(CGSize)size;

-(void)setRornerLeftTopOrRightTop:(CGSize)size;


-(void)setRornerLeftTopOrLeftBottom:(CGSize)size;


-(void)setRornerRightTopOrRightBottom:(CGSize)size;

@end
