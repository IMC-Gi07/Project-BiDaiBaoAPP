//
//  BDBDiscoveryDetailNewsViewController.m
//  BiDaiBaoAPP
//
//  Created by Tomoxox on 15/6/30.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBDiscoveryDetailNewsViewController.h"
#import "ZXLLoadDataIndicatePage.h"
@interface BDBDiscoveryDetailNewsViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//加载页
@property(nonatomic,weak) ZXLLoadDataIndicatePage *loadDataIndicatePage;
- (void)initNewsDetailWebView;
- (void)loadNewsDetail;

@end

@implementation BDBDiscoveryDetailNewsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"比贷宝";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNewsDetailWebView];
    

    self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    
    [self loadNewsDetail];
}

#pragma mark - Private Methods
- (void)initNewsDetailWebView {
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
}

- (void)loadNewsDetail {
    NSURL *newsDetailUrl = [NSURL URLWithString:_newsDetailURL];
    NSURLRequest *newsURLRequest = [NSURLRequest requestWithURL:newsDetailUrl];
    
    [_webView loadRequest:newsURLRequest];
}

#pragma mark - UIWebView Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_loadDataIndicatePage) {
        [_loadDataIndicatePage hide];

    }
}

@end
