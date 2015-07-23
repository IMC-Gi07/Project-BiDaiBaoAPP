//
//  BDBUserWebViewController.m
//  BiDaiBaoAPP
//
//  Created by Carrie's baby on 15/7/13.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserWebViewController.h"

@interface BDBUserWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) ZXLLoadDataIndicatePage *indicatePage;

@end

@implementation BDBUserWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView.delegate = self;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.banker888.com"]]];
    
   _indicatePage =  [ZXLLoadDataIndicatePage showInView:self.view];
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
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicatePage hide];

}
@end
