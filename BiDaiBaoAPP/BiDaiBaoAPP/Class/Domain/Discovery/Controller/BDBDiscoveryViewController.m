//
//  ViewController.m
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/11.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBDiscoveryViewController.h"
#import "BDBScrollViewCell.h"
#import "BDBCollectionCell.h"
#import "BDBImformationCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "BDBDiscoveryModel.h"
#import "BDBDiscoveryResponseModel.h"
#import "GlobalConfigurations.h"
#import "BDBTableViewRefreshHeader.h"
#import "BDBTableViewRefreshFooter.h"
#import "MJRefresh.h"
#import "BDBDiscoveryAdvPicModel.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBDiscoveryDetailNewsViewController.h"
@interface BDBDiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BDBCollectionCellDelegate>

@property (nonatomic,assign) BOOL isSegmentFirst;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *index_0;
@property (strong, nonatomic) UIButton *index_1;
//资讯数据
@property(nonatomic,strong) NSMutableArray *newsModels;
//资讯页数
@property(nonatomic,assign) NSUInteger pageIndex;
//每页显示数量
@property(nonatomic,assign) NSUInteger pageSize;
//资讯轮播页面编号
@property(nonatomic,assign) NSUInteger pageNo;
//轮播图片
@property(nonatomic,strong) NSMutableArray *advPicArray;


@property (nonatomic,strong) ZXLLoadDataIndicatePage *loadDataIndicatePage;

@property (nonatomic,assign) NSIndexPath *selectedIndexPath;

- (void)searchButtonClickedAction:(UIBarButtonItem *)search;
- (void)refreshDatas;
- (void)loadMoreDatas;
- (void)initHeaderAndFooter;
@end

@implementation BDBDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NSUnderlineStyleNone;
    
    self.isSegmentFirst = YES;
    self.pageSize = 5;
    self.pageNo = 2;

    self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    //获取网络数据
    [self refreshDatas];
    [self initHeaderAndFooter];
    
//    [_tableView registerNib:[UINib nibWithNibName:@"BDBScrollViewCell" bundle:nil] forCellReuseIdentifier:@"scrollView"];
    


}

#pragma mark - UITableViewDelegate,UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows;
    if (_isSegmentFirst) {
        rows = _newsModels.count + 1;
    }else {
        return 2;
    }
    return rows;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow;
    if (indexPath.row == 0) {
        return 200.0f;
    }
    if (_isSegmentFirst) {
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            if (indexPath.row >0) {
                return 130;
            }
        }else {
            if (indexPath.row > 0) {
                return 120;
            }
        }
    }else {
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            if (indexPath.row == 1) {
                return 420;
            }
        }
        else {
            if (indexPath.row == 1) {
                return 360;
            }
        }
    }
    return heightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        BDBScrollViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBScrollViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_advPicArray != nil) {
            cell.imagesArray = [_advPicArray mutableCopy];
        }
        return cell;
    }
    if (_isSegmentFirst) {
        
        if (indexPath.row >= 1) {
            BDBDiscoveryModel *news = _newsModels[indexPath.row - 1];
            
            static NSString *cellIdentifier = @"informationCell";
            
            BDBImformationCell *informationCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (informationCell == nil) {
                informationCell = [[NSBundle mainBundle] loadNibNamed:@"BDBImformationCell" owner:nil options:nil][0];
            }
            informationCell.selectionStyle = UITableViewCellSelectionStyleNone;
            informationCell.title.text = news.Title;
            informationCell.publisher.text = news.Publisher;
            informationCell.DT.text = news.DT;
            informationCell.firstSection.text = news.FirstSection;
            informationCell.commentNum.text = news.CommentNum;
            informationCell.PopularIndex.text = news.PopularIndex;
            NSString *picUrl = news.PicURL;
            NSURL *picURL = [NSURL URLWithString:picUrl];
            NSData *picData = [NSData dataWithContentsOfURL:picURL];
            UIImage *pic = [UIImage imageWithData:picData];
            informationCell.pic.image = pic;
            return informationCell;
        }
    }else {
        if (indexPath.row == 1) {
            BDBCollectionCell *collectionCell = [[NSBundle mainBundle] loadNibNamed:@"BDBCollectionCell" owner:nil options:nil][0];
            collectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            collectionCell.delegate = self;
            return collectionCell;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"newsDetail" sender:self];
}
#pragma mark - Prepare WebView 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"newsDetail" isEqualToString:segue.identifier]) {
        BDBDiscoveryModel *news = _newsModels[_selectedIndexPath.row - 1];
        
        BDBDiscoveryDetailNewsViewController *detailNewsViewController = segue.destinationViewController;
        detailNewsViewController.newsDetailURL = news.DetailURL;
    }
}


#pragma mark - Buttons Clicked Action
- (void)index_0ButtonClicked {
    _isSegmentFirst = YES;
    _index_0.selected = YES;
    _index_1.selected = NO;
    [_tableView reloadData];
}
- (void)index_1ButtonClicked {
    _isSegmentFirst = NO;
    _index_0.selected = NO;
    _index_1.selected = YES;
    [_tableView reloadData];
}



