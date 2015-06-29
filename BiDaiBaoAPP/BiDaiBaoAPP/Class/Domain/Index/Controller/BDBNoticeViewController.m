//
//  BDBNoticeViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/15.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBNoticeViewController.h"
#import "BDBNoticeTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FLAnimatedImage.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBNoticeResponseModel.h"
#import "BDBNoticeDetailViewController.h"

@interface BDBNoticeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *noticeTableView;

/**
 公告数据
 */
@property(nonatomic,strong) NSMutableArray *noticeModels;

/**
 公告页数
 */
@property(nonatomic,assign) NSUInteger pageIndex;

/**
 每页显示数量
 */
@property(nonatomic,assign) NSUInteger pageSize;


@property(nonatomic,weak) ZXLLoadDataIndicatePage *

indicatePage;

/**
 *  用户点击的公告
 */
@property(nonatomic,strong) NSIndexPath *selectedModelIndexPath;


/**
 *  加载数据
 */
- (void)loadMoreDatas;

/**
 * 刷新数据
 */
- (void)refreshDatas;

/**
 初始化noticeTableView
 */
- (void)initNoticeTableView;

@end

@implementation BDBNoticeViewController

#pragma mark - LifeCycle Methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		self.title = @"公告";
		//push时，隐藏底部tabbar
		self.hidesBottomBarWhenPushed = YES;
		
		self.pageSize = 10;
		
		//self.edgesForExtendedLayout = UIRectEdgeNone;
		//self.automaticallyAdjustsScrollViewInsets = NO;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self initNoticeTableView];
	
	self.navigationController.navigationBarHidden = YES;
	self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
	
	[self refreshDatas];
}


#pragma mark - Private Methods
- (void)loadMoreDatas {
	self.pageIndex ++;
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNotice"];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	parameters[@"Device"] = @"0";
	parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",
	(unsigned long)_pageIndex];
	parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",(unsigned long)_pageSize];
	
	[manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

		ZXLLOG(@"success response: %@",responseObject);
	 
		BDBNoticeResponseModel *noticeResponseModel = [BDBNoticeResponseModel objectWithKeyValues:responseObject];
		
		//将更多的数据，追加到数组后面
		[_noticeModels addObjectsFromArray:noticeResponseModel.NoticeList];
		
		//刷新完数据后，回收头部
		[_noticeTableView.footer endRefreshing];
		
		//如果tableview已经存在，则重新加载数据
		[_noticeTableView reloadData];
	 
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 ZXLLOG(@"error response: %@",error);
	 }];
}

- (void)refreshDatas {
	//刷新数据时，页数改为1
	self.pageIndex = 1;
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
	NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNotice"];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	parameters[@"Device"] = @"0";
	parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
	parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
	
	[manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		//ZXLLOG(@"success response: %@",responseObject);
	
		BDBNoticeResponseModel *noticeResponseModel = [BDBNoticeResponseModel objectWithKeyValues:responseObject];
		
		self.noticeModels = noticeResponseModel.NoticeList;
		
		if (_indicatePage) {
			[_indicatePage hide];
			self.navigationController.navigationBarHidden = NO;
		}else {
			[_noticeTableView.header endRefreshing];
		}
		
		[_noticeTableView reloadData];

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		//ZXLLOG(@"error response: %@",error);
	}];
}

- (void)initNoticeTableView {
	_noticeTableView.estimatedRowHeight = 50;
	
	[_noticeTableView registerNib:[UINib nibWithNibName:@"BDBNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BDBNoticeTableViewCell"];
	
	__weak typeof(self) thisInstance = self;
	
	//初始化表头部
	_noticeTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
		//刷新数据
		[thisInstance refreshDatas];
	}];
	
	//初始化表尾部
	_noticeTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
		//加载更多数据
		[thisInstance loadMoreDatas];
	}];
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _noticeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"BDBNoticeTableViewCell";
	
	BDBNoticeTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	
	BDBNoticeModel *noticeModel = _noticeModels[indexPath.row];
	
	tableViewCell.titleLabel.text = noticeModel.FirstSection;
	tableViewCell.pubTimeLabel.text = noticeModel.DT; 
	
	return tableViewCell;
}

#pragma mark - UITableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [_noticeTableView fd_heightForCellWithIdentifier:@"BDBNoticeTableViewCell" configuration:^(BDBNoticeTableViewCell *cell) {
		BDBNoticeModel *noticeModel = _noticeModels[indexPath.row];
		
		cell.titleLabel.text = noticeModel.FirstSection;
		cell.pubTimeLabel.text = noticeModel.DT; 
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedModelIndexPath = indexPath;

	[self performSegueWithIdentifier:@"ToNoticeDetailViewControllerSegue" sender:self];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([@"ToNoticeDetailViewControllerSegue" isEqualToString:segue.identifier]) {
		BDBNoticeModel *selectedNoticeModel = _noticeModels[_selectedModelIndexPath.row];
	
		BDBNoticeDetailViewController *noticeDetailViewController = segue.destinationViewController;
		noticeDetailViewController.noticeDetailURL = selectedNoticeModel.DetailURL;
	}
}



@end
