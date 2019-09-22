//
//  MDPieView.m
//  MDPieView
//
//  Created by wenchao zeng on 2016/10/31.
//  Copyright © 2016年 wenchao zeng. All rights reserved.
//

#import "MDPieView.h"

#define LINE_WIDTH 10//环形宽度
#define DURATION 1.0//动画时间
#define TEXT_FONT 8.f

@interface MDPieView()

@property (nonatomic,assign) float      percent;
@property (nonatomic,assign) float      radius;
@property (nonatomic,assign) CGPoint    centerPoint;
@property (nonatomic,strong) UIColor    *lineColor;

@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CATextLayer  *textLayer;
@property (nonatomic,strong) CAShapeLayer *pointLayer;
@end

@implementation MDPieView

-(instancetype)initWithFrame:(CGRect)frame andPercent:(float)percent andColor:(UIColor *)color{
    if(self = [super initWithFrame:frame]) {
        self.percent = percent;
        self.radius = CGRectGetWidth(frame) / 2.0 - LINE_WIDTH / 2.0;
        self.lineColor = color;
        self.centerPoint = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetWidth(frame) / 2.0);
        [self createBackLine];
        [self commonInit];
    }
    return self;
}

-(void)setPercent:(float)percent {
    if (percent >= 1) {
        _percent = 1;
    }else {
        _percent = percent;
    }
}

-(void)reloadViewWithPercent:(float)percent {
    self.percent = percent;
    [self.layer removeAllAnimations];
    [self.lineLayer removeFromSuperlayer];
    [self.pointLayer removeFromSuperlayer];
    [self.textLayer removeFromSuperlayer];
    [self commonInit];
}

-(void)commonInit {
    [self createPercentLayer];
    [self createPointLayer];
//    [self setPercentTextLayer];
}

-(void)createBackLine {
    //绘制背景
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = LINE_WIDTH;
    shapeLayer.strokeColor = [self.lineColor CGColor];
    shapeLayer.opacity = 0.2;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath new];
    [path addArcWithCenter:self.centerPoint radius:self.radius startAngle:-M_PI / 2.0 endAngle:M_PI / 2 * 3 clockwise:YES];
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
}

-(void)createPercentLayer {
    //绘制环形
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.lineWidth = LINE_WIDTH;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.strokeColor = [self.lineColor CGColor];
    self.lineLayer.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *path = [UIBezierPath new];
    [path addArcWithCenter:self.centerPoint radius:self.radius startAngle:-M_PI / 2.0 endAngle:M_PI * 2 * self.percent - M_PI / 2.0 clockwise:YES];
    self.lineLayer.path = path.CGPath;
    CABasicAnimation *showAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    showAnimation.fromValue = @0;
    showAnimation.toValue = @1;
    showAnimation.duration = DURATION;
    showAnimation.removedOnCompletion = YES;
    showAnimation.fillMode = kCAFillModeForwards;
    [self.layer addSublayer:self.lineLayer];
    [self.lineLayer addAnimation:showAnimation forKey:@"kClockAnimation"];
}


-(void)createPointLayer {
    //头部小白点
    self.pointLayer = [CAShapeLayer layer];
    self.pointLayer.lineWidth = 1;
    self.pointLayer.strokeColor = [[UIColor whiteColor] CGColor];
    self.pointLayer.fillColor = [[UIColor whiteColor] CGColor];
    UIBezierPath *path = [UIBezierPath new];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2.0, LINE_WIDTH / 2.0) radius:1 startAngle:- M_PI / 2.0 endAngle:M_PI / 2.0 * 3 clockwise:YES];
    self.pointLayer.path = path.CGPath;
    [self.layer addSublayer:self.pointLayer];
}

-(void)setPercentTextLayer {
    self.textLayer = [CATextLayer layer];
    self.textLayer.contentsScale = [[UIScreen mainScreen] scale];
    self.textLayer.string = [NSString stringWithFormat:@"%.2f%%",self.percent * 100];
    self.textLayer.bounds = self.bounds;
    self.textLayer.font = (__bridge CFTypeRef _Nullable)(@"HiraKakuProN-W3");
    self.textLayer.fontSize = TEXT_FONT;
    self.textLayer.alignmentMode = kCAAlignmentCenter;
    self.textLayer.position = CGPointMake(self.centerPoint.x, self.centerPoint.y + self.radius);
    self.textLayer.foregroundColor =
    [UIColor blackColor].CGColor;
    [self.layer addSublayer:self.textLayer];
}

@end
