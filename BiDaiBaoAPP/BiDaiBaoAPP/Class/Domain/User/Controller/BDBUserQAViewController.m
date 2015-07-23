//
//  BDBQAViewController.m
//  User_Version
//
//  Created by Imcore.olddog.cn on 15/6/16.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBUserQAViewController.h"
#import "BDBUserTableViewCell.h"
#import "BDBUserQestionsResponseModel.h"
#import "BDBUserQestionsModel.h"
#import "BDBUserQuestionTypeResponseModel.h"
#import "BDBUserQuestionTypeModel.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBUserAnswerResponseModel.h"
#import "BDBUserAnswerModel.h"
#import "BDBDetailQuestionAndReplyViewController.h"
typedef enum{
    questionPage,answerPage
} CurrentPage;

typedef enum{
    pullUpRefresh,dropDownRefresh} RefreshWays;

@interface BDBUserQAViewController ()<UITableViewDataSource,UITableViewDelegate,BDBUserTableViewCellDelegate>



@property(nonatomic,assign) NSInteger pageIndex_quetion;
@property(nonatomic,assign) NSInteger pageSize_question;

@property(nonatomic,assign) NSInteger pageIndex_answer;
@property(nonatomic,assign) NSInteger pageSize_answer;

@property(nonatomic,weak) UITableView *questionAndReplyTabelView;
@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;

@property(nonatomic,strong) NSMutableArray *questionModels;

@property(nonatomic,strong) NSMutableArray *questionTypeModels;

@property(nonatomic,strong) NSMutableArray *answerModels;

@property(nonatomic,assign) CurrentPage currentPage;

- (void)loadQuestionsWithRefreshWay:(RefreshWays)refreshway;

- (void)loadMyAnwserWithRefreshWay:(RefreshWays)refreshway;

- (void)loadSelectQorAView;

- (void)loadTableView;

- (void)loadAllQuestionsType;

- (void)swithQuestionOrAnswer:(UISegmentedControl *)segment;

@end

@implementation BDBUserQAViewController

- (instancetype)init{
    
    if(self = [super init]){
        
        self.title = @"我的问答";
        self.hidesBottomBarWhenPushed = YES;
        
        self.pageIndex_quetion = 1;
        self.pageSize_question = 10;
        
        self.pageIndex_answer = 1;
        self.pageSize_answer = 10;
    
        [self loadAllQuestionsType];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSelectQorAView];
    [self loadTableView];
    
    self.currentPage = questionPage;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//初始化表格
- (void)loadTableView{
    
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.estimatedRowHeight = 80.0f;
    
    [tableView registerNib:[UINib nibWithNibName:@"BDBUserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"userQACellIdentifier"];
    
    [self.view addSubview:tableView];
    
    self.questionAndReplyTabelView = tableView;
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView":tableView}];
    
    [self.view addConstraints:constraints];
    
    UIView *questionOrAnswerBackgroundView = [self.view viewWithTag:100];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[questionOrAnswerBackgroundView][tableView]|" options:0 metrics:nil views:@{@"tableView":tableView,@"questionOrAnswerBackgroundView":questionOrAnswerBackgroundView}];
    
    [self.view addConstraints:constraints];
    
    tableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        
        if(_currentPage == questionPage){
            
            [self loadQuestionsWithRefreshWay:pullUpRefresh];
        }
        if(_currentPage == answerPage){
            
            [self loadMyAnwserWithRefreshWay:pullUpRefresh];
        }
        
    }];
    tableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        
        if(_currentPage == questionPage){
            
            [self loadQuestionsWithRefreshWay:dropDownRefresh];
        }
        if(_currentPage == answerPage){
            
            [self loadMyAnwserWithRefreshWay:dropDownRefresh];
        }

    }];
}


//加载我的问题和我的回答选项

