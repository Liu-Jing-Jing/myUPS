//
//  NewFeatureViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/9.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "NSLoginViewController.h"
#define NewFeatureImageCount 3
@interface NewFeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *mainScroll;
@end

@implementation NewFeatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
    [self setupPageControl];
}

- (void)setupScrollView
{
    // 添加scrollView
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.frame = [[UIScreen mainScreen] bounds];
    scroll.delegate = self;
    [self.view addSubview:scroll];
    self.mainScroll = scroll;
    // 添加图片
    CGFloat imageH = scroll.frame.size.height;
    CGFloat imageW = scroll.frame.size.width;
    
    for (int index = 0; index < NewFeatureImageCount; ++index) {
        UIImageView *imageView = [[UIImageView alloc]init];
        
        NSString *imageName = nil;
        // 设置图片
        imageName = [NSString stringWithFormat:@"new_feature_%d",index + 1];
            
        
        imageView.image = [UIImage imageNamed:imageName];
        
        // 设置frame
        CGFloat imageX = imageW * index;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scroll addSubview:imageView];
        
        // 最好一张图片添加按钮
        if (index == NewFeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 设置滚动内容
    scroll.contentSize = CGSizeMake(imageW * NewFeatureImageCount, 0);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    // 设置imageView可交互
    imageView.userInteractionEnabled = YES;
    
    // 添加开始按钮
    UIButton *startButton = [[UIButton alloc]init];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    
    // 设置位置尺寸
    CGFloat centerX = imageView.frame.size.width * 0.5;
    CGFloat centerY = imageView.frame.size.height * 0.6;
    startButton.center = CGPointMake(centerX, centerY);
    startButton.bounds = (CGRect){CGPointZero, startButton.currentBackgroundImage.size};
    
    // 设置文字
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
    // 添加checkbox
    UIButton *checkbox = [[UIButton alloc] init];
    checkbox.selected = YES;
    [checkbox setTitle:@"分享给大家" forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    checkbox.bounds = CGRectMake(0, 0, 200, 50);
    CGFloat checkboxCenterX = centerX;
    CGFloat checkboxCenterY = imageView.frame.size.height * 0.5;
    checkbox.center = CGPointMake(checkboxCenterX, checkboxCenterY);
    [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    //    checkbox.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    checkbox.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    //    checkbox.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [imageView addSubview:checkbox];
    
    
}

- (void)setupPageControl
{
    // 添加UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = NewFeatureImageCount;
    
    
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    CGFloat centerY = self.mainScroll.frame.size.height - 50;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 200, 30);
    
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 设置圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 当前位移
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat pageFloat = offsetX/scrollView.frame.size.width;
    
    int pageInt = (int)(pageFloat + 0.5);
    self.pageControl.currentPage = pageInt;
}

// 选择分享
- (void)checkboxClick:(UIButton *)checkbox
{
    checkbox.selected = !checkbox.isSelected;
}

// 开始微博
- (void)start
{
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 切换根控制器
    self.view.window.rootViewController = [[NSLoginViewController alloc]init];
}

@end