-(void)searchButtonClickedAction:(UIBarButtonItem *)search {
    [self performSegueWithIdentifier:@"searchQuestions" sender:self];
}


//初始化导航栏样式
- (void)initNavigationBar {
    //给导航控制栏添加button
    UIButton *search = [[UIButton alloc] initWithFrame:(CGRect){0,0,44,44}];
    [search setImage:[UIImage imageNamed:@"Discovery_navigation_search"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightView = [[UIBarButtonItem alloc] initWithCustomView:search];
    self.navigationItem.rightBarButtonItem = rightView;
    
    UIView *titleView = [[UIView alloc] initWithFrame:(CGRect){0,0,200,30}];
    _index_0 = [[UIButton alloc] initWithFrame:(CGRect){0,0,100,30}];
    [_index_0 setImage:[UIImage imageNamed:@"Discovery_index_0"] forState:UIControlStateNormal];
    [_index_0 setImage:[UIImage imageNamed:@"Discovery_index_0_highlighted"] forState:UIControlStateSelected];
    _index_0.selected = YES;
    _index_0.adjustsImageWhenHighlighted = NO;
    
    [_index_0 addTarget:self action:@selector(index_0ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_index_0];
    
    _index_1 = [[UIButton alloc] initWithFrame:(CGRect){100,0,100,30}];
    [_index_1 setImage:[UIImage imageNamed:@"Discovery_index_1"] forState:UIControlStateNormal];
    [_index_1 setImage:[UIImage imageNamed:@"Discovery_index_1_highlighted"] forState:UIControlStateSelected];
    [_index_1 addTarget:self action:@selector(index_1ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _index_1.adjustsImageWhenHighlighted = NO;
    [titleView addSubview:_index_1];
    
    self.navigationItem.titleView = titleView;

}
#pragma mark - Getting Datas Methods

- (void)refreshDatas {
    self.pageIndex = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNews"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    //获取资讯
    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBDiscoveryResponseModel *responseModel = [BDBDiscoveryResponseModel objectWithKeyValues:responseObject];
        self.newsModels = responseModel.NewsList;
        [_tableView reloadData];
        ZXLLOG(@"NewsList:success..");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    //获取轮播图片
    NSString *picUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetAdvPic"];
    NSMutableDictionary *picParameters = [NSMutableDictionary dictionary];
    picParameters[@"PageNo"] = [NSString stringWithFormat:@"%lu",_pageNo];
    
    [manager POST:picUrl parameters:picParameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBDiscoveryAdvPicModel *advPicModel = [BDBDiscoveryAdvPicModel objectWithKeyValues:responseObject];
        NSString *string = advPicModel.PicList;
        NSArray *advPicUrls = [string componentsSeparatedByString:@","];
        self.advPicArray = [NSMutableArray array];
        for (NSString *urlStr in advPicUrls) {
            if (![urlStr isEqualToString:@""]) {
                NSURL *url = [NSURL URLWithString:urlStr];
                NSData *picData = [NSData dataWithContentsOfURL:url];
                UIImage *pic = [UIImage imageWithData:picData];
                [self.advPicArray addObject:pic];
            }
        }
        [self.tableView reloadData];
        if (_loadDataIndicatePage) {
            [_loadDataIndicatePage hide];

        }
        ZXLLOG(@"picUrls:%@",_advPicArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"advPic error response: %@",error);
    }];
    //获取问题类型

    
}

- (void)loadMoreDatas {
    self.pageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNews"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BDBDiscoveryResponseModel *newsResponseModel = [BDBDiscoveryResponseModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [self.newsModels addObjectsFromArray:newsResponseModel.NewsList];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    
}

#pragma mark - Privite Methods
- (void)initHeaderAndFooter {
    __weak typeof(self) thisInstance = self;
    
    //初始化表头部
    thisInstance.tableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        //刷新数据
        [thisInstance refreshDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.tableView.header endRefreshing];
    }];
    
    //初始化表尾部
    thisInstance.tableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        //加载更多数据
        [thisInstance loadMoreDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.tableView.footer endRefreshing];
    }];
  
}

#pragma mark - BDBCollectionCellDelegate Method
- (void)hotTopicsClicked {
    [self performSegueWithIdentifier:@"hotTopics" sender:self];
}
- (void)rookieButtonClicked {
    [self performSegueWithIdentifier:@"rookie" sender:self];
}
-(void)inverstmentGuideClicked {
    [self performSegueWithIdentifier:@"investmentGuide" sender:self];
}
-(void)securityAssuranceButtonClicked {
    [self performSegueWithIdentifier:@"securityAssurance" sender:self];
}
- (void)operationModeButtonClicked {
    [self performSegueWithIdentifier:@"operationMode" sender:self];
}
- (void)debitAndCreditButtonClicked {
    [self performSegueWithIdentifier:@"debitAndCredit" sender:self];
}
- (void)riskControlButtonClicked {
    [self performSegueWithIdentifier:@"riskControl" sender:self];
}
- (void)infoOfLawButtonClicked {
    [self performSegueWithIdentifier:@"infoOfLaw" sender:self];
}
- (void)creditorsRightsTransferButtonClicked {
    [self performSegueWithIdentifier:@"creditorsRightsTransfer" sender:self];
}
@end
