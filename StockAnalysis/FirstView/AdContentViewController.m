//
//  AdContentViewController.m
//  StockAnalysis
//
//  Created by try on 2018/10/23.
//  Copyright © 2018年 try. All rights reserved.
//

#import "AdContentViewController.h"
#import <WebKit/WebKit.h>
@interface AdContentViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic)  WKWebView *webView;


@end

@implementation AdContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.webView];

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    if(self.block){
        self.block();
    }
    
}

-(void)starRequest:(NSString *)url{
    [self loadString:url];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(WKWebView*)webView{
    if(nil == _webView){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (void)loadString:(NSString *)str  {
    // 1. URL 定位资源,需要资源的地址
    if(str.length==0){
        [HUDUtil showHudViewTipInSuperView:self.view withMessage:@"无地址输入"];
        return;
    }
    NSString *urlStr = str;
//    if (![str hasPrefix:@"https://"]) {
//        urlStr = [NSString stringWithFormat:@"http://m.baidu.com/s?word=%@", str];
//    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
}

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [HUDUtil showHudViewInSuperView:self.view withMessage:@"请求中……"];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    [HUDUtil showHudViewInSuperView:self.view withMessage:@"内容加载中……"];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
//    self.title = webView.title;
    [HUDUtil hideHudView];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [HUDUtil hideHudViewWithFailureMessage:@"加载失败"];
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