- (void)loadSelectQorAView{
    
    UIView *questionOrAnswerBackgroundView = [[UIView alloc] init];
    
    questionOrAnswerBackgroundView.tag = 100;
    
    [self.view addSubview:questionOrAnswerBackgroundView];
    
    questionOrAnswerBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[questionOrAnswerBackgroundView]|" options:0 metrics:nil views:@{@"questionOrAnswerBackgroundView":questionOrAnswerBackgroundView}];
    
    [self.view addConstraints:hConstraints];
    
    NSLayoutConstraint *topConstrainForQorABackgroundView = [NSLayoutConstraint constraintWithItem:questionOrAnswerBackgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:topConstrainForQorABackgroundView];
    
    NSLayoutConstraint *heightConstraintForQorABackgroundView = [NSLayoutConstraint constraintWithItem:questionOrAnswerBackgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:100.0f];
    
    [questionOrAnswerBackgroundView addConstraint:heightConstraintForQorABackgroundView];
    
    UISegmentedControl *questionOrAnswerSegmented = [[UISegmentedControl alloc] initWithItems:@[@"我的问题",@"我的回答"]];
    
    questionOrAnswerSegmented.selectedSegmentIndex = 0;
    
    questionOrAnswerSegmented.bounds = CGRectMake(0, 0, 200, 30);
    
    questionOrAnswerSegmented.center = CGPointMake(SCREEN_WIDTH / 2, 50);
    
    [questionOrAnswerSegmented addTarget:self action:@selector(swithQuestionOrAnswer:) forControlEvents:UIControlEventValueChanged];
    
    [questionOrAnswerBackgroundView addSubview:questionOrAnswerSegmented];
    
}


/**
 *  根据刷新方式加载所有问题
 */
- (void)loadQuestionsWithRefreshWay:(RefreshWays)refreshway{
    
    if(refreshway == pullUpRefresh){
    
        self.pageIndex_quetion = 1;
    }
    else{
    
        self.pageIndex_quetion ++;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";
    //后期从个人偏好中获取
    parameterDict[@"AskUser"] = @"15160006950";
    parameterDict[@"PageIndex"] = [NSString stringWithFormat:@"%li",(long)_pageIndex_quetion];
    parameterDict[@"PageSize"] = [NSString stringWithFormat:@"%li",(long)_pageSize_question];

    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBUserQestionsResponseModel *responseModel = [BDBUserQestionsResponseModel objectWithKeyValues:responseObject];
        
        if(refreshway == pullUpRefresh){
            
            self.questionModels = responseModel.QuestionList;
            [_questionAndReplyTabelView.header endRefreshing];
        }
        else{
            
            [self.questionModels arrayByAddingObjectsFromArray:responseModel.QuestionList];
            [_questionAndReplyTabelView.footer endRefreshing];
        }
        
        if(_indicatePage != nil){
        
            [_indicatePage hide];
        }
        
       [self.questionAndReplyTabelView reloadData];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

/**
 *  获取所有问题类别（后期可从数据库中获取）
 */
- (void)loadAllQuestionsType{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *uid = [userDefault objectForKey:@"UID"];
    
    NSString *psw = [userDefault objectForKey:@"PSW"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionType"];
    
    NSMutableDictionary *parameterDict =[NSMutableDictionary dictionary];
    
    parameterDict[@"UID"] = uid;
    parameterDict[@"PSW"] = psw;
    parameterDict[@"UserType"] = @"0";
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";

    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
    
        BDBUserQuestionTypeResponseModel *responseModel = [BDBUserQuestionTypeResponseModel objectWithKeyValues:responseObject];
        
        self.questionTypeModels = responseModel.QuestionTypeList;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"%@",error);
    }];
}


/**
 *  根据刷新方式加载我的回复
 */
