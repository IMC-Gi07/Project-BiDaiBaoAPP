//
//  BDBSubjectDetailWebViewController.m
//  BiDaiBaoAPP
//
//  Created by zhang xianglu on 15/7/10.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectDetailWebViewController.h"

@interface BDBSubjectDetailWebViewController () <UIWebViewDelegate,UIAlertViewDelegate>

@property(nonatomic,weak) UIWebView *subjectDetailWebView;

@property(nonatomic,weak)  ZXLLoadDataIndicatePage *loadDataIndicatePage;

@end

@implementation BDBSubjectDetailWebViewController

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.title = @"比贷宝";
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIWebView *subjectDetailWebView = [[UIWebView alloc] init];
	subjectDetailWebView.delegate = self;
	subjectDetailWebView.scalesPageToFit = YES;
	[self.view addSubview:subjectDetailWebView];
	self.subjectDetailWebView = subjectDetailWebView;
	
	_subjectDetailWebView.translatesAutoresizingMaskIntoConstraints = NO;
	
	for (NSString *visulaFormat in @[@"H:|[subjectDetailWebView]|",@"V:|[subjectDetailWebView]|"]) {
		NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visulaFormat options:0 metrics:nil views:@{@"subjectDetailWebView":subjectDetailWebView}];
		[self.view addConstraints:constraints];
	}
	
	NSURLRequest *subjectDetailRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_subjectDetailURL]];
	[_subjectDetailWebView loadRequest:subjectDetailRequest];
	
	self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if ([webView.request.URL.absoluteString isEqualToString:_subjectDetailURL]) {
		[_loadDataIndicatePage hide];
	}else {
		[webView reload];	
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"页面加载失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
