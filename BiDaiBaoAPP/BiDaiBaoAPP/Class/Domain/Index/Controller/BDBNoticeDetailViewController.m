//
//  BDBNoticeDetailViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/27.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBNoticeDetailViewController.h"
#import "ZXLLoadDataIndicatePage.h"

@interface BDBNoticeDetailViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *noticeDetailWebView;

/**
 *  加载页
 */
@property(nonatomic,weak) ZXLLoadDataIndicatePage *loadDataIndicatePage;


- (void)initNoticeDetailWebView;

- (void)loadNoticeDetail;

@end

@implementation BDBNoticeDetailViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		self.title = @"比贷宝";
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self initNoticeDetailWebView];
	
	//self.navigationController.navigationBarHidden = YES;
	self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
	
	[self loadNoticeDetail];
}

#pragma mark - Private Methods
- (void)initNoticeDetailWebView {
	_noticeDetailWebView.scalesPageToFit = YES;
	_noticeDetailWebView.delegate = self;
} 

- (void)loadNoticeDetail {
	NSURL *noticeDetailUrl = [NSURL URLWithString:_noticeDetailURL];
	NSURLRequest *noticeURLRequest = [NSURLRequest requestWithURL:noticeDetailUrl];
	
	[_noticeDetailWebView loadRequest:noticeURLRequest];
}

#pragma mark - UIWebView Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if (_loadDataIndicatePage) {
		[_loadDataIndicatePage hide];
	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *UID = [userDefaults objectForKey:@"UID"];
	if (!UID || [@"" isEqualToString:UID]) return;
	
	//请求服务器，记录用户读取情况
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
	NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"ReadNews"];
	
	NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
	requestParams[@"Machine_id"] = IPHONE_DEVICE_UUID;
	requestParams[@"Device"] = @"0";
	requestParams[@"UID"] = UID;
	requestParams[@"NewsID"] = _noticeId;
	
	[manager POST:requestURL parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject){} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}


@end
