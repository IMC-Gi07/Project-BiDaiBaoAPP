//
//  BDBSubjectSievingContronller.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectFilterContronller.h"
#import "BDBSujectProfitCalculatorViewController.h"
#import "BDBButtonForTopView.h"
#import "BDBTableViewCell.h"

#import "BDBSujectP2PListResponseModel.h"
#import "BDBSujectP2PListModel.h"
#import "BDBSujectRespondModel.h"

typedef enum{
    pullUpRefresh,dropDownRefresh} RefreshWays;

@interface BDBSubjectFilterContronller ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) UIView *topView;

@property(nonatomic,weak) UITableView *showDataTableView;

@property(nonatomic,strong) NSMutableArray *sujectModelDatas;

@property(nonatomic,strong) NSMutableDictionary *isCollectedDict;

@property(nonatomic,strong) NSMutableDictionary *isRefreshingDict;

@property(nonatomic,assign) RefreshWays refreshWay;

@property(nonatomic,copy) NSString *PageInDex;

@property(nonatomic,copy) NSString *PageSize;

@property(nonatomic,copy) NSString *Count;

@property(nonatomic,copy) NSString *AnnualEarnings_Min;

@property(nonatomic,copy) NSString *AnnualEarnings_Max;

@property(nonatomic,copy) NSString *Term_Min;

@property(nonatomic,copy) NSString *Term_Max;

@property(nonatomic,copy) NSString *ProgressPercent_Min;

@property(nonatomic,copy) NSString *ProgressPercent_Max;

@property(nonatomic,copy) NSString *PlatFormID;

@end

@implementation BDBSubjectFilterContronller

- (instancetype)init{
    
    if(self = [super init]){
        
        self.title = @"深度挖掘";
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.filterCondition = [NSMutableDictionary dictionary];
        
        self.isCollectedDict = [NSMutableDictionary dictionary];
        
        self.isRefreshingDict = [NSMutableDictionary dictionary];
        
        self.sujectModelDatas = [NSMutableArray array];
        
        self.refreshWay = pullUpRefresh;
        
        self.PageInDex = @"1";
        
        self.PageSize = @"10";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTopView];
    [self loadShowDataTableView];
    [self loadAllPlatformID];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAllPlatformID{

    AFHTTPRequestOperationManager *manamger = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetP2PList"];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    parametersDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parametersDict[@"Device"] = @"0";
    parametersDict[@"Type"] = @"0";
    
    [manamger POST:requestURL parameters:parametersDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBSujectP2PListResponseModel *p2pListResponseModel = [BDBSujectP2PListResponseModel objectWithKeyValues:responseObject];
        
        NSArray *modelArray = p2pListResponseModel.P2PList;
        
        for (BDBSujectP2PListModel *model in modelArray) {
            
            NSString *platName = _filterCondition[@"平台"];
            if([model.PlatformName isEqualToString: platName]){
                
                _filterCondition[@"平台"] = model.PlatFormID;
                break;
            }
        }
        [self loadBidsInf:pullUpRefresh];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"%@",error);
    }];
    
}

