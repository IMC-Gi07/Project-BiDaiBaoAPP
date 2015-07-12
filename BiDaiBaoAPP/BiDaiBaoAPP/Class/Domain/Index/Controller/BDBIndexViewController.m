//
//  BDBMainTableViewController.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/17.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBIndexViewController.h"
#import "BDBSortTableViewCell.h"
#import "BDBDetailedMessageTableViewCell.h"
#import "BDBParameterTableViewCell.h"
#import "BDBIndexGuideMessageResponseModel.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBWebAnnouncementResponseModel.h"
#import "BDBIndexTableViewHeader.h"
#import "BDBNoticeModel.h"
#import "BDBIndexClassifyParticularMessageResponseModel.h"
#import "BDBIndexClassifyParticularMessageModel.h"
#import "BBCyclingLabel.h"
#import "BDBMessageTableViewCell.h"
#import "BDBNoticeDetailViewController.h"
#import "BDBSubjectDetailWebViewController.h"




@interface BDBIndexViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *indexPaths;

@property(nonatomic,strong) NSMutableArray  *indexClassifyParticularMessageModels;

@property(nonatomic,strong) BDBIndexGuideMessageResponseModel *indexModel;

@property(nonatomic,strong) NSMutableArray *noticeModels;

@property(nonatomic,strong) NSMutableArray *ParticularModel;

@property (weak, nonatomic) IBOutlet UITableView *IndexTableView;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *loadDataIndicatePage;

/**
 *	表格头部视图
 */
@property(nonatomic,strong) BDBIndexTableViewHeader *indexTableViewHeader;

/**
 每页显示数量
 */
@property(nonatomic,assign) NSUInteger pageSize;

@property(nonatomic,assign) NSUInteger PageInDex;

//用于判断点击到了那个View的手势
@property(nonatomic,assign) NSUInteger judge;

/**
 *  记录公告所处的cell位置
 */
@property(nonatomic,strong) NSIndexPath *noticeCellIndexPath;

/**
 * 	缓存数据库连接实例
 */
@property(nonatomic,strong) FMDatabaseQueue *dbQueue;



- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem;

/**
 *	初始化表格视图
 */
- (void)initIndexTableView;

/**
 *  根据状态刷新标的
 */
- (void)refreshWorthyBids;
/**
 *  刷新标的数据
 */
- (void)refreshWorthyBidsWithMinAnnualEarnimgs:(NSString *)minAnnualEarnimgs maxAnnualEarnimgs:(NSString *)maxAnnualEarnimgs;

/**
 *	根据状态追加更多标的数据
 */
- (void)appendWorthyBids;
/**
 *  追加更多标的数据
 */
- (void)appendWorthyBidsWithMinAnnualEarnimgs:(NSString *)minAnnualEarnimgs maxAnnualEarnimgs:(NSString *)maxAnnualEarnimgs;


/**
 *  切换选项背景
 */
- (void)rgyView:(BDBSortTableViewCell *)sortTableViewCell changedByJude:(NSUInteger)jude;



//加载公告引导信息
- (void)loadNoticeGuideMessage;

//加载公告信息
- (void)loadNoticeMessage;
 
/**
 *	隐藏界面头部
 */
- (void)hideIndexTableViewHeader; 

/**
 *	初始化数据库缓存
 */
- (void)initDBCache;

@end

@implementation BDBIndexViewController

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = @"比贷宝";
        self.pageSize = 10;
        self.judge = 0;
        self.indexPaths = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *rightBarButtonImage = [UIImageWithName(@"index_nav_right") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickedAction:)];
	
	//初始化表视图
	[self initIndexTableView];
	
	//初始化缓存
	[self initDBCache];
	
	//刷新标的列表信息
	[self refreshWorthyBids];
   
   	//加载公告信息
    [self loadNoticeMessage];
	
    [self loadNoticeGuideMessage];
   
    //显示加载页面
    self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];

}


