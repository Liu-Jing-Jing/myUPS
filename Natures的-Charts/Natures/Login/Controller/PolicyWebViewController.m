//
//  PolicyWebViewController.m
//  Natures
//
//  Created by 柏霖尹 on 2019/7/24.
//  Copyright © 2019 com.sjty. All rights reserved.
//

#import "PolicyWebViewController.h"

@interface PolicyWebViewController ()
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation PolicyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Policy";
    UIWebView *webview = [[UIWebView alloc] init];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    webview.scrollView.bounces = NO;
    NSString *htmlStr = [[NSBundle mainBundle] pathForResource:@"Privacy Statement.html" ofType:nil];
    htmlStr = [NSString stringWithContentsOfFile:htmlStr encoding:NSUTF8StringEncoding error:NULL];
    [webview loadHTMLString:htmlStr baseURL:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
