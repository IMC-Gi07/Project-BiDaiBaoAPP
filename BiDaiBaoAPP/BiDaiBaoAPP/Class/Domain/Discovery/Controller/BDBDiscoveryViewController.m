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
#import "BDBHotTopicsResponseModel.h"
#import "BDBHotTopicsModel.h"
#import "BDBQuestionTableViewCell.h"

#define kNoticeTableViewCellIdentifer @"QuestionCollectionViewCell"

typedef enum {
    
    notDisplay,
    display
    
}questiontState;

@interface BDBDiscoveryViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *questionTableView;



@property(nonatomic,weak) UITableView *questionTableView;

/**
 公告数据
 */
@property(nonatomic,strong) NSMutableArray *noticeModels;

/**
 公告页数
 */

@property (nonatomic,copy) NSString *TitleKey;


@property(nonatomic,assign) NSUInteger PageIndex;

/**
 每页显示数量
 */

@property(nonatomic,assign) NSUInteger PageSize;

@property (nonatomic,strong) NSMutableArray *QuestionTypeList;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;

@property (nonatomic,assign) NSInteger textStringCount;

//@property (nonatomic,weak) UIButton *questionButton;

@property (nonatomic,assign) questiontState state;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

@implementation BDBDiscoveryViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"百科问答";
        _state = display;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextField.delegate = self;
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *textString = self.searchTextField.text;
    self.textStringCount = textString.length;
    
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.keyboardType = UIKeyboardTypeDefault;
    
    self.TitleKey = textString;
    if (_textStringCount >0) {
        [self loadMoreDatas];
    }
   
    return YES;
}

- (void)loadMoreDatas {
    self.PageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"TitleKey"] = [NSString stringWithFormat:@"%@",_TitleKey];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",
                                (unsigned long)_PageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",(unsigned long)_PageSize];
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
        ZXLLOG(@"success response: %@",responseObject);
        
        BDBHotTopicsResponseModel *questionTypeModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [self.noticeModels addObjectsFromArray:questionTypeModel.QuestionList];
        
        //如果tableview已经存在，则重新加载数据
        [self.questionTableView reloadData];
        if (questionTypeModel.QuestionNum == 0) {
            
            if (_state == display) {
                //            生成提示button
                UIButton *questionButton = [[UIButton alloc] initWithFrame:CGRectZero];
                
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
                
                NSLayoutConstraint *questionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:questionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchTextField attribute:NSLayoutAttributeBottom multiplier:1.0f constant:10.0f];
                
                NSLayoutConstraint *questionLabelCenterXConstranint = [NSLayoutConstraint constraintWithItem:questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.searchTextField attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
                
                
                
                NSLayoutConstraint *questionButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:questionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:questionLabel attribute:NSLayoutAttributeBottom multiplier:1.0f constant:10.0f];
                
                NSLayoutConstraint *questionButtonCenterXConstranint = [NSLayoutConstraint constraintWithItem:questionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:questionLabel attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
                
                [self.view addConstraint:questionLabelCenterXConstranint];
                [self.view addConstraint:questionLabelHeightConstraint];
                [self.view addConstraint:questionButtonCenterXConstranint];
                [self.view addConstraint:questionButtonHeightConstraint];
                [self.view addConstraint:questionButtonWidthConstranint];
                _state = notDisplay;
            }
           
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    
}

- (void)refreshDatas {
    //刷新数据时，页数改为1
    self.PageIndex = 1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    parameters[@"TitleKey"] = [NSString stringWithFormat:@"%@",_TitleKey];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",
                                (unsigned long)_PageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",(unsigned long)_PageSize];
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
       
        
        BDBHotTopicsResponseModel *questionTypeModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        
         [self.noticeModels addObjectsFromArray:questionTypeModel.QuestionList];
        
        [self initNoticeTableView];
        
        //如果tableview已经存在，则重新加载数据
        //[self.noticeTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];

}

- (void)initNoticeTableView {
    UITableView *questionTableView = [[UITableView alloc] init];
    questionTableView.delegate = self;
    questionTableView.dataSource = self;
    questionTableView.estimatedRowHeight = 50;
    questionTableView.backgroundColor = [UIColor grayColor];
    questionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    questionTableView.backgroundColor = UIColorWithRGB(239, 239, 239);
    
    __weak typeof(self) thisInstance = self;
    
    //初始化表头部
    questionTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        //刷新数据
        [thisInstance refreshDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.questionTableView.header endRefreshing];
    }];
    
    //初始化表尾部
    questionTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        //加载更多数据
        [thisInstance loadMoreDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.questionTableView.footer endRefreshing];
    }];
    
    questionTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:questionTableView];
    self.questionTableView = questionTableView;
    
    for (NSString *visualFormat in @[@"H:|[questionTableView]|",@"V:|[questionTableView]|"]) {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:@{@"questionTableView": questionTableView}];
        [self.view addConstraints:constraints];
    }
    
    ZXLLOG(@"View Frame: %@",NSStringFromCGRect(self.view.frame));
    
    [UIView transitionFromView:_indicatePage toView:_questionTableView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        ZXLLOG(@"animated View Frame: %@",NSStringFromCGRect(self.view.frame));
    }];
    
    //[_noticeTableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    BDBHotTopicsModel *typeListModerl = _QuestionTypeList[indexPath.row];
  
    

    tableViewCell.textLabel.text = typeListModerl.Title;
    return tableViewCell;
}
- (IBAction)askAQuestion:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"askQuestion" sender:self];
}



@end