#pragma mark - Private Methods
- (void)initDBCache {
	self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[CACHE_DIRECTORY stringByAppendingPathComponent:BDBGlobal_CacheDatabaseName]];
	
	if (_dbQueue) {
		[_dbQueue inDatabase:^(FMDatabase *db) {
			//标的列表t_bid
			NSString *sql = @"CREATE TABLE IF NOT EXISTS t_bid(rowid INTEGER PRIMARY KEY AUTOINCREMENT,bidid TEXT,bidname TEXT,amount TEXT,term TEXT,biddt TEXT,schedule TEXT,detailurl TEXT,annualearnings REAL,platformname TEXT,progresspercent TEXT)";
			[db executeUpdate:sql];
			
			//公告t_notice
			sql = @"CREATE TABLE IF NOT EXISTS t_notice(rowid INTEGER PRIMARY KEY AUTOINCREMENT,newsid TEXT,publisher TEXT,dt TEXT,title TEXT,firstsection TEXT,detailurl TEXT)";
			[db executeUpdate:sql];
			
			//数据统计t_realtimestatistics
			sql = @"CREATE TABLE IF NOT EXISTS t_realtimestatistics(rowid INTEGER PRIMARY KEY AUTOINCREMENT,amountremain TEXT,bidnum TEXT,earningsmax TEXT,bidamount TEXT,investornum TEXT)";
			[db executeUpdate:sql];
		}];	
	}
}


