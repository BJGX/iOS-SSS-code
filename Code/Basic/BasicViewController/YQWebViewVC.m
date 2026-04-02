//
//  YQWebViewVC.m
//  YQBaseProject
//
//  Created by Cjml on 2020/1/10.
//  Copyright © 2020 Cjml. All rights reserved.
//

#import "YQWebViewVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface YQWebViewVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic ,strong) WKUserContentController *userCC;

@end

@implementation YQWebViewVC

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, PUB_NAVBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, 1)];
        _progressView.backgroundColor = [UIColor whiteColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        _progressView.progressTintColor = [UIColor redColor];
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    
    
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, PUB_NAVBAR_HEIGHT, ScreenWidth, ScreenHeight - PUB_NAVBAR_HEIGHT) configuration:config];
//    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.maximumZoomScale = 1;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.minimumZoomScale = 1;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview: self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    self.userCC = config.userContentController;
    [self.userCC addScriptMessageHandler:self name:@"callAppFunction"];

    if (self.url) {
        
        self.url = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:self.url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    if (self.content) {
        NSString*str = [self adaptWebViewForHtml:self.content];
        [self.webView loadHTMLString:str baseURL:nil];
    }
    if (self.titleString) {
        self.navTitle = self.titleString;
    }
}





- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1)
        {
            WeakSelf;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
             }
                             completion:^(BOOL finished)
             {
                 weakSelf.progressView.hidden = YES;
             }];
        }
    }
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message; {
    
}

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];

}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    

//    [webView evaluateJavaScript:javascript completionHandler:nil];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    if (!self.titleString) {
//       self.title = webView.title;
        [self setNavigationBarTitle:webView.title];
        
    }
    

    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}



// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    decisionHandler(actionPolicy);

}



- (void)dealloc{
    [(WKWebView *)self.view removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.userCC removeScriptMessageHandlerForName:@"callAppFunction"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr{
    NSString *content = [htmlStr stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    NSString *htmls = [NSString stringWithFormat:@"<!DOCTYPE html><html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;color:rgba(98,100,102,1)}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "var $img = document.getElementsByTagName('ql-video');\n"
                       "for(var p in  $video){\n"
                       " $video[p].style.width = '100%%';\n"
                       "$video[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "<div id=\"viewHeight\"></div>"
                       "</body>"
                       "</html>",content];
    return htmls;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



///防止出现webview加载失败的情况,   但是绑定西瓜可能会重复触发,  所以加了isBindAccount 限制
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView

{
    [webView reload];
}





@end
