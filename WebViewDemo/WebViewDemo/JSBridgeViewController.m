//
//  JSBridgeViewController.m
//  WebViewDemo
//
//  Created by OuYang on 17/7/13.
//  Copyright © 2017年 OuYang. All rights reserved.
//

#import "JSBridgeViewController.h"

#import <WebKit/WebKit.h>

#import "WebViewJavascriptBridge.h"


@interface JSBridgeViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic) WKWebView *webView;

@property WebViewJavascriptBridge* bridge;


@end

@implementation JSBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"JSBridge控件";
    
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    [self.view addSubview:_webView];
    
    

    
#pragma mark - 初始化 JSBridge 
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    [_bridge setWebViewDelegate:self];
    
    // 注册JS 并JS回调给OC
    [_bridge registerHandler:@"authAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"authAction: %@", data);
        responseCallback(@"回应authAction");
    }];
    //
    
    [_bridge registerHandler:@"jumpPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"buttonAction: %@", data);
        responseCallback(@"回应buttonAction");
    }];
    
    
    
#pragma mark - 加载数据

    NSURL *path = [[NSBundle mainBundle] URLForResource:@"ExampleApp" withExtension:@"html"];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];

    //[_bridge callHandler:@"showChat"
//                    data:@{@"chat":@"chat"}];
    [_bridge callHandler:@"showChat" data:@{@"chat":@"chat"} responseCallback:^(id responseData) {
       
        NSLog(@"___%@",responseData);
    }];
}

#pragma mark - 页面跳转

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