- (void)loadNoticeGuideMessage {
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //GetRealTimeStatistics主机地址
    NSString *realTimeStatisticsUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetRealTimeStatistics"];
    NSMutableDictionary *realTimeStatisticsDict = [NSMutableDictionary dictionary];
	
    realTimeStatisticsDict[@"PlatFormID"] = @"-1";
    realTimeStatisticsDict[@"Device"] = @"0";
    realTimeStatisticsDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    
    [manager POST:realTimeStatisticsUrl parameters:realTimeStatisticsDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBIndexGuideMessageResponseModel *indexResponseModel = [BDBIndexGuideMessageResponseModel objectWithKeyValues:responseObject];
        self.indexModel = indexResponseModel;
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[_dbQueue inDatabase:^(FMDatabase *db) {
				//清空旧数据
				NSString *sql = @"DELETE FROM t_realtimestatistics";
				[db executeUpdate:sql];
				
				//插入新数据
				sql = @"INSERT INTO t_realtimestatistics(amountremain,bidnum,earningsmax,bidamount,investornum) VALUES(:amountremain,:bidnum,:earningsmax,:bidamount,:investornum)";
				
				NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
				sqlParameters[@"amountremain"] = _indexModel.AmountRemain;
				sqlParameters[@"bidnum"] = _indexModel.BidNum;
				sqlParameters[@"earningsmax"] = @(_indexModel.EarningsMax);
				sqlParameters[@"bidamount"] = _indexModel.BidAmount;
				sqlParameters[@"investornum"] = _indexModel.InvestorNum;
				
				[db executeUpdate:sql withParameterDictionary:sqlParameters];
			}];
		});
		
		NSIndexPath *realTimeStatisticsCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
		
        [self.IndexTableView reloadRowsAtIndexPaths:@[realTimeStatisticsCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[_dbQueue inDatabase:^(FMDatabase *db) {
			NSString *sql = @"SELECT * FROM t_realtimestatistics";
			FMResultSet *resultSet = [db executeQuery:sql];
			
			BDBIndexGuideMessageResponseModel *indexResponseModel = [[BDBIndexGuideMessageResponseModel alloc] init];
			while ([resultSet next]) {
				indexResponseModel.AmountRemain = [resultSet stringForColumn:@"amountremain"];
				indexResponseModel.BidNum = [resultSet stringForColumn:@"bidnum"];
				indexResponseModel.EarningsMax = [resultSet doubleForColumn:@"earningsmax"];
				indexResponseModel.BidAmount = [resultSet stringForColumn:@"bitamount"];
				indexResponseModel.InvestorNum = [resultSet stringForColumn:@"investornum"];
			}
			
			self.indexModel = indexResponseModel;
			
			NSIndexPath *realTimeStatisticsCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
			[self.IndexTableView reloadRowsAtIndexPaths:@[realTimeStatisticsCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
		}];
	}];

}

- (void)loadNoticeMessage {
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    //GetNotice主机地址
    NSString *noticeUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNotice"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	NSUserDefaults *userDfaults = [NSUserDefaults standardUserDefaults];
	
	NSString *UID = [userDfaults objectForKey:@"UID"];
    if (UID && ![UID isEqualToString:@""]) {
        parameters[@"UID"] = UID;
    }
    
	NSString *PSW = [userDfaults objectForKey:@"PSW"];
    if (PSW && ![PSW isEqualToString:@""]) {
        parameters[@"PSW"] = PSW;
    }
	
    parameters[@"UserType"] = @"0";
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    parameters[@"PageIndex"] = @1;
    parameters[@"PageSize"] = @5;
    
    [manager POST:noticeUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBWebAnnouncementResponseModel *announcementResponseModel = [BDBWebAnnouncementResponseModel objectWithKeyValues:responseObject];
        self.noticeModels = [announcementResponseModel.NoticeList mutableCopy];
		
		if (_noticeModels.count > 0) {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[_dbQueue inDatabase:^(FMDatabase *db) {
					//清空记录
					NSString *sql = @"DELETE FROM t_notice";
					[db executeUpdate:sql];
				
					//将新加载的每一项记录插入表中
					[_noticeModels enumerateObjectsUsingBlock:^(BDBNoticeModel *noticeModel, NSUInteger idx, BOOL *stop) {
						NSString *sql = @"INSERT INTO t_notice(newsid,publisher,dt,title,firstsection,detailurl) VALUES(:newsid,:publisher,:dt,:title,:firstsection,:detailurl)";
						
						NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
						sqlParameters[@"newsid"] = noticeModel.NewsID;
						sqlParameters[@"publisher"] = noticeModel.Publisher;
						sqlParameters[@"dt"] = noticeModel.DT;
						sqlParameters[@"title"] = noticeModel.Title;
						sqlParameters[@"firstsection"] = noticeModel.FirstSection;
						sqlParameters[@"detailurl"] = noticeModel.DetailURL;

						[db executeUpdate:sql withParameterDictionary:sqlParameters];
					}];
				}];
			});
		}
		

		[self.IndexTableView reloadRowsAtIndexPaths:@[_noticeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[_dbQueue inDatabase:^(FMDatabase *db) {
			NSString *sql = @"SELECT * FROM t_notice";
			FMResultSet *resultSet = [db executeQuery:sql];
			
			NSMutableArray *noticeModels = [NSMutableArray array];
			while ([resultSet next]) {
    			BDBNoticeModel *noticeModel = [[BDBNoticeModel alloc] init];
				noticeModel.NewsID = [resultSet stringForColumn:@"newsid"];
				noticeModel.Publisher = [resultSet stringForColumn:@"publisher"];
				noticeModel.DT = [resultSet stringForColumn:@"dt"];
				noticeModel.Title = [resultSet stringForColumn:@"title"];
				noticeModel.FirstSection = [resultSet stringForColumn:@"firstsection"];
				noticeModel.DetailURL = [resultSet stringForColumn:@"detailurl"];
				
				[noticeModels addObject:noticeModel];
			}
			
			self.noticeModels = noticeModels;
		}];
		
		NSIndexPath *noticeCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[_IndexTableView reloadRowsAtIndexPaths:@[noticeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	}];

}

- (void)refreshWorthyBidsWithMinAnnualEarnimgs:(NSString *)minAnnualEarnimgs maxAnnualEarnimgs:(NSString *)maxAnnualEarnimgs {
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	//GetNotice主机地址
	NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter_Ex"];
	
	//请求参数
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	parameters[@"Device"] = @0;
	parameters[@"PageIndex"] = @(_PageInDex);
	parameters[@"PageSize"] = @(_pageSize);
	
	parameters[@"AnnualEarnings"] = [NSString stringWithFormat:@"%@|%@",minAnnualEarnimgs,maxAnnualEarnimgs];
	parameters[@"EarningsDesc"] = @"1";
	
	parameters[@"Count"] = @0;
	
	//发送请求
	[manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		BDBIndexClassifyParticularMessageResponseModel *indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
		
		self.indexClassifyParticularMessageModels = [indexClassifyParticularMessageResponseModel.BidList mutableCopy];
		
		//缓存数据
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[_dbQueue inDatabase:^(FMDatabase *db) {
				//首先清空已有的相关数据
				NSString *sql = @"DELETE FROM t_bid WHERE annualearnings>=:minAnnualEarnimgs AND annualearnings<=:maxAnnualEarnimgs";
				
				NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
				sqlParameters[@"minAnnualEarnimgs"] = minAnnualEarnimgs;
				sqlParameters[@"maxAnnualEarnimgs"] = maxAnnualEarnimgs;
				
				[db executeUpdate:sql withParameterDictionary:sqlParameters];
				
				
				//数据清空后，装入相关数据
				sql = @"INSERT INTO t_bid(bidid,bidname,amount,term,biddt,schedule,detailurl,annualearnings,platformname,progresspercent) VALUES(:bidid,:bidname,:amount,:term,:biddt,:schedule,:detailurl,:annualearnings,:platformname,:progresspercent)";
				[_indexClassifyParticularMessageModels enumerateObjectsUsingBlock:^(BDBIndexClassifyParticularMessageModel *indexClassifyParticularMessageModel, NSUInteger idx, BOOL *stop) {
					NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
					
					sqlParameters[@"bidid"] = indexClassifyParticularMessageModel.BidID;
					sqlParameters[@"bidname"] = indexClassifyParticularMessageModel.BidName;
					sqlParameters[@"amount"] = indexClassifyParticularMessageModel.Amount;
					sqlParameters[@"term"] = indexClassifyParticularMessageModel.Term;
					sqlParameters[@"biddt"] = indexClassifyParticularMessageModel.BidDT;
					sqlParameters[@"schedule"] = indexClassifyParticularMessageModel.Schedule;
					sqlParameters[@"detailurl"] = indexClassifyParticularMessageModel.DetailURL;
					sqlParameters[@"annualearnings"] = indexClassifyParticularMessageModel.AnnualEarnings;
					sqlParameters[@"platformname"] = indexClassifyParticularMessageModel.PlatformName;
					sqlParameters[@"progresspercent"] = indexClassifyParticularMessageModel.ProgressPercent;
					
					[db executeUpdate:sql withParameterDictionary:sqlParameters];
				}];
				
			}];
		});
		
		//如果是下拉刷新
		if (_IndexTableView.header.isRefreshing) {
			[_IndexTableView.header endRefreshing];
		}
		
		if (self.loadDataIndicatePage) {
			[_loadDataIndicatePage hide];
			
			[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(hideIndexTableViewHeader) userInfo:nil repeats:NO];
		}
		
		[_IndexTableView reloadData];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		ZXLLOG(@"error: %@",error);
	
		[_dbQueue inDatabase:^(FMDatabase *db) {
			NSString *sql = @"SELECT bidid,bidname,amount,term,biddt,schedule,detailurl,annualearnings,platformname,progresspercent FROM t_bid WHERE annualearnings>=:minAnnualEarnimgs AND annualearnings<=:maxAnnualEarnimgs ORDER BY annualearnings DESC LIMIT 0,10";
			
			NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
			sqlParameters[@"minAnnualEarnimgs"] = minAnnualEarnimgs;
			sqlParameters[@"maxAnnualEarnimgs"] = maxAnnualEarnimgs;
			
			NSMutableArray *indexClassifyParticularMessageModels = [NSMutableArray array];
			
			FMResultSet *resultSet = [db executeQuery:sql withParameterDictionary:sqlParameters];
			while ([resultSet next]) {
				BDBIndexClassifyParticularMessageModel *indexClassifyParticularMessageModel = [[BDBIndexClassifyParticularMessageModel alloc] init];
				
				indexClassifyParticularMessageModel.BidID = [resultSet stringForColumn:@"bidid"];
				indexClassifyParticularMessageModel.BidName = [resultSet stringForColumn:@"bidname"];
				indexClassifyParticularMessageModel.Amount = [resultSet stringForColumn:@"amount"];
				indexClassifyParticularMessageModel.Term = [resultSet stringForColumn:@"term"];
				indexClassifyParticularMessageModel.BidDT = [resultSet stringForColumn:@"biddt"];
				indexClassifyParticularMessageModel.Schedule = [resultSet stringForColumn:@"schedule"];
				indexClassifyParticularMessageModel.DetailURL = [resultSet stringForColumn:@"detailurl"];
				indexClassifyParticularMessageModel.AnnualEarnings = [resultSet stringForColumn:@"annualearnings"];
				indexClassifyParticularMessageModel.PlatformName = [resultSet stringForColumn:@"platformname"];
				indexClassifyParticularMessageModel.ProgressPercent = [resultSet stringForColumn:@"progresspercent"]; 
				
				[indexClassifyParticularMessageModels addObject:indexClassifyParticularMessageModel];
			}
			
			[resultSet close];
			
			_indexClassifyParticularMessageModels = indexClassifyParticularMessageModels;
			
			//如果是下拉刷新
			if (_IndexTableView.header.isRefreshing) {
				[_IndexTableView.header endRefreshing];
			}
			
			//如果是第一次加载界面
			if (self.loadDataIndicatePage) {
				[_loadDataIndicatePage hide];
				
				[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(hideIndexTableViewHeader) userInfo:nil repeats:NO];
			}
			
			[_IndexTableView reloadData];
		}];

	}];

	
}