- (void)loadBidsInf: (RefreshWays)refreshWay{
    
    if(refreshWay == pullUpRefresh){
    
        self.PageInDex = @"1";
        
        [_sujectModelDatas removeAllObjects];
    }
    
    if(refreshWay == dropDownRefresh){
        
        NSInteger pageIndex = [_PageInDex integerValue];
        
        pageIndex ++;
        
        self.PageInDex = [NSString stringWithFormat:@"%li",(long)pageIndex];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    
    parametersDict[@"Device"] = @"0";
    
    parametersDict[@"PageInDex"] = _PageInDex;
    
    parametersDict[@"PageSize"] = _PageSize;
    
    parametersDict[@"Count"] = @"1";
    
    if(![_filterCondition[@"平台"] isEqualToString:@""]){
    
        parametersDict[@"PlatFormID"] = _filterCondition[@"平台"];
    }
    if(![_filterCondition[@"收益率"] isEqualToString:@""]){
        
        if([_filterCondition[@"收益率"] isEqualToString:@"<12%"]){
        
            parametersDict[@"AnnualEarnings_Max"] = @"0.12";
        }
        if([_filterCondition[@"收益率"] isEqualToString:@"12%-15%"]){
            
            parametersDict[@"AnnualEarnings_Min"] = @"0.12";
            
            parametersDict[@"AnnualEarnings_Max"] = @"0.15";
        }
        if([_filterCondition[@"收益率"] isEqualToString:@">15%"]){
            
            parametersDict[@"AnnualEarnings_Min"] = @"0.15";
            
        }
    }
    
    if(![_filterCondition[@"进度"] isEqualToString:@""]){
        
        if([_filterCondition[@"进度"] isEqualToString:@"50%以内"]){
            
            parametersDict[@"ProgressPercent_Max"] = @"0.5";
        }
        if([_filterCondition[@"进度"] isEqualToString:@"50%-80%"]){
            
            parametersDict[@"ProgressPercent_Min"] = @"0.5";
            
            parametersDict[@"ProgressPercent_Max"] = @"0.8";
        }
        if([_filterCondition[@"进度"] isEqualToString:@"80%以上"]){
            
            parametersDict[@"ProgressPercent_Min"] = @"0.8";
            
        }
    }
    
    if(![_filterCondition[@"期限"] isEqualToString:@""]){
        
        if([_filterCondition[@"期限"] isEqualToString:@"30天内"]){
            
            parametersDict[@"Term_Max"] = @"30";
        }
        if([_filterCondition[@"期限"] isEqualToString:@"1-3个月"]){
            
            parametersDict[@"Term_Min"] = @"30";
            
            parametersDict[@"Term_Max"] = @"90";
        }
        if([_filterCondition[@"期限"] isEqualToString:@"3-6个月"]){
            
            parametersDict[@"Term_Min"] = @"90";
            
            parametersDict[@"Term_Max"] = @"180";
            
        }
        if([_filterCondition[@"期限"] isEqualToString:@"6-12个月"]){
            
            parametersDict[@"Term_Min"] = @"180";
            
            parametersDict[@"Term_Max"] = @"360";
            
        }
        if([_filterCondition[@"期限"] isEqualToString:@"1-2年"]){
            
            parametersDict[@"Term_Min"] = @"360";
            
            parametersDict[@"Term_Max"] = @"720";
            
        }
        if([_filterCondition[@"期限"] isEqualToString:@"2年以上"]){
            
            parametersDict[@"Term_Min"] = @"720";
        }
    }
    
    [manager POST:requestURL parameters:parametersDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBSujectRespondModel *responseModel = [BDBSujectRespondModel objectWithKeyValues:responseObject];
        
        if(refreshWay == pullUpRefresh){
            self.sujectModelDatas = responseModel.BidList;
            
        }
        
        if(refreshWay == dropDownRefresh){
            
            [_sujectModelDatas addObjectsFromArray:responseModel.BidList];
            
        }
        
        [self.showDataTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ZXLLOG(@"%@",error);
    }];
}


- (void)loadShowDataTableView{
    
    UITableView *showDataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    showDataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    showDataTableView.backgroundColor = UIColorWithRGB(231, 231, 231);
    
    showDataTableView.dataSource = self;
    
    showDataTableView.delegate = self;
    
    showDataTableView.estimatedRowHeight = 100.0f;
    
    [showDataTableView registerNib:[UINib nibWithNibName:@"BDBTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentify"];
    
    [self.view addSubview:showDataTableView];
    
    self.showDataTableView = showDataTableView;
    
    showDataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hConstrainsVFL = @"|[showDataTableView]|";
    
    NSString *vConstrainsVFL = @"V:[topView][showDataTableView]|";
    
    NSArray *hConstrains = [NSLayoutConstraint constraintsWithVisualFormat:hConstrainsVFL options:NSLayoutFormatAlignAllBottom metrics:nil views:@{@"showDataTableView":showDataTableView}];
    
    NSArray *vConstrains = [NSLayoutConstraint constraintsWithVisualFormat:vConstrainsVFL options:NSLayoutFormatAlignAllLeading metrics:nil views:@{@"showDataTableView":showDataTableView,@"topView":_topView}];
    
    [self.view addConstraints:hConstrains];
    [self.view addConstraints:vConstrains];
    
    
    __weak typeof(self) thisInstance = self;
    showDataTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        
        [thisInstance loadBidsInf:pullUpRefresh];
        
        [thisInstance.showDataTableView.header endRefreshing];
        
    }];
    showDataTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        
        [thisInstance loadBidsInf:dropDownRefresh];
        [thisInstance.showDataTableView.footer endRefreshing];
        
    }];
    
    
}

/**
 *  为顶部的UIView添加SubViews
 */
- (void)loadTopView{
    
    UIView *topView = [[UIView alloc] init];
    
    [self.view addSubview:topView];
    
    self.topView = topView;
    
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *constrains = [NSMutableArray arrayWithCapacity:4];
    
    NSLayoutConstraint *constrainLeadingForTopView = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    [constrains addObject:constrainLeadingForTopView];
    
    NSLayoutConstraint *constrainTrailingForTopView = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    [constrains addObject:constrainTrailingForTopView];
    
    NSLayoutConstraint *constrainTopForTopView = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [constrains addObject:constrainTopForTopView];
    
    NSLayoutConstraint *constrainHeightForTopView = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:44.0f];
    
    [self.view addConstraints:constrains];
    
    [topView addConstraint:constrainHeightForTopView];
    
    //TopView背景图片
    
    UIImageView *topViewBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subject_deepExcavate_topView_bg_img"]];
    
    [topView addSubview:topViewBackgroundImage];
    
    topViewBackgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstrainsTopViewBackgroundImage = [NSLayoutConstraint constraintsWithVisualFormat:@"|[topViewBackgroundImage]|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"topViewBackgroundImage":topViewBackgroundImage}];
    
    NSArray *vConstrainsTopViewBackgroundImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topViewBackgroundImage]|" options:NSLayoutFormatAlignAllTop metrics:nil views:@{@"topViewBackgroundImage":topViewBackgroundImage}];
    
    [topView addConstraints:hConstrainsTopViewBackgroundImage];
    [topView addConstraints:vConstrainsTopViewBackgroundImage];
    
    //topView按钮
    
    BDBButtonForTopView *buttonOfProfit = [BDBButtonForTopView buttonWithTitle:@"收益率" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    [buttonOfProfit addTarget:self action:@selector(sortSujectModelDatasWith:) forControlEvents:UIControlEventTouchUpInside];
    
    
    buttonOfProfit.frame = CGRectMake(0, 0, SCREEN_WIDTH / 3, 44);
    
    [topView addSubview:buttonOfProfit];
    
    BDBButtonForTopView *buttonOfProgress = [BDBButtonForTopView buttonWithTitle:@"进度" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    [buttonOfProgress addTarget:self action:@selector(sortSujectModelDatasWith:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonOfProgress.frame = CGRectMake(SCREEN_WIDTH / 3 * 1, 0, SCREEN_WIDTH / 3, 44);
    
    [topView addSubview:buttonOfProgress];
    
    BDBButtonForTopView *buttonOfTimeLimit = [BDBButtonForTopView buttonWithTitle:@"期限" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    [buttonOfTimeLimit addTarget:self action:@selector(sortSujectModelDatasWith:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonOfTimeLimit.frame = CGRectMake(SCREEN_WIDTH / 3 * 2, 0, SCREEN_WIDTH / 3, 44);
    
    [topView addSubview:buttonOfTimeLimit];
    
}

#pragma  mark -TopView Button  Methods

- (void)sortSujectModelDatasWith:(BDBButtonForTopView *)button{
    
    NSString *sortType = [button titleForState:UIControlStateNormal];
    
    [self topViewButtonClicked:button];
    
    NSComparisonResult comparisonResult;
    
    if (button.isClicked) {
        comparisonResult = NSOrderedDescending;
    }
    else{
        
        comparisonResult = NSOrderedAscending;
        
    }
    
    if([sortType isEqualToString:@"收益率"]){
        
        [self sortSujectModelDatasWithProfit:comparisonResult];
        
    }
    if([sortType  isEqualToString:@"进度"]){
        
        [self sortSujectModelDatasWithProgress:comparisonResult];
    }
    if([sortType isEqualToString:@"期限"]){
        
        [self sortSujectModelDatasWithTerm:comparisonResult];
    }
}

- (void)sortSujectModelDatasWithProfit:(NSComparisonResult)comparisonResult{
    __weak typeof(self) thisInstance = self;
    if(comparisonResult == NSOrderedAscending){
        NSArray *tmpArray = [thisInstance.sujectModelDatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BDBSujectModel *model1 = obj1;
            BDBSujectModel *model2 = obj2;
            
            CGFloat profit1 = [model1.AnnualEarnings floatValue];
            
            CGFloat profit2 = [model2.AnnualEarnings floatValue];
            if(profit1 > profit2){
                
                return NSOrderedDescending;
            }
            else{
                
                return NSOrderedAscending;
            }
        }];
        
        
        self.sujectModelDatas = [tmpArray mutableCopy];
        [_showDataTableView reloadData];
    }
    
    if(comparisonResult == NSOrderedDescending){
        
        NSArray *tmpArray = [thisInstance.sujectModelDatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BDBSujectModel *model1 = obj1;
            BDBSujectModel *model2 = obj2;
            
            CGFloat profit1 = [model1.AnnualEarnings floatValue];
            
            CGFloat profit2 = [model2.AnnualEarnings floatValue];
            if(profit1 > profit2){
                
                return NSOrderedAscending;
            }
            else{
                
                return NSOrderedDescending;
            }
        }];
        self.sujectModelDatas = [tmpArray mutableCopy];
        [_showDataTableView reloadData];
        
    }
}

- (void)sortSujectModelDatasWithProgress:(NSComparisonResult)comparisonResult{
    __weak typeof(self) thisInstance = self;
    if(comparisonResult == NSOrderedAscending){
        NSArray *tmpArray = [thisInstance.sujectModelDatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BDBSujectModel *model1 = obj1;
            BDBSujectModel *model2 = obj2;
            
            CGFloat profit1 = [model1.ProgressPercent floatValue];
            
            CGFloat profit2 = [model2.ProgressPercent floatValue];
            if(profit1 > profit2){
                
                return NSOrderedDescending;
            }
            else{
                
                return NSOrderedAscending;
            }
        }];
        
        
        self.sujectModelDatas = [tmpArray mutableCopy];
        [_showDataTableView reloadData];
    }
    
    if(comparisonResult == NSOrderedDescending){
        
        NSArray *tmpArray = [thisInstance.sujectModelDatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BDBSujectModel *model1 = obj1;
            BDBSujectModel *model2 = obj2;
            
            CGFloat profit1 = [model1.ProgressPercent floatValue];
            
            CGFloat profit2 = [model2.ProgressPercent floatValue];
            if(profit1 > profit2){
                
                return NSOrderedAscending;
            }
            else{
                
                return NSOrderedDescending;
            }
        }];
        self.sujectModelDatas = [tmpArray mutableCopy];
        [_showDataTableView reloadData];
        
    }
}

- (void)sortSujectModelDatasWithTerm:(NSComparisonResult)comparisonResult{
    __weak typeof(self) thisInstance = self;
    if(comparisonResult == NSOrderedAscending){
        NSArray *tmpArray = [thisInstance.sujectModelDatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BDBSujectModel *model1 = obj1;
            BDBSujectModel *model2 = obj2;
            
            CGFloat profit1 = [model1.Term floatValue];
            
            CGFloat profit2 = [model2.Term floatValue];
            if(profit1 > profit2){
                
                return NSOrderedDescending;
            }
            else{
                
                return NSOrderedAscending;
            }
        }];
        
        
        self.sujectModelDatas = [tmpArray mutableCopy];
        [_showDataTableView reloadData];
    }
    
    if(comparisonResult == NSOrderedDescending){
        
        NSArray *tmpArray = [thisInstance.sujectModelDatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BDBSujectModel *model1 = obj1;
            BDBSujectModel *model2 = obj2;
            
            CGFloat profit1 = [model1.Term floatValue];
            
            CGFloat profit2 = [model2.Term floatValue];
            if(profit1 > profit2){
                
                return NSOrderedAscending;
            }
            else{
                
                return NSOrderedDescending;
            }
        }];
        self.sujectModelDatas = [tmpArray mutableCopy];
        [_showDataTableView reloadData];
        
    }
}

