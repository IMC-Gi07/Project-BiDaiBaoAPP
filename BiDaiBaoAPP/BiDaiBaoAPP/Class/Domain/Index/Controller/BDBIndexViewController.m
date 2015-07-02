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

@property(nonatomic,strong) BDBIndexClassifyParticularMessageResponseModel *indexClassifyParticularMessageResponseModel;

@property(nonatomic,strong) BDBIndexGuideMessageResponseModel *indexModel;

@property(nonatomic,strong) NSMutableArray *AnnouncementModel;

@property(nonatomic,strong) NSMutableArray *ParticularModel;

@property (weak, nonatomic) IBOutlet UITableView *IndexTableView;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *loadDataIndicatePage;

/**
 *	表格头部视图
 */
@property(nonatomic,weak) BDBIndexTableViewHeader *indexTableViewHeader;

/**
 公告页数
 */
@property(nonatomic,assign) NSUInteger pageIndex;

/**
 每页显示数量
 */
@property(nonatomic,assign) NSUInteger pageSize;

@property(nonatomic,assign) NSUInteger PageInDex;

//用于判断点击到了那个View的手势
@property(nonatomic,assign) NSUInteger judge;

- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem;

/**
 *	初始化表格视图
 */
- (void)initIndexTableView;

//加载公告引导信息
- (void)loadNoticeGuideMessage;

//加载公告信息
- (void)loadNoticeMessage;

//加载标的详细信息
- (void)loadBidMessage;

//加载红色标的详细信息
- (void)loadRedBidMessage;

//加载绿色标的的详细信息
- (void)loadGreenBidMessage;

//加载蓝色标的的详细信息
- (void)loadBlueBidMessage;

//下拉刷新
- (void)downRefresh;



@end

@implementation BDBIndexViewController

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = @"比贷宝";
        self.pageSize = 10;
        
        self.indexPaths = [NSMutableArray array];
//        self.AnnouncementModel = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBidMessage];
    [self loadNoticeMessage];
    [self loadNoticeGuideMessage];
    [self initIndexTableView];
    //显示加载页面
    self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];

    
    UIImage *rightBarButtonImage = [UIImageWithName(@"index_nav_right") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickedAction:)];

    self.IndexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    /**
     *  设置页眉的
     */
    
    
//    [self.IndexTableView.tableHeaderView setHidden:YES];
    

    
//    UIImage *headerImage = [UIImage imageNamed:@"earth_03"];
//    
//    self.herderImageView = [[UIImageView alloc] initWithImage:headerImage];
//    self.herderImageView.bounds = CGRectMake(0, 0, 0, 250.0f);
//    self.IndexTableView.tableHeaderView = _herderImageView;
    
    
    __weak typeof (self) thisInstance = self;
    self.IndexTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        [thisInstance downRefresh];
        [thisInstance.IndexTableView.header endRefreshing];
    }];
    
    self.IndexTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        [thisInstance.IndexTableView.footer endRefreshing];
    }];
}

- (void)loadNoticeGuideMessage {
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
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
        //        NSLog(@"%@",self.indexModel.AmountRemain);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

}

- (void)loadNoticeMessage {
    //刷新数据时，页数改为1。
    self.pageIndex = 1;
    //偏好设置读取数据
    NSUserDefaults *userDfaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UID = [userDfaults objectForKey:@"UID"];
    NSString *PSW = [userDfaults objectForKey:@"PSW"];
    //    NSLog(@"UID:%@",UID);
    
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    //GetNotice主机地址
    NSString *noticeUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNotice"];
    NSMutableDictionary *noticeDict = [NSMutableDictionary dictionary];
    if (UID) {
        noticeDict[@"UID"] = UID;
    }
    
    if (PSW) {
        noticeDict[@"PSW"] = PSW;
    }
    noticeDict[@"UserType"] = @"0";
    noticeDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    noticeDict[@"Device"] = @"0";
    noticeDict[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    noticeDict[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    
    [manager POST:noticeUrl parameters:noticeDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBWebAnnouncementResponseModel *announcementResponseModel = [BDBWebAnnouncementResponseModel objectWithKeyValues:responseObject];
        self.AnnouncementModel = announcementResponseModel.NoticeList;
//        NSLog(@"%@",announcementResponseModel);
        [self.IndexTableView reloadData];
//        NSLog(@"_AnnouncementModel:%@",announcementResponseModel.NoticeList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

}

- (void)loadBidMessage {
    self.PageInDex ++;
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //GetWorthyBids_Filter主机地址
    NSString *bidUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter"];
    
    NSMutableDictionary *bidDict = [NSMutableDictionary dictionary];
    bidDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    bidDict[@"Device"] = @"0";
    bidDict[@"PageInDex"] = [NSString stringWithFormat:@"%lu",_PageInDex];
    bidDict[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    bidDict[@"Count"] = @"1";
    bidDict[@"ProgressPercent_Max"] = @"1";
    
    [manager POST:bidUrl parameters:bidDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        self.indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
        self.ParticularModel = _indexClassifyParticularMessageResponseModel.BidList;
        
        //        NSLog(@"%@",indexClassifyParticularMessageResponseModel);
        if (_loadDataIndicatePage) {
            [_loadDataIndicatePage hide];
        }else {
            [_IndexTableView.header endRefreshing];
        }
        
        [self.IndexTableView reloadRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

}

- (void)loadRedBidMessage {
    self.PageInDex = 1;
    
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //GetWorthyBids_Filter主机地址
    NSString *bidUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter"];
    
    NSMutableDictionary *bidDict = [NSMutableDictionary dictionary];
    bidDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    bidDict[@"Device"] = @"0";
    bidDict[@"PageInDex"] = [NSString stringWithFormat:@"%lu",_PageInDex];
    bidDict[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    bidDict[@"Count"] = @"1";
//    bidDict[@"AnnualEarnings_Min"] = @"15";
    
    [manager POST:bidUrl parameters:bidDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        self.indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
        self.ParticularModel = _indexClassifyParticularMessageResponseModel.BidList;
//        NSLog(@"%@",indexClassifyParticularMessageResponseModel);
        
        [self.IndexTableView reloadRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

}

- (void)loadGreenBidMessage {
    self.PageInDex = 1;
    
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //GetWorthyBids_Filter主机地址
    NSString *bidUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter"];
    
    NSMutableDictionary *bidDict = [NSMutableDictionary dictionary];
    bidDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    bidDict[@"Device"] = @"0";
    bidDict[@"PageInDex"] = [NSString stringWithFormat:@"%lu",_PageInDex];
    bidDict[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    bidDict[@"Count"] = @"1";
//    bidDict[@"AnnualEarnings_Min"] = @"15";

    
    [manager POST:bidUrl parameters:bidDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        self.indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
        self.ParticularModel = _indexClassifyParticularMessageResponseModel.BidList;
        //        NSLog(@"%@",indexClassifyParticularMessageResponseModel);
        
        [self.IndexTableView reloadRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

}

- (void)loadBlueBidMessage {
    self.PageInDex = 1;

    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //GetWorthyBids_Filter主机地址
    NSString *bidUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter"];
    
    NSMutableDictionary *bidDict = [NSMutableDictionary dictionary];
    bidDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    bidDict[@"Device"] = @"0";
    bidDict[@"PageInDex"] = [NSString stringWithFormat:@"%lu",_PageInDex];
    bidDict[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    bidDict[@"Count"] = @"1";
//    bidDict[@"AnnualEarnings_Max"] = @"12";
    
    [manager POST:bidUrl parameters:bidDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
         self.indexClassifyParticularMessageResponseModel = [BDBIndexClassifyParticularMessageResponseModel objectWithKeyValues:responseObject];
        self.ParticularModel = _indexClassifyParticularMessageResponseModel.BidList;
//        NSLog(@"%@",self.ParticularModel);
//        NSLog(@"%@",indexClassifyParticularMessageResponseModel);
        
        [self.IndexTableView reloadRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];

}

- (void)downRefresh {
    self.PageInDex = 1;
    if (_judge == 0) {
        [self loadRedBidMessage];
    }else if (_judge == 1) {
        [self loadGreenBidMessage];
    }else if (_judge == 2) {
        [self loadBlueBidMessage];
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
    
    _IndexTableView.tableHeaderView = _indexTableViewHeader;
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
    }else {
        sectionCellRowNum = 10;
    }
    return sectionCellRowNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        BDBMessageTableViewCell *cell = [BDBMessageTableViewCell cell];
        
        BDBNoticeModel *noticeModel = _AnnouncementModel[indexPath.row];
        

        cell.titleLabel.text = noticeModel.Title;
        
        
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
        
        return cell;
    }

     if (indexPath.section == 1) {
        BDBDetailedMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailedCell"];
         
        if (cell == nil) {
            cell = [BDBDetailedMessageTableViewCell cell];
            
            //设置红点上的数字
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
            
//            NSMutableAttributedString *percentNumber = [[NSMutableAttributedString alloc] initWithString:@"25%"];
//            
//            [percentNumber addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(2, 1)];
            
            BDBIndexClassifyParticularMessageModel *indexClassifyParticularMessageModel = [[BDBIndexClassifyParticularMessageModel alloc] init];
            indexClassifyParticularMessageModel.Amount = _ParticularModel[indexPath.row][@"Amount"];
//            NSLog(@"%@",_ParticularModel);
            cell.AmountLabel.text = [NSString stringWithFormat:@"%.2f",[_ParticularModel[indexPath.row][@"Amount"] floatValue] * 0.0001];
//            NSLog(@"aaa:%@",cell.AmountLabel.text );
            cell.TermLabel.text = _ParticularModel[indexPath.row][@"Term"];;
//            NSLog(@"ccc:%@",cell.TermLabel.text);
            cell.PlatformNameLabel.text = _ParticularModel[indexPath.row][@"PlatformName"];
            
            cell.ProgressPercentLabel.text = [NSString stringWithFormat:@"%.0f",[_ParticularModel[indexPath.row][@"ProgressPercent"] floatValue] * 100];
        }
         
         [self.indexPaths addObject:indexPath];
         return cell;
     }
    return nil;
}

- (void)hideAndShow {
    
    NSLog(@"被点击了...");
    if (self.indexTableViewHeader.height == 300.0f) {
        
    }else if (self.indexTableViewHeader.height == 0) {

    }
}



#pragma mark - GestureRecognizer
- (void)changeRedMessage: (UIGestureRecognizer *)gesture {
    
    [self loadRedBidMessage];
    
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    
    
    cell.redView.backgroundColor = UIColorWithRGB(194, 45, 52);
    
    
    cell.blueView.backgroundColor = UIColorWithRGB(64, 132, 249);
    
    cell.greenView.backgroundColor = UIColorWithRGB(86, 205, 82);

    self.judge = 0;
}

- (void)changeGreenMessage: (UIGestureRecognizer *)gesture {
    
    [self loadGreenBidMessage];
    
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    cell.greenView.backgroundColor = UIColorWithRGB(67, 158, 49);
    
    cell.blueView.backgroundColor = UIColorWithRGB(64, 132, 249);

    cell.redView.backgroundColor = UIColorWithRGB(224, 63, 74);
    
    self.judge = 1;

}

- (void)changeBlueMessage: (UIGestureRecognizer *)gesture {
    [self loadBlueBidMessage];
    
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    cell.blueView.backgroundColor = UIColorWithRGB(40, 96, 172);
    
    cell.redView.backgroundColor = UIColorWithRGB(224, 63, 74);
    
    cell.greenView.backgroundColor = UIColorWithRGB(86, 205, 82);
    
    self.judge = 2;

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