- (void)refreshWorthyBids{
    self.PageInDex = 1;
	
	switch (_judge) {
		case 0:{
			[self refreshWorthyBidsWithMinAnnualEarnimgs:@"0.15" maxAnnualEarnimgs:@"1.00"];
			break;
		}
		case 1:{
			[self refreshWorthyBidsWithMinAnnualEarnimgs:@"0.12" maxAnnualEarnimgs:@"0.15"];
			break;
		}
		case 2:{
			[self refreshWorthyBidsWithMinAnnualEarnimgs:@"0.00" maxAnnualEarnimgs:@"0.12"];
			break;
		}
		default:
			break;
	}
}

- (void)appendWorthyBidsWithMinAnnualEarnimgs:(NSString *)minAnnualEarnimgs maxAnnualEarnimgs:(NSString *)maxAnnualEarnimgs {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	//GetNotice主机地址
	NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter_Ex"];
	
	//请求参数
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	parameters[@"Device"] = @0;
	parameters[@"PageIndex"] = @(_PageInDex);
	parameters[@"PageSize"] = @(_pageSize);
	parameters[@"Count"] = @0;
	
	parameters[@"AnnualEarnings"] = [NSString stringWithFormat:@"%@|%@",minAnnualEarnimgs,maxAnnualEarnimgs];
	
	parameters[@"EarningsDesc"] = @1;
	
	//发送请求
	[manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		BDBIndexClassifyParticularMessageResponseModel *indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
		
		NSArray *indexClassifyParticularMessageResponseModels = indexClassifyParticularMessageResponseModel.BidList;
		
		//下拉刷新的数据直接插入到数据库中
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[_dbQueue inDatabase:^(FMDatabase *db) {
				NSString *sql = @"INSERT INTO t_bid(bidid,bidname,amount,term,biddt,schedule,detailurl,annualearnings,platformname,progresspercent) VALUES(:bidid,:bidname,:amount,:term,:biddt,:schedule,:detailurl,:annualearnings,:platformname,:progresspercent)";
				[indexClassifyParticularMessageResponseModels enumerateObjectsUsingBlock:^(BDBIndexClassifyParticularMessageModel *indexClassifyParticularMessageModel, NSUInteger idx, BOOL *stop) {
					NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
					
					sqlParameters[@"bidid"] = indexClassifyParticularMessageModel.BidID;
					sqlParameters[@"bidname"] = indexClassifyParticularMessageModel.BidName;
					sqlParameters[@"amount"] = indexClassifyParticularMessageModel.Amount;
					sqlParameters[@"term"] = indexClassifyParticularMessageModel.Term;
					sqlParameters[@"biddt"] = indexClassifyParticularMessageModel.BidDT;
					sqlParameters[@"schedule"] = indexClassifyParticularMessageModel.Schedule;
					sqlParameters[@"detailurl"] = indexClassifyParticularMessageModel.DetailURL;
					sqlParameters[@"annualearnings"] = indexClassifyParticularMessageModel.AnnualEarnings;
					sqlParameters[@"platformname"] = indexClassifyParticularMessageModel.PlatformName;
					sqlParameters[@"progresspercent"] = indexClassifyParticularMessageModel.ProgressPercent;
					
					[db executeUpdate:sql withParameterDictionary:sqlParameters];
					
				}];
				
			}];
		});
		
		[self.indexClassifyParticularMessageModels addObjectsFromArray:indexClassifyParticularMessageResponseModels];
		
		if (_IndexTableView.footer.isRefreshing) {
			[_IndexTableView.footer endRefreshing];
		}
		
		[_IndexTableView reloadData];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (_IndexTableView.footer.isRefreshing) {
			[_IndexTableView.footer endRefreshing];
		}
	}];
}

