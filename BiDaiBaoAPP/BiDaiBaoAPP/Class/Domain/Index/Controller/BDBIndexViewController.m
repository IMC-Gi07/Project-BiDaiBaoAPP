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
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "GlobalConfigurations.h"
#import "BDBIndexGuideMessageModel.h"
#import "ZXLLoadDataIndicatePage.h"



@interface BDBIndexViewController ()

@property(nonatomic,strong) BDBIndexGuideMessageModel *indexModel;

@property(nonatomic,strong) FLAnimatedImageView *earthGifImageView;

@property(nonatomic,strong) UIImageView *herderImageView;


@property (weak, nonatomic) IBOutlet UITableView *IndexTableView;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *loadDataIndicatePage;


- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem;


@end

@implementation BDBIndexViewController

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = @"比贷宝";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //显示加载页面
    //self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];

    
    
    UIImage *rightBarButtonImage = [UIImageWithName(@"index_nav_right") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickedAction:)];

    
    
    NSString *earthRotationFilePath = [[NSBundle mainBundle] pathForResource:@"earth" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:earthRotationFilePath];
    
    FLAnimatedImage *earthGifImage = [FLAnimatedImage animatedImageWithGIFData:data];
    FLAnimatedImageView *earthGifImageView = [[FLAnimatedImageView alloc] init];
    earthGifImageView.animatedImage = earthGifImage;
    
    [self.IndexTableView.tableHeaderView addSubview:earthGifImageView];
    
    self.earthGifImageView = earthGifImageView;
    
//    [self.IndexTableView.tableHeaderView setHidden:YES];
    
    self.herderImageView.bounds = CGRectMake(0, 0, 0, 250.0f);

    
//    UIImage *headerImage = [UIImage imageNamed:@"earth_03"];
//    
//    self.herderImageView = [[UIImageView alloc] initWithImage:headerImage];
//    self.herderImageView.bounds = CGRectMake(0, 0, 0, 250.0f);
//    self.IndexTableView.tableHeaderView = _herderImageView;
    
    
    __weak typeof (self) thisInstance = self;
    self.IndexTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        [thisInstance.IndexTableView.header endRefreshing];
    }];
    
    self.IndexTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        [thisInstance.IndexTableView.footer endRefreshing];
    }];
    //创建一个请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //调用请求对象的解析器
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    //GetRealTimeStatistics主机地址
    NSString *realTimeStatisticsUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetRealTimeStatistics"];
    NSMutableDictionary *RealTimeStatisticsDict = [NSMutableDictionary dictionary];
    RealTimeStatisticsDict[@"PlatFormID"] = @"-1";
    
    [manager POST:realTimeStatisticsUrl parameters:RealTimeStatisticsDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBIndexGuideMessageModel *indexResponseModel = [BDBIndexGuideMessageModel objectWithKeyValues:responseObject];
        self.indexModel = indexResponseModel;
        
        [self.IndexTableView reloadData];
//        NSLog(@"%@",self.indexModel.AmountRemain);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
    
    NSString *noticeUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNotice"];
//    NSMutableDictionary *noticeDict =

}


- (void)rightBarButtonClickedAction:(UIBarButtonItem *)buttonItem {
    [self performSegueWithIdentifier:@"ToNoticeViewControllerSegue" sender:self];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        BDBMessageTableViewCell *cell = [BDBMessageTableViewCell cell];
        cell.userInteractionEnabled = NO;
        return cell;

    }else if (indexPath.row == 1) {
        BDBParameterTableViewCell *cell = [BDBParameterTableViewCell cell];
        cell.AmountRemainLabel.text = _indexModel.AmountRemain;
        cell.BidNumLabel.text = _indexModel.BidNum;
        cell.EarningsMaxLabel.text = _indexModel.EarningsMax;
        NSLog(@"%@",_indexModel.EarningsMax);
        cell.InvestorNumLabel.text = _indexModel.InvestorNum;
        NSLog(@"%@",_indexModel.AmountRemain);
        cell.userInteractionEnabled = NO;
//        [cell.hideAndShowButton addTarget:self action:@selector(hideAndShow) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.row == 2) {
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
    }else {
        BDBDetailedMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [BDBDetailedMessageTableViewCell cell];
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row - 2];
            NSMutableAttributedString *percentNumber = [[NSMutableAttributedString alloc] initWithString:@"25%"];
            [percentNumber addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(2, 1)];
            cell.messageLabel.attributedText = percentNumber;
        }
        return cell;

    }
}

- (void)hideAndShow {
    CGRect imageViewBounds = self.herderImageView.bounds;
    
    if (imageViewBounds.size.height == 250.0f) {
        imageViewBounds.size.height = 0;
    }else if (imageViewBounds.size.height == 0) {
        imageViewBounds.size.height = 250;
    }
}



#pragma mark - GestureRecognizer
- (void)changeRedMessage: (UIGestureRecognizer *)gesture {
    
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    
    //NSLog(@"%@",gesture.view.superview.superview);
    
    cell.redView.backgroundColor = [UIColor redColor];
    
    
    cell.blueView.backgroundColor = [UIColor colorWithRed:64/255.0f green:132/255.0f blue:249/255.0f alpha:1];
    
    
    cell.greenView.backgroundColor = [UIColor colorWithRed:87/255.0f green:206/255.0f blue:82/255.0f alpha:1];

    
    
}

- (void)changeGreenMessage: (UIGestureRecognizer *)gesture {
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    cell.greenView.backgroundColor = [UIColor greenColor];
    
    cell.blueView.backgroundColor = [UIColor colorWithRed:64/255.0f green:132/255.0f blue:249/255.0f alpha:1];
    
    cell.redView.backgroundColor = [UIColor colorWithRed:224/255.0f green:62/255.0f blue:74/255.0f alpha:1];
}

- (void)changeBlueMessage: (UIGestureRecognizer *)gesture {
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)gesture.view.superview.superview;
    cell.blueView.backgroundColor = [UIColor blueColor];
    
    cell.redView.backgroundColor = [UIColor colorWithRed:224/255.0f green:62/255.0f blue:74/255.0f alpha:1];
    
        cell.greenView.backgroundColor = [UIColor colorWithRed:87/255.0f green:206/255.0f blue:82/255.0f alpha:1];
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hight = 0;
    if (indexPath.row == 0) {
        hight = 30;
    }else if (indexPath.row == 1) {
        hight = 100;
    }else if (indexPath.row == 2) {
        hight = 66;
    }else {
        hight = 44;
    }
    return hight;
}

@end