- (void)topViewButtonClicked:(BDBButtonForTopView *)button{
    
    for (id obj in _topView.subviews) {
        if([obj isKindOfClass:[BDBButtonForTopView class]]){
            
            BDBButtonForTopView *btn = obj;
            
            if(![[btn titleForState:UIControlStateNormal] isEqualToString:@"筛选"]){
                [btn setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
                
            }
        }
    }
    
    [button setTitleColor:UIColorWithRGB(74, 168, 232) forState:UIControlStateNormal];
    
    if(button.isClicked){
        
        button.isClicked = NO;
    }
    else{
        
        button.isClicked = YES;
        
    }
    
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _sujectModelDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    BDBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"forIndexPath:indexPath];
    
    BDBSujectModel *model = _sujectModelDatas[indexPath.row];
    
    [cell depoySubViewWithModel:model controller:self indexPath:indexPath];
    
    __weak typeof(self) thisInstance = self;
    cell.updateCollectButtonSelected = ^(BOOL selected){
        
        thisInstance.isCollectedDict[indexPath] = [NSNumber numberWithBool:selected];
        
    };
    
    cell.updateCellisRefresh = ^(BOOL isRefreshing){
        
        
        thisInstance.isRefreshingDict[indexPath] = [NSNumber numberWithBool:isRefreshing];
    };
    
    cell.updateCellModel = ^(BDBSujectModel *model){
        
        [thisInstance.sujectModelDatas replaceObjectAtIndex:indexPath.row withObject:model];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    };
    
    cell.collectButton.selected = [self.isCollectedDict[indexPath] boolValue];
    cell.isRrefreshing = [self.isRefreshingDict[indexPath] boolValue];
    
    return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 150;
}



@end