- (void)appendWorthyBids {
	self.PageInDex ++;
	switch (_judge) {
		case 0:{
			[self appendWorthyBidsWithMinAnnualEarnimgs:@"0.15" maxAnnualEarnimgs:@"1.00"];
			break;
		}
		case 1:{
			[self appendWorthyBidsWithMinAnnualEarnimgs:@"0.12" maxAnnualEarnimgs:@"0.15"];
			break;
		}
		case 2:{
			[self appendWorthyBidsWithMinAnnualEarnimgs:@"0.00" maxAnnualEarnimgs:@"0.12"];
			break;
		}
		default:
			break;
	}
}


- (void)initIndexTableView {
    //indexTableView tableViewHeader
    BDBIndexTableViewHeader *indexTableViewHeader = [[BDBIndexTableViewHeader alloc] init];
	self.indexTableViewHeader = indexTableViewHeader;

    //根据约束，实际计算Frame(适用于只能设定frame的地方)
    CGSize indexTableViewHeaderFitSize = [_indexTableViewHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    //tableViewHead的高度设定，只能用Frame方式
	_indexTableViewHeader.height = indexTableViewHeaderFitSize.height;
	
	//表格头部视图设置之前，尺寸要先确认
	_IndexTableView.tableHeaderView = _indexTableViewHeader;
	
	self.IndexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	__weak typeof (self) thisInstance = self;
	self.IndexTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
		[thisInstance refreshWorthyBids];
	}];
	
	self.IndexTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
		[thisInstance appendWorthyBids];
	}];
	
	_IndexTableView.allowsSelection = YES;
}

