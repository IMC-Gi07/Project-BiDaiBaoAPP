//
//  BDBDebitAndCreditViewController.m
//  BiDaiBaoAPP
//
//  Created by Tomoxox on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBDebitAndCreditViewController.h"
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
@interface BDBDebitAndCreditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;
//问题列表
@property (nonatomic,strong) NSMutableArray *questionListModels;
//问题页数
@property (nonatomic,assign) NSUInteger pageIndex;
//每页显示数量
@property (nonatomic,assign) NSUInteger pageSize;

@property (nonatomic,strong) ZXLLoadDataIndicatePage *loadDataIndicatePage;

@property (nonatomic,strong) NSMutableArray *userPhotosArray;

@property (nonatomic,assign) NSIndexPath *selectedIndexPath;
- (void)refreshDatas;
- (void)loadMoreDatas;
@end

@implementation BDBDebitAndCreditViewController
-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"借贷事宜";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 100;
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
        introductionCell.introductionLeadingImageView.image = UIImageWithName(@"discovey_debitAndCredit_img");
        introductionCell.introductionCellTitle.text = @"借贷事宜";
        introductionCell.userInteractionEnabled = NO;
        introductionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return introductionCell;
    }
    if (indexPath.row > 0) {
        BDBHotTopicsModel *model = _questionListModels[indexPath.row - 1];
        BDBQuestionContentCell *questionContentCell = [[NSBundle mainBundle] loadNibNamed:@"BDBQuestionContentCell" owner:nil options:nil][0];
        questionContentCell.title.text = model.Title;
        questionContentCell.firstReply.text = model.FirstReply;
        if (model.AskUser.length > 0) {
            NSString *userName = [self transformUserName:model.AskUser];
            questionContentCell.askUser.text = userName;
        }
        NSString *askTime = model.AskTime;
        NSString *simpleTime = [self transformDataFormat:askTime];
        ZXLLOG(@"-x-x-x-xx-x-x-x-x-x-x-x-x-x--x-x-xx-x--x--%@",simpleTime);
        questionContentCell.askTime.text = simpleTime;
        questionContentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return questionContentCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"DetailOfDebitAndCredit" sender:self];
    
    
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
- (NSString *)transformDataFormat:(NSString *)askTime {
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy-MM-d HH:mm:ss"];
    NSDate *askDate = [dateFomatter dateFromString:askTime];
    NSTimeInterval timeInterval = -[askDate timeIntervalSinceNow];
    NSString *simpleTime = @"";
    //NSInteger year = timeInterval / (60*60*24*365);
    NSInteger month = timeInterval / (60*60*24*30);
    NSInteger day = timeInterval / (60*60*24);
    NSInteger hour = timeInterval / (60*60);
    NSInteger minute = timeInterval / 60;
    if (month > 0) {
        simpleTime = [NSString stringWithFormat:@"%li月前",(long)month];
    }else if (day > 0) {
        simpleTime = [NSString stringWithFormat:@"%li天前",(long)day];
    }else if (hour > 0) {
        simpleTime = [NSString stringWithFormat:@"%li小时前",(long)hour];
    }else if (minute > 0) {
        simpleTime = [NSString stringWithFormat:@"%li分钟前",(long)minute];
    }else if (timeInterval > 0) {
        simpleTime = [NSString stringWithFormat:@"%li秒前",(long)timeInterval];
    }
    return simpleTime;
}

- (NSString *)transformUserName:(NSString *)userName {
    if ([userName isEqualToString:@"匿名"]) {
        return userName;
    }else {
        NSString *first = [userName substringToIndex:1];
        NSString *last = [userName substringFromIndex:(userName.length - 1)];
        NSString *temp = [first stringByAppendingString:@"***"];
        NSString *final = [temp stringByAppendingString:last];
        return final;
    }
    
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
    parameters[@"TypeID"] = [NSString stringWithFormat:@"%d",26];
    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBHotTopicsResponseModel *responseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        self.questionListModels = responseModel.QuestionList;
        [_tableView reloadData];
        if (_loadDataIndicatePage) {
            [_loadDataIndicatePage hide];

        }
        
        
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
    parameters[@"TypeID"] = [NSString stringWithFormat:@"%d",26];
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //ZXLLOG(@"success response: %@",responseObject);
        
        BDBHotTopicsResponseModel *questionResponseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [self.questionListModels addObjectsFromArray:questionResponseModel.QuestionList];
        
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"DetailOfDebitAndCredit" isEqualToString:segue.identifier]) {
        BDBHotTopicsModel *model = _questionListModels[_selectedIndexPath.row - 1];
        BDBDetailQuestionAndReplyViewController *detailQuestionAndReplyViewController = segue.destinationViewController;
        detailQuestionAndReplyViewController.ID = model.ID;
        
    }
}

@end