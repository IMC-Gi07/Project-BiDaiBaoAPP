//
//  BDBMainTableViewController.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/17.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBIndexViewController.h"
#import "BDBMessageTableViewCell.h"
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




@interface BDBIndexViewController ()

@property(nonatomic,strong) NSMutableArray *indexPaths;

@property(nonatomic,strong) NSMutableArray  *indexClassifyParticularMessageModels;

@property(nonatomic,strong) BDBIndexGuideMessageResponseModel *indexModel;

@property(nonatomic,strong) BDBNoticeModel *noticeModel;

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
	
	//刷新标的列表信息
	[self refreshWorthyBids];
   
   	//加载公告信息
    [self loadNoticeMessage];
	
    [self loadNoticeGuideMessage];
   
    //显示加载页面
    self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];

}


#pragma mark - Private Methods
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
		
        [self.IndexTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

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
    parameters[@"PageSize"] = @1;
    
    [manager POST:noticeUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBWebAnnouncementResponseModel *announcementResponseModel = [BDBWebAnnouncementResponseModel objectWithKeyValues:responseObject];
        self.noticeModel = [announcementResponseModel.NoticeList lastObject];

		[self.IndexTableView reloadRowsAtIndexPaths:@[_noticeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

}

- (void)refreshWorthyBidsWithMinAnnualEarnimgs:(NSString *)minAnnualEarnimgs maxAnnualEarnimgs:(NSString *)maxAnnualEarnimgs {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

	//GetNotice主机地址
	NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter"];
	
	//请求参数
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	//偏好设置读取数据
	NSUserDefaults *userDfaults = [NSUserDefaults standardUserDefaults];
	NSString *UID = [userDfaults objectForKey:@"UID"];
	if (UID && ![@"" isEqualToString:UID]) {
		parameters[@"UID"] = UID;
	}
	
	NSString *PSW = [userDfaults objectForKey:@"PSW"];
	if (PSW && ![@"" isEqualToString:PSW]) {
		parameters[@"PWS"] = PSW;
	}
	
	parameters[@"UserType"] = @0;
	parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	parameters[@"Device"] = @0;
	parameters[@"PageIndex"] = @(_PageInDex);
	parameters[@"PageSize"] = @(_pageSize);
	
	parameters[@"AnnualEarnings_Min"] = minAnnualEarnimgs;
	parameters[@"AnnualEarnings_Max"] = maxAnnualEarnimgs;
	
	parameters[@"Count"] = @0;
	
	//发送请求
	[manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		BDBIndexClassifyParticularMessageResponseModel *indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
		
		self.indexClassifyParticularMessageModels = [indexClassifyParticularMessageResponseModel.BidList mutableCopy];
		 
		//如果是下拉刷新
		if (_IndexTableView.header.isRefreshing) {
			[_IndexTableView.header endRefreshing];
		}
		
		if (self.loadDataIndicatePage) {
			[_loadDataIndicatePage hide];
		}
		
		[_IndexTableView reloadData];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
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
			[self refreshWorthyBidsWithMinAnnualEarnimgs:@"0.00" maxAnnualEarnimgs:@"0.15"];
			break;
		}
		default:
			break;
	}
}

- (void)appendWorthyBidsWithMinAnnualEarnimgs:(NSString *)minAnnualEarnimgs maxAnnualEarnimgs:(NSString *)maxAnnualEarnimgs {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	//GetNotice主机地址
	NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter"];
	
	//请求参数
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	//偏好设置读取数据
	NSUserDefaults *userDfaults = [NSUserDefaults standardUserDefaults];
	NSString *UID = [userDfaults objectForKey:@"UID"];
	if (UID && ![@"" isEqualToString:UID]) {
		parameters[@"UID"] = UID;
	}
	
	NSString *PSW = [userDfaults objectForKey:@"PSW"];
	if (PSW && ![@"" isEqualToString:PSW]) {
		parameters[@"PWS"] = PSW;
	}
	
	parameters[@"UserType"] = @0;
	parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	parameters[@"Device"] = @0;
	parameters[@"PageIndex"] = @(_PageInDex);
	parameters[@"PageSize"] = @(_pageSize);
	
	parameters[@"AnnualEarnings_Min"] = minAnnualEarnimgs;
	parameters[@"AnnualEarnings_Max"] = maxAnnualEarnimgs;
	
	parameters[@"Count"] = @0;
	
	//发送请求
	[manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		BDBIndexClassifyParticularMessageResponseModel *indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
		
		[self.indexClassifyParticularMessageModels addObjectsFromArray:indexClassifyParticularMessageResponseModel.BidList];
		
		if (_IndexTableView.footer.isRefreshing) {
			[_IndexTableView.footer endRefreshing];
		}
		
		[_IndexTableView reloadData];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
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
			[self appendWorthyBidsWithMinAnnualEarnimgs:@"0.00" maxAnnualEarnimgs:@"0.15"];
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
}

- (void)rgyView:(BDBSortTableViewCell *)sortTableViewCell changedByJude:(NSUInteger)jude {
	switch (jude) {
		case 0:{
			sortTableViewCell.redView.backgroundColor = UIColorWithRGB(194, 45, 52);
			sortTableViewCell.blueView.backgroundColor = UIColorWithRGB(64, 132, 249);
			sortTableViewCell.greenView.backgroundColor = UIColorWithRGB(86, 205, 82);			
			break;
		}
		case 1:{
			sortTableViewCell.greenView.backgroundColor = UIColorWithRGB(67, 158, 49);
			sortTableViewCell.blueView.backgroundColor = UIColorWithRGB(64, 132, 249);
			sortTableViewCell.redView.backgroundColor = UIColorWithRGB(224, 63, 74);
			break;
		}
		case 2:{
			sortTableViewCell.blueView.backgroundColor = UIColorWithRGB(40, 96, 172);
			sortTableViewCell.redView.backgroundColor = UIColorWithRGB(224, 63, 74);
			sortTableViewCell.greenView.backgroundColor = UIColorWithRGB(86, 205, 82);
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
		
        BDBMessageTableViewCell *cell = [BDBMessageTableViewCell cell];
	
        cell.titleLabel.text = _noticeModel.Title;
        
        cell.userInteractionEnabled = NO;
		
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        BDBParameterTableViewCell *cell = [BDBParameterTableViewCell cell];
        cell.AmountRemainLabel.text = _indexModel.AmountRemain;
        
        cell.BidNumLabel.text = _indexModel.BidNum;
        NSString *percent = @"%";
        cell.EarningsMaxLabel.text = [NSString stringWithFormat:@"%@%@",_indexModel.EarningsMax,percent];
//      NSLog(@"%@",_indexModel.EarningsMax);
        
        cell.InvestorNumLabel.text = _indexModel.InvestorNum;
//      NSLog(@"%@",_indexModel.AmountRemain);
        
        cell.userInteractionEnabled = YES;
        
        [cell.hideAndShowButton addTarget:self action:@selector(hideAndShow) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
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
        BDBDetailedMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailedCell"];
         
        if (cell == nil) {
            cell = [BDBDetailedMessageTableViewCell cell];
            
            //设置红点上的数字
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
            
            BDBIndexClassifyParticularMessageModel *indexClassifyParticularMessageModel = _indexClassifyParticularMessageModels[indexPath.row];

            cell.AmountLabel.text = [NSString stringWithFormat:@"%.2f",[indexClassifyParticularMessageModel.Amount floatValue] * 0.0001];

            cell.TermLabel.text = indexClassifyParticularMessageModel.Term;

            cell.PlatformNameLabel.text = indexClassifyParticularMessageModel.PlatformName;
            
            cell.ProgressPercentLabel.text = [NSString stringWithFormat:@"%.0f",[indexClassifyParticularMessageModel.ProgressPercent floatValue] * 100];
			
		}

		return cell;
     }
    return nil;
}

- (void)hideAndShow {
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



//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hight = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        hight = 30;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        hight = 100;
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        hight = 66;
    }else if (indexPath.section == 1) {
        hight = 44;
    }
    return hight;
}

@end