- (void)rgyView:(BDBSortTableViewCell *)sortTableViewCell changedByJude:(NSUInteger)jude {
	switch (jude) {
		case 0:{
			sortTableViewCell.redView.backgroundColor = UIColorWithRGB(185, 35, 40);
			sortTableViewCell.greenView.backgroundColor = UIColorWithRGB(95, 215, 90);
			sortTableViewCell.blueView.backgroundColor = UIColorWithRGB(75, 140, 249);
			break;
		}
		case 1:{
			sortTableViewCell.redView.backgroundColor = UIColorWithRGB(240, 80, 90);
			sortTableViewCell.greenView.backgroundColor = UIColorWithRGB(60, 150, 40);
			sortTableViewCell.blueView.backgroundColor = UIColorWithRGB(75, 140, 249);
			break;
		}
		case 2:{
			sortTableViewCell.redView.backgroundColor = UIColorWithRGB(240, 80, 90);
			sortTableViewCell.greenView.backgroundColor = UIColorWithRGB(95, 215, 90);
			sortTableViewCell.blueView.backgroundColor = UIColorWithRGB(30, 90, 160);
			break;
		}
			
  		default:
			break;
	}
}

- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem {
    [self performSegueWithIdentifier:@"ToNoticeViewControllerSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger sectionCellRowNum;
    if (section == 0) {
        sectionCellRowNum = 3;
    }else if(section == 1){
        sectionCellRowNum = _indexClassifyParticularMessageModels.count;
    }
    return sectionCellRowNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
		//记录公告Cell的位置
		self.noticeCellIndexPath = indexPath;
		
		static NSString *messageTableViewCellIdentifier = @"messageTableViewCellIdentifier";
		
		BDBMessageTableViewCell *messageTableViewCell = [tableView dequeueReusableCellWithIdentifier:messageTableViewCellIdentifier];
		
		if (!messageTableViewCell) {
			messageTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"BDBMessageTableViewCell" owner:nil options:nil] lastObject];
		}
		
		NSMutableArray *texts = [NSMutableArray array];
		[_noticeModels enumerateObjectsUsingBlock:^(BDBNoticeModel *noticeModel, NSUInteger idx, BOOL *stop) {
			[texts addObject:noticeModel.Title];
		}];
		if (texts.count > 0) {
			messageTableViewCell.texts = [texts copy];
		}
		//取消选中样式
        messageTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone; 
		
        return messageTableViewCell;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
		static NSString *parameterTableViewCellIdentifier = @"parameterTableViewCellIdentifier";
		
		BDBParameterTableViewCell *parameterTableViewCell = [tableView dequeueReusableCellWithIdentifier:parameterTableViewCellIdentifier];
		if (!parameterTableViewCell) {
			parameterTableViewCell = [BDBParameterTableViewCell cell];
		}
		
		//可投资金
		CGFloat amountRemain = 0.0f;
		if(_indexModel.AmountRemain){
			amountRemain = [_indexModel.AmountRemain floatValue] / 10000.0f;
		}
		parameterTableViewCell.AmountRemainLabel.text = [NSString stringWithFormat:@"%g",amountRemain];
		
		//可投项目
        parameterTableViewCell.BidNumLabel.text = _indexModel.BidNum;
		
		//最高收益
		NSInteger EarningsMax = 0;
		if (_indexModel.EarningsMax) {
			EarningsMax = _indexModel.EarningsMax * 100;
		}
        parameterTableViewCell.EarningsMaxLabel.text = [NSString stringWithFormat:@"%@%%",@(EarningsMax)];
		
        //投资人数
        parameterTableViewCell.InvestorNumLabel.text = _indexModel.InvestorNum;
        
        parameterTableViewCell.userInteractionEnabled = YES;
        
        [parameterTableViewCell.hideAndShowButton addTarget:self action:@selector(hideIndexTableViewHeader) forControlEvents:UIControlEventTouchUpInside];
        
        return parameterTableViewCell;
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        
        BDBSortTableViewCell *cell = [BDBSortTableViewCell cell];
        
        NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithString:@">15%"];
        [firstString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(3, 1)];
        [firstString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 3)];
        cell.moreThanFifteenPercentLabel.attributedText = firstString;
        
        NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithString:@"12%-15%"];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 2)];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(4, 2)];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(2, 2)];
        [secondString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(6, 1)];
        cell.moreThanTwelvePercentLessThanFifteenPercentLabel.attributedText = secondString;
        
        NSMutableAttributedString *thirdString = [[NSMutableAttributedString alloc] initWithString:@"<12%"];
        [thirdString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, 3)];
        [thirdString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7.0f] range:NSMakeRange(3, 1)];
        cell.lessThanTwelvePercentLabel.attributedText = thirdString;
        
        UITapGestureRecognizer *redViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRedMessage:)];
        [cell.redView addGestureRecognizer:redViewTapGestureRecognizer];
        
        UITapGestureRecognizer *greenViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeGreenMessage:)];
        [cell.greenView addGestureRecognizer:greenViewTapGestureRecognizer];
        
        UITapGestureRecognizer *blueViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBlueMessage:)];
        [cell.blueView addGestureRecognizer:blueViewTapGestureRecognizer];
		
		[self rgyView:cell changedByJude:_judge];
        
        return cell;
    }

     if (indexPath.section == 1) {
	 	NSString *detailMessageTableViewCellIdentifier = @"detailedCell";
	 
        BDBDetailedMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailMessageTableViewCellIdentifier];
        if (!cell) {
            cell = [BDBDetailedMessageTableViewCell cell];
		}
		
		 //设置红点上的数字
		 cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
		 
		 BDBIndexClassifyParticularMessageModel *indexClassifyParticularMessageModel = _indexClassifyParticularMessageModels[indexPath.row];
		 
			
		 //cell.AmountLabel.text = [NSString stringWithFormat:@"%.2f",[indexClassifyParticularMessageModel.Amount floatValue] * 0.0001];
			//标的期限
		 cell.TermLabel.text = indexClassifyParticularMessageModel.Term;
			//平台名称
		 cell.PlatformNameLabel.text = indexClassifyParticularMessageModel.PlatformName;
		 //标的年利率
		 cell.ProgressPercentLabel.text = [NSString stringWithFormat:@"%.0f",[indexClassifyParticularMessageModel.AnnualEarnings floatValue] * 100];

		return cell;
     }
    return nil;
}

