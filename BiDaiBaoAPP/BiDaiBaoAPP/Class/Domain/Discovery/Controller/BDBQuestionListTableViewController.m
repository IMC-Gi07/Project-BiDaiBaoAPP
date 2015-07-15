//
//  BDBQuestionTableViewController.m
//  BiDaiBaoAPP
//
//  Created by moon on 15/7/8.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.





#import "ZXLLoadDataIndicatePage.h"
#import "BDBHotTopicsModel.h"
#import "BDBFindQuestionGrabbleController.h"
#import "BDBHotTopicsResponseModel.h"
#import "BDBQuestionListTableViewController.h"
#import "BDBQuestionListDetailViewController.h"
#import "BDBDetailQuestionAndReplyViewController.h"

#import "BDBQuestionListTableViewCell.h"
#import "BDBQuestionListNotFindTableViewCell.h"

@interface BDBQuestionListTableViewController () <UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *questionListTableView;




@property (nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;
@property (nonatomic,strong) NSIndexPath *selectedModelIndexPath;

@property (nonatomic,assign) NSInteger PageSize;
@property (nonatomic,assign) NSInteger PageIndex;
@property (nonatomic,weak) id cell;
@property (nonatomic,assign) NSInteger numberOfRows;

@property (nonatomic,assign) NSInteger exeCellForRowAtIndexPathTime;


/**
 *  加载数据
 */
- (void)loadMoreData;

/**
 * 刷新数据
 */
- (void)refreshData;

/**
 初始化initQuestionTableView
 */
- (void)initQuestionTableView;


@end

@implementation BDBQuestionListTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"搜索内容";
       
   
        self.exeCellForRowAtIndexPathTime = 1;
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PageSize = 10;
    NSLog(@"%@",_TitleKey);
    [self initQuestionTableView];
//      [self.questionListTableView reloadData];
//    self.navigationController.navigationBarHidden = YES;
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    
    [self refreshData];

}




