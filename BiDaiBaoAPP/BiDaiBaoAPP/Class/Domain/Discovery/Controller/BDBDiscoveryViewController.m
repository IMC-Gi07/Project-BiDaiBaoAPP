//
//  BDBDiscoveryViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/15.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBDiscoveryViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FLAnimatedImage.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBQuestionTypeListModel.h"
#import "BDBQuestionTypeModel.h"
#import "BDBQuestionTableViewCell.h"

#define kNoticeTableViewCellIdentifer @"QuestionCollectionViewCell"

@interface BDBDiscoveryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *questionTableView;

@property(nonatomic,weak) UITableView *noticeTableView;

/**
 公告数据
 */
@property(nonatomic,strong) NSMutableArray *noticeModels;

/**
 公告页数
 */
@property(nonatomic,assign) NSUInteger pageIndex;

/**
 每页显示数量
 */
@property(nonatomic,assign) NSUInteger pageSize;

@property (nonatomic,strong) NSMutableArray *QuestionTypeList;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;

@end

@implementation BDBDiscoveryViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"百科问答";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (void)loadMoreDatas {
    self.pageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionType"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ZXLLOG(@"success response: %@",responseObject);
        
        BDBQuestionTypeModel *questionTypeModel = [BDBQuestionTypeModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [self.noticeModels addObjectsFromArray:questionTypeModel.QuestionTypeList];
        
        //如果tableview已经存在，则重新加载数据
        [self.questionTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
}

- (void)refreshDatas {
    //刷新数据时，页数改为1
    self.pageIndex = 1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestionType"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //ZXLLOG(@"success response: %@",responseObject);
        
        BDBQuestionTypeModel *questionTypeModel = [BDBQuestionTypeModel objectWithKeyValues:responseObject];
        
         [self.noticeModels addObjectsFromArray:questionTypeModel.QuestionTypeList];
        
        [self initNoticeTableView];
        
        //如果tableview已经存在，则重新加载数据
        //[self.noticeTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
}

- (void)initNoticeTableView {
    UITableView *noticeTableView = [[UITableView alloc] init];
    noticeTableView.delegate = self;
    noticeTableView.dataSource = self;
    noticeTableView.estimatedRowHeight = 50;
    noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    noticeTableView.backgroundColor = UIColorWithRGB(239, 239, 239);
    
    __weak typeof(self) thisInstance = self;
    
    //初始化表头部
    noticeTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        //刷新数据
        [thisInstance refreshDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.questionTableView.header endRefreshing];
    }];
    
    //初始化表尾部
    noticeTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        //加载更多数据
        [thisInstance loadMoreDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.questionTableView.footer endRefreshing];
    }];
    
    noticeTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:noticeTableView];
    self.questionTableView = noticeTableView;
    
    for (NSString *visualFormat in @[@"H:|[noticeTableView]|",@"V:|[noticeTableView]|"]) {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:@{@"noticeTableView": noticeTableView}];
        [self.view addConstraints:constraints];
    }
    
    ZXLLOG(@"View Frame: %@",NSStringFromCGRect(self.view.frame));
    
    [UIView transitionFromView:_indicatePage toView:_noticeTableView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        ZXLLOG(@"animated View Frame: %@",NSStringFromCGRect(self.view.frame));
    }];
    
    //[_noticeTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _QuestionTypeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = kNoticeTableViewCellIdentifer;
    
    BDBQuestionTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [MAIN_BUNDLE loadNibNamed:@"BDBQuestionTableViewCell" owner:nil options:nil][0];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    BDBQuestionTypeListModel *typeListModerl = _QuestionTypeList[indexPath.row];
  
    
    tableViewCell.TypeIDLabel.text = typeListModerl.TypeID;
    tableViewCell.TypeNameLabel.text = typeListModerl.TypeName;
    
    return tableViewCell;
}
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
