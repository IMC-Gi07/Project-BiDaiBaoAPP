//
//  ViewController.m
//  discover_encyclopedia_JT
//
//  Created by mianshuai on 15/6/11.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import "BDBDetailQuestionAndReplyViewController.h"
#import "BDBDetailQuestionTableViewCell.h"
#import "BDBDetailReplyTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AFNetworking.h"
#import "GlobalConfigurations.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "BDBDetailReplyModel.h"
#import "BDBDetailReplyResponseModel.h"
#import "IQKeyboardManager.h"
#import "ZXLLoadDataIndicatePage.h"
static NSString *const kCellIdentifier = @"cell";
static NSString *const kCellIdentifier2 = @"cell2";
@interface BDBDetailQuestionAndReplyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *answerTextField;

@property (nonatomic,assign) NSUInteger rowsNum;

@property (nonatomic,strong) ZXLLoadDataIndicatePage *loadDataIndicatePage;


/**
 问题
 */
@property(nonatomic,strong) NSDictionary *questionModel;

/**
 回复页数
 */
@property(nonatomic,assign) NSUInteger pageIndex;

/**
 每页显示数量
 */
@property(nonatomic,assign) NSUInteger pageSize;

@property (nonatomic,strong) NSMutableArray *detailReplyModels;
- (void)refreshDatas;

@end

@implementation BDBDetailQuestionAndReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _answerTextField.delegate = self;
    
    [self refreshDatas];
    
    _tableView.estimatedRowHeight = 150;
    self.loadDataIndicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    [_tableView registerNib:[UINib nibWithNibName:@"BDBDetailQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
     [_tableView registerNib:[UINib nibWithNibName:@"BDBDetailReplyTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier2];
    [self initHeaderAndFooter];
    
}
#pragma mark - 数据获取
- (void)refreshDatas{
    self.pageIndex = 1;
    self.pageSize = 5;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionInf"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取问题
    parameters[@"Machine_id"] = [UIDevice currentDevice].identifierForVendor.UUIDString;
    parameters[@"ID"] = _ID;
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        self.questionModel = responseObject;
        
        [_tableView reloadData];
        if (_loadDataIndicatePage) {
            [_loadDataIndicatePage hide];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    //获取回复
    NSString *replyUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionReply"];
    
    NSMutableDictionary *replyParameters = [NSMutableDictionary dictionary];
   
    replyParameters[@"ID"] = _ID;
    replyParameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    replyParameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    [manager POST:replyUrl parameters:replyParameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBDetailReplyResponseModel *responseModel = [BDBDetailReplyResponseModel objectWithKeyValues:responseObject];
        
        self.detailReplyModels = responseModel.QuestionReplyList;
        
        self.rowsNum = _detailReplyModels.count;

        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    
}

- (void)loadMoreDatas {
    self.pageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *replyUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionReply"];
    
    NSMutableDictionary *replyParameters = [NSMutableDictionary dictionary];
    
    replyParameters[@"ID"] = _ID;
    replyParameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    replyParameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    [manager POST:replyUrl parameters:replyParameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        BDBDetailReplyResponseModel *responseModel = [BDBDetailReplyResponseModel objectWithKeyValues:responseObject];
        
        [_detailReplyModels addObjectsFromArray:responseModel.QuestionReplyList];

        self.rowsNum = _detailReplyModels.count;
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_answerTextField resignFirstResponder];
    return YES;
}


#pragma mark - Reply Method
- (IBAction)presentButton:(UIButton *)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetSubmitQuestionReply"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //回复问题
    parameters[@"Machine_id"] = [UIDevice currentDevice].identifierForVendor.UUIDString;
    parameters[@"ID"] = _ID;
    NSString *answer = _answerTextField.text;
    if (![answer isEqualToString:@""]) {
        parameters[@"Answerinfo"] = answer;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *answerUser = [userDefaults objectForKey:@"UID"];
        if (answerUser == nil) {
            parameters[@"AnswerUser"] = @"1***8";
        }else {
            parameters[@"AnswerUser"] = answerUser;
        }
        parameters[@"UserType"] = [NSString stringWithFormat:@"%i",0];
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            if ([responseObject[@"Result"] isEqualToString:@"0"]) {
                _answerTextField.text = nil;
                [self refreshDatas];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"回复成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"回复失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];

    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"回复内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

    }
    
    
}

#pragma mark - TableViewCell Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return _rowsNum;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSInteger sectionNo = indexPath.section;
    
    if (sectionNo == 0) {

        BDBDetailQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (![_questionModel[@"AskUser"] isKindOfClass:[NSNull class]]) {
            NSString *user = _questionModel[@"AskUser"];
            if (user.length > 0) {
                cell.askUser.text = [self transformUserName:_questionModel[@"AskUser"]];
            }
            
        }
        if (![_questionModel[@"AskTime"] isKindOfClass:[NSNull class]]) {
            cell.askTime.text = _questionModel[@"AskTime"];
        }
        if (![_questionModel[@"Title"] isKindOfClass:[NSNull class]]) {
            cell.ask.text = _questionModel[@"Title"];
        }
        NSString *reply = _questionModel[@"ReplyNum"];
        if (![reply isKindOfClass:[NSNull class]]) {
            [cell.replyNum setTitle:reply forState:UIControlStateNormal];
        }
        cell.userInteractionEnabled = NO;
        return cell;
        
    }else if (sectionNo == 1){
        BDBDetailReplyModel *model = _detailReplyModels[indexPath.row];
        BDBDetailReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier2 forIndexPath:indexPath];
        if (![model.Timeinfo isKindOfClass:[NSNull class]]) {
            cell.timeLabel.text = model.Timeinfo;
        }
        if (![model.Answerinfo isKindOfClass:[NSNull class]]) {
            cell.contentLabel.text = model.Answerinfo;
        }
        if (![model.Hot isKindOfClass:[NSNull class]]) {
            cell.hot.text = model.Hot;
        }
        if (![model.AnswerUser isKindOfClass:[NSNull class]]) {
            if (model.AnswerUser.length > 0) {
                cell.titleLable.text = [self transformUserName:model.AnswerUser];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
   
    CGFloat hight;
    if (indexPath.section == 0) {
        return 93.0f;
    }else{
        
        return [tableView fd_heightForCellWithIdentifier:@"cell2" configuration:^(BDBDetailReplyTableViewCell *cell) {
            BDBDetailReplyModel *model = _detailReplyModels[indexPath.row];
            cell.timeLabel.text = model.Timeinfo;
            cell.contentLabel.text = model.Answerinfo;
            cell.hot.text = model.Hot;
            cell.titleLable.text = model.AnswerUser;
            
        }];
    }
    return hight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetHotNumber"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"ID"] = _ID;
        parameters[@"Type"] = @"1";
        BDBDetailReplyModel *model = _detailReplyModels[indexPath.row];
        parameters[@"ReplyID"] = model.ReplyID;
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            [self refreshDatas];
            BDBDetailReplyTableViewCell *selectedCell = (BDBDetailReplyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [selectedCell.praiseButton setImage:[UIImage imageNamed:@"support_icon"] forState:UIControlStateNormal];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"点赞失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.answerTextField resignFirstResponder];
    
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

@end