- (void)initQuestionTableView {
    	_questionListTableView.estimatedRowHeight = 50;
    [_questionListTableView registerNib:[UINib nibWithNibName:@"BDBQuestionListTableViewCell" bundle:nil] forCellReuseIdentifier:@"questionListTableViewCell"];
    
    [_questionListTableView registerNib:[UINib nibWithNibName:@"BDBQuestionListNotFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"questionListNotFindTableViewCell"];
    
    //初始化表头部
    
     __weak typeof(self) thisInstance = self;
    _questionListTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
       
        //刷新数据
        [thisInstance refreshData];
    }];
    
    //初始化表尾部
    _questionListTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{

        //加载更多数据
        [thisInstance loadMoreData];
    }];
}
- (void)refreshData {
    _PageIndex = 1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *UID = [userDefaults objectForKey:@"UID"];
    
    if (UID) {
        parameters[@"UID"] = UID;
    }
    parameters[@"UserType"] = @"0";
    
    NSString *PSW = [userDefaults objectForKey:@"PSW"];
    if (PSW) {
        parameters[@"PSW"] = PSW;
    }
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    parameters[@"TitleKey"] = [NSString stringWithFormat:@"%@",_TitleKey];
    ZXLLOG(@"%@",_TitleKey);
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",
                                (unsigned long)_PageIndex];
    ZXLLOG(@"%lu",(long)_PageIndex);
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",(unsigned long)_PageSize];
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        ZXLLOG(@"success response: %@",responseObject);
        
     
        
        BDBHotTopicsResponseModel *questionResponseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        
        self.getQuestionsModels = questionResponseModel.QuestionList;
        
        if (_indicatePage) {
            [_indicatePage hide];
            self.navigationController.navigationBarHidden = NO;
        }else {
            [_questionListTableView.header endRefreshing];
        }
        
        [_questionListTableView reloadData];

        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)loadMoreData {
    
    _PageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *UID = [userDefaults objectForKey:@"UID"];
    
    if (UID) {
        parameters[@"UID"] = UID;
    }
    parameters[@"UserType"] = @"0";
    
    NSString *PSW = [userDefaults objectForKey:@"PSW"];
    if (PSW) {
        parameters[@"PSW"] = PSW;
    }
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    parameters[@"TitleKey"] = [NSString stringWithFormat:@"%@",_TitleKey];
    ZXLLOG(@"%@",_TitleKey);
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",
                                (unsigned long)_PageIndex];
    ZXLLOG(@"%lu",(long)_PageIndex);
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",(unsigned long)_PageSize];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        ZXLLOG(@"success response: %@",responseObject);
        
        
        BDBHotTopicsResponseModel *questionResponseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [_getQuestionsModels addObjectsFromArray:questionResponseModel.QuestionList];
        
        //刷新完数据后，回收头部
        [_questionListTableView.footer endRefreshing];
        
        //如果tableview已经存在，则重新加载数据
        [_questionListTableView reloadData];

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = UIColorWithRGB(239, 239, 239);
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_getQuestionsModels.count == 0) {
        self.numberOfRows = 1;
    } else {
        self.numberOfRows = _getQuestionsModels.count;
    }
    return _numberOfRows ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"questionListTableViewCell";
    static NSString *celldentifier = @"questionListNotFindTableViewCell";
    if (_getQuestionsModels.count != 0)
    {
        
        self.questionListTableView.rowHeight = 80;
        self.questionListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        BDBQuestionListTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        BDBHotTopicsModel *hotTopicsModel = _getQuestionsModels[indexPath.row];
        
        tableViewCell.titleLabel.text = hotTopicsModel.Title;
        tableViewCell.timeLabel.text = hotTopicsModel.AskTime;
        self.cell = tableViewCell;
        
    }else{
        
        
        BDBQuestionListNotFindTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:celldentifier forIndexPath:indexPath];
        self.questionListTableView.rowHeight = 200;
        self.questionListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.questionListTableView.userInteractionEnabled = YES;
        if (_exeCellForRowAtIndexPathTime > 1) {
            UIButton *questionButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [questionButton addTarget:self action:@selector(askQuestionTitle) forControlEvents:UIControlEventTouchUpInside];
            questionButton.backgroundColor = [UIColor blueColor];
            
            [questionButton setTitle:@"我要提问" forState:UIControlStateNormal];
            [questionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [questionButton.layer setCornerRadius:15.0f];
            [self.view addSubview:questionButton];
            
            //            生成提示title
            UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            
            questionLabel.textColor = [UIColor grayColor];
            questionLabel.text = @"暂无您要搜索的内容，请点击我要提问的按钮";
            [questionLabel setFont: [UIFont fontWithName:@"TrebuchetMS-Bold" size:SCREEN_WIDTH / 23]];
            [self.view addSubview:questionLabel];
            
            questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
            questionButton.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *questionButtonWidthConstranint = [NSLayoutConstraint constraintWithItem:questionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:SCREEN_WIDTH * 0.6f];
            
            NSLayoutConstraint *questionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:questionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:100.0f];
            
            NSLayoutConstraint *questionLabelCenterXConstranint = [NSLayoutConstraint constraintWithItem:questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            
            
            NSLayoutConstraint *questionButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:questionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:questionLabel attribute:NSLayoutAttributeBottom multiplier:1.0f constant:10.0f];
            
            NSLayoutConstraint *questionButtonCenterXConstranint = [NSLayoutConstraint constraintWithItem:questionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:questionLabel attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            [self.view addConstraint:questionLabelCenterXConstranint];
            [self.view addConstraint:questionLabelHeightConstraint];
            [self.view addConstraint:questionButtonCenterXConstranint];
            [self.view addConstraint:questionButtonHeightConstraint];
            [self.view addConstraint:questionButtonWidthConstranint];

        }
        
        
        _exeCellForRowAtIndexPathTime ++;
        
        self.cell = tableViewCell;
        
    }
    return _cell;
}
- (void)askQuestionTitle{
   [self performSegueWithIdentifier:@"askQuestion" sender:self];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedModelIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"toBDBQuestionListDetailViewController"
                              sender:self];
}
#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"toBDBQuestionListDetailViewController" isEqualToString:segue.identifier]) {
        BDBHotTopicsModel *model = _getQuestionsModels[_selectedModelIndexPath.row];
        BDBDetailQuestionAndReplyViewController *detailQuestionAndReplyViewController = segue.destinationViewController;
        detailQuestionAndReplyViewController.ID = model.ID;
        
    }
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