- (void)hideIndexTableViewHeader {
	_IndexTableView.tableHeaderView = (_IndexTableView.tableHeaderView)? nil : _indexTableViewHeader;
}





#pragma mark - GestureRecognizer
- (void)changeRedMessage: (UIGestureRecognizer *)gesture {
    self.judge = 0;
	
	[self refreshWorthyBids];
	
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    [self rgyView:cell changedByJude:_judge];
}

- (void)changeGreenMessage: (UIGestureRecognizer *)gesture {
    self.judge = 1;
	
	[self refreshWorthyBids];
    
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
	[self rgyView:cell changedByJude:_judge];
}

- (void)changeBlueMessage: (UIGestureRecognizer *)gesture {
    self.judge = 2;
	
	[self refreshWorthyBids];
    
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    [self rgyView:cell changedByJude:_judge];
}


#pragma mark - UITableView Delegate Methods
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hight = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        hight = 30;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        hight = 100;
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        hight = 55;
    }else if (indexPath.section == 1) {
        hight = 44;
    }
    return hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0) {
		BDBMessageTableViewCell *messageTableViewCell = (BDBMessageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
		
		//遍历模型，找出用户点击的公告
		__block BDBNoticeModel *noticeModel = nil;
		[_noticeModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			noticeModel = (BDBNoticeModel *)obj;
			if ([messageTableViewCell.displayingText isEqualToString:noticeModel.Title]) {
    			*stop = YES;
			}
		}];
		
		//切换场景
		BDBNoticeDetailViewController *noticeDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BDBNoticeDetailViewController"];
		noticeDetailViewController.noticeDetailURL = noticeModel.DetailURL;
		
		[self.navigationController pushViewController:noticeDetailViewController animated:YES];
	}else if(indexPath.section == 1){
		BDBIndexClassifyParticularMessageModel *indexClassifyParticularMessageModel = _indexClassifyParticularMessageModels[indexPath.row];
		
		BDBSubjectDetailWebViewController *subjectDetailWebViewController = [[BDBSubjectDetailWebViewController alloc] init];
		subjectDetailWebViewController.subjectDetailURL = indexClassifyParticularMessageModel.DetailURL;
		
		[self.navigationController pushViewController:subjectDetailWebViewController animated:YES];
	}
}



@end