- (void)loadMyAnwserWithRefreshWay:(RefreshWays)refreshway{
    
    if(refreshway == pullUpRefresh){
        
        self.pageIndex_answer = 1;
    }
    else{
        
        self.pageIndex_answer ++;
    }
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *uid = [userDefault objectForKey:@"UID"];
    
    NSString *psw = [userDefault objectForKey:@"PSW"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionReply"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";
    //后期从个人偏好中获取
    parameterDict[@"UID"] = uid;
    parameterDict[@"PSW"] = psw;
    parameterDict[@"UserType"] = @"0";
    parameterDict[@"AnswerUser"] = uid;
    
    
    parameterDict[@"PageIndex"] = [NSString stringWithFormat:@"%li",(long)_pageIndex_answer];
    parameterDict[@"PageSize"] = [NSString stringWithFormat:@"%li",(long)_pageSize_answer];
    
    
    
    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBUserAnswerResponseModel *responseModel = [BDBUserAnswerResponseModel objectWithKeyValues:responseObject];
        
        if(refreshway == pullUpRefresh){
            
            self.answerModels = responseModel.QuestionReplyList;
            [_questionAndReplyTabelView.header endRefreshing];
        }
        else{
            
            [self.answerModels arrayByAddingObjectsFromArray:responseModel.QuestionReplyList];
            [_questionAndReplyTabelView.footer endRefreshing];
        }
        
        if(_indicatePage != nil){
            
            [_indicatePage hide];
        }
        [self.questionAndReplyTabelView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

/**
 *  切换我的问题或者我的回复
 */
- (void)swithQuestionOrAnswer:(UISegmentedControl *)segment{

    if(segment.selectedSegmentIndex == 0){
    
        self.currentPage = questionPage;
    }
    else{
    
        self.currentPage = answerPage;
        
    }

}

#pragma mark - Setter And Getter Methods

- (void)setCurrentPage:(CurrentPage)currentPage{

    _currentPage = currentPage;
    
    if(_currentPage == questionPage){
    
        [self loadQuestionsWithRefreshWay:pullUpRefresh];
    }
    if(_currentPage == answerPage){
    
        [self loadMyAnwserWithRefreshWay:pullUpRefresh];
    }
    
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
}


#pragma mark - TableView Delegate And DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger numberOfRows = 0;
    
    if(_currentPage == questionPage){
    
        numberOfRows = _questionModels.count;
    
    }
    
    if(_currentPage == answerPage){
    
        numberOfRows = _answerModels.count;
    }
    
    return numberOfRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BDBUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userQACellIdentifier" forIndexPath:indexPath];
    
    if (_currentPage == questionPage) {
        
        BDBUserQestionsModel *questionModel = _questionModels[indexPath.row];
        
        __block NSString *typeName;
        
        [_questionTypeModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BDBUserQuestionTypeModel *questionTypeModel = obj;
            
            if ([questionModel.TypeID isEqualToString:questionTypeModel.TypeID]) {
                typeName = questionTypeModel.TypeName;
                
                *stop = YES;
            }
        }];
        
        cell.contentQuestionLabel.text = questionModel.Title;
        
        cell.questonTypeLabel.text = typeName;
        
        cell.questionAskTimeLabel.text = questionModel.AskTime;
        
        cell.answerLebel.text = @"";
		
		cell.questionModel = questionModel;
        
    }
    
    if(_currentPage == answerPage){
        
        BDBUserAnswerModel  *answerModel = _answerModels[indexPath.row];

        
        __block NSString *typeName;
        
        [_questionTypeModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BDBUserQuestionTypeModel *questionTypeModel = obj;
            
            if ([answerModel.TypeID isEqualToString:questionTypeModel.TypeID]) {
                typeName = questionTypeModel.TypeName;
                *stop = YES;
            }
        }];
        
        cell.contentQuestionLabel.text = answerModel.Title;
        
        cell.questonTypeLabel.text = typeName;
        
        cell.questionAskTimeLabel.text = answerModel.Timeinfo;
        
        cell.answerLebel.text = answerModel.Answerinfo;
		
		cell.answerModel = answerModel;
    }
	
	cell.delegate = self;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{

    return [tableView fd_heightForCellWithIdentifier:@"userQACellIdentifier" configuration:^(BDBUserTableViewCell *cell) {
        
        if (_currentPage == questionPage) {
            
            BDBUserQestionsModel *questionModel = _questionModels[indexPath.row];
            
            cell.contentQuestionLabel.text = questionModel.Title;
            
            cell.questonTypeLabel.text = questionModel.TypeID;
            
            cell.questionAskTimeLabel.text = questionModel.AskTime;
            
            cell.answerLebel.text = @"";
            
        }
        
        if(_currentPage == answerPage){
            
            BDBUserAnswerModel  *answerModel = _answerModels[indexPath.row];
            
            __block NSString *typeName;
            
            [_questionTypeModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                BDBUserQuestionTypeModel *questionTypeModel = obj;
                
                if ([answerModel.TypeID isEqualToString:questionTypeModel.TypeID]) {
                    typeName = questionTypeModel.TypeName;
                    *stop = YES;
                }
            }];
            
            cell.contentQuestionLabel.text = answerModel.Title;
            
            cell.questonTypeLabel.text = typeName;
            
            cell.questionAskTimeLabel.text = answerModel.Timeinfo;
            
            cell.answerLebel.text = answerModel.Answerinfo;
        }
    }];
}

#pragma mark -BDBUserTableViewCellDelegate Method

- (void)pushDestinationController:(NSString *)modelID{

	UIStoryboard *discover = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
	
	BDBDetailQuestionAndReplyViewController *controller = [discover instantiateViewControllerWithIdentifier:@"BDBDetailQuestionAndReplyViewController"];
	
	controller.ID = modelID;
	
	[self.navigationController pushViewController:controller animated:YES];
	

}

@end
