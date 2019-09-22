//
//  UIButton+CornerButton.m
//  KangNengWear
//
//  Created by liangss on 2017/10/18.
//  Copyright © 2017年 sjty. All rights reserved.
//

#import "UIButton+CornerButton.h"
#import "LSSCommon.h"

@implementation UIButton (CornerButton)

-(void)setRornerLeftBottomOrRightBottom:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight    cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    //[self.layer setBorderColor:color(42, 47, 226).CGColor ];
   // self.layer.masksToBounds = YES;

}

-(void)setRornerLeftTopOrRightTop:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight  cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
   // [self.layer setBorderColor:color(42, 47, 226).CGColor];
   // self.layer.masksToBounds = YES;

}


-(void)setRornerLeftTopOrLeftBottom:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft  cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    //[self.layer setBorderColor:color(42, 47, 226).CGColor];
   // self.layer.masksToBounds = YES;
}


-(void)setRornerRightTopOrRightBottom:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight    cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
   // [self.layer setBorderColor:color(42, 47, 226).CGColor];
   // self.layer.masksToBounds = YES;

}


@end
