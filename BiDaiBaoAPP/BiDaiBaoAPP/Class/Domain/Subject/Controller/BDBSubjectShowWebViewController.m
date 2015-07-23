//
//  BSBSujectShowWebViewController.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectShowWebViewController.h"

#import "ZXLLoadDataIndicatePage.h"
/**
 *  web页面
 */
@interface BDBSubjectShowWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;

@end

@implementation BDBSubjectShowWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webURL]]];
    
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    if(_indicatePage != nil){
    
        [_indicatePage hide];
    }
}

@end
