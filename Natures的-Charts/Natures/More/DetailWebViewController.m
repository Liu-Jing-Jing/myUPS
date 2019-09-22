//
//  DetailWebViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/8/5.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "DetailWebViewController.h"

@interface DetailWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DetailWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = self.theme
    // Do any additional setup after loading the view from its nib.
    UIWebView *contentWebView = [[UIWebView alloc] init];
    [self.view addSubview:contentWebView];
    
    [contentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    self.view.backgroundColor = self.themeColor;
    //  得到请求的路径
    self.webView = contentWebView;
    self.webView.hidden = YES;
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    [self.spinner startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.spinner stopAnimating];
    [self.webView stopLoading];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"alert('test')"];
    [self.spinner stopAnimating];
    self.webView.hidden = NO;
}

#pragma mark - Navigation

@end
