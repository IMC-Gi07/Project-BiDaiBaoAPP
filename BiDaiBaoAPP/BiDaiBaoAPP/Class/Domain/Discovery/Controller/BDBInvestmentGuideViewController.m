//
//  BDBInvestmentGuideViewController.m
//  BiDaiBaoAPP
//
//  Created by Tomoxox on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBInvestmentGuideViewController.h"
#import "BDBHotTopicsMainViewController.h"
#import "BDBHotTopicIntroductionCell.h"
#import "BDBQuestionContentCell.h"
#import "BDBHotTopicsModel.h"
#import "BDBHotTopicsResponseModel.h"
#import "GlobalConfigurations.h"
#import "BDBTableViewRefreshHeader.h"
#import "BDBTableViewRefreshFooter.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBDetailQuestionAndReplyViewController.h"
@interface BDBInvestmentGuideViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *investmentGuideTableView;


@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;
//问题列表
@property (nonatomic,strong) NSMutableArray *questionListModels;
//问题页数
@property (nonatomic,assign) NSUInteger pageIndex;
//每页显示数量
@property (nonatomic,assign) NSUInteger pageSize;

@property (nonatomic,strong) ZXLLoadDataIndicatePage *loadDataIndicatePage;
@property (nonatomic,assign) NSIndexPath *selectedIndexPath;
- (void)refreshDatas;
- (void)loadMoreDatas;
@end

@implementation BDBInvestmentGuideViewController
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"投资指南";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _investmentGuideTableView.delegate = self;
    _investmentGuideTableView.dataSource = self;
    _investmentGuideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.investmentGuideTableView.estimatedRowHeight = 100;
    [self generateQuestionButton];
    self.pageSize = 5;
    [self initHeaderAndFooter];

    self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    [self refreshDatas];
    
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if (indexPath.row == 0) {
        return 120;
    }
    if (indexPath.row >= 1) {
        
        return 100;
        
    }
    return height;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _questionListModels.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        BDBHotTopicIntroductionCell *introductionCell = [[NSBundle mainBundle] loadNibNamed:@"BDBHotTopicIntroductionCell" owner:nil options:nil][0];
        introductionCell.introductionLeadingImageView.image = UIImageWithName(@"discovery_investmentGuide_img");
        introductionCell.introductionCellTitle.text = @"投资指南";
        introductionCell.userInteractionEnabled = NO;
        introductionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return introductionCell;
    }
    if (indexPath.row > 0) {
        BDBHotTopicsModel *model = _questionListModels[indexPath.row - 1];
        BDBQuestionContentCell *questionContentCell = [[NSBundle mainBundle] loadNibNamed:@"BDBQuestionContentCell" owner:nil options:nil][0];
        questionContentCell.title.text = model.Title;
        questionContentCell.firstReply.text = model.FirstReply;
        questionContentCell.askUser.text = model.AskUser;
        questionContentCell.askTime.text = model.AskTime;
        questionContentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return questionContentCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"DetailOfInvestmentGuide" sender:self];
    
    
}

#pragma mark - QuestionButton Clicked Action
- (void)questionButtonClickedAction {
    [self performSegueWithIdentifier:@"searchQuestions" sender:self];
}


#pragma mark - Privite Methods
- (void)generateQuestionButton {
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [questionBtn setImage:[UIImage imageNamed:@"hotTopics_questionBtn_img"] forState:UIControlStateNormal];
    [self.view addSubview:questionBtn];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:70];
    [questionBtn addConstraints:@[width,height]];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-10];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10];
    [self.view addConstraints:@[trailing,bottom]];
    
    [questionBtn addTarget:self action:@selector(questionButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Getting Datas Methods

- (void)refreshDatas {
    self.pageIndex = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    parameters[@"TypeID"] = [NSString stringWithFormat:@"%d",23];
    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBHotTopicsResponseModel *responseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        self.questionListModels = responseModel.QuestionList;
        [_investmentGuideTableView reloadData];
        if (_loadDataIndicatePage) {
            [_loadDataIndicatePage hide];

        }
        BDBHotTopicsModel *model = [_questionListModels lastObject];
        ZXLLOG(@"===========> %@",model.ID);
        
        ZXLLOG(@"_questionListModels success..");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
}

- (void)loadMoreDatas {
    self.pageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    parameters[@"TypeID"] = [NSString stringWithFormat:@"%d",23];
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //ZXLLOG(@"success response: %@",responseObject);
        
        BDBHotTopicsResponseModel *questionResponseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [self.questionListModels addObjectsFromArray:questionResponseModel.QuestionList];
        
        [self.investmentGuideTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
}

#pragma mark - Privite Methods
- (void)initHeaderAndFooter {
    __weak typeof(self) thisInstance = self;
    
    //初始化表头部
    thisInstance.investmentGuideTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        //刷新数据
        [thisInstance refreshDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.investmentGuideTableView.header endRefreshing];
    }];
    
    //初始化表尾部
    thisInstance.investmentGuideTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        //加载更多数据
        [thisInstance loadMoreDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.investmentGuideTableView.footer endRefreshing];
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"DetailOfInvestmentGuide" isEqualToString:segue.identifier]) {
        BDBHotTopicsModel *model = _questionListModels[_selectedIndexPath.row - 1];
        BDBDetailQuestionAndReplyViewController *detailQuestionAndReplyViewController = segue.destinationViewController;
        detailQuestionAndReplyViewController.ID = model.ID;
        
    }
}

@end