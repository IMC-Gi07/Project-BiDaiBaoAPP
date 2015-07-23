//
//  BDBSubjectSievingContronller.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectDeepexcavationContronller.h"
#import "BDBSubjectProfitCalculatorViewController.h"
#import "BDBButtonForTopView.h"
#import "BDBSubjectTableViewCell.h"

#import "BDBSujectP2PListResponseModel.h"
#import "BDBSujectP2PListModel.h"
#import "BDBSujectRespondModel.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBSubjectShowWebViewController.h"

typedef enum{
    pullUpRefresh,dropDownRefresh} RefreshWays;

@interface BDBSubjectDeepexcavationContronller ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) UIView *topView;

@property(nonatomic,weak) UITableView *showDataTableView;

@property(nonatomic,strong) NSMutableArray *sujectModelDatas;

@property(nonatomic,strong) NSMutableDictionary *isCollectedDict;

@property(nonatomic,strong) NSMutableDictionary *isRefreshingDict;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;

@property(nonatomic,assign) RefreshWays refreshWay;

@property(nonatomic,copy) NSString *PageInDex;

@property(nonatomic,copy) NSString *PageSize;

@end

@implementation BDBSubjectDeepexcavationContronller

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
    
    [self loadBackToTopButton];
    
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    
    [self loadBidsInf:pullUpRefresh];

    
}

- (void)loadBidsInf: (RefreshWays)refreshWay{
    
    if(refreshWay == pullUpRefresh){
    
        self.PageInDex = @"1";
    }
    
    if(refreshWay == dropDownRefresh){
        
        NSInteger pageIndex = [_PageInDex integerValue];
        
        pageIndex ++;
        
        self.PageInDex = [NSString stringWithFormat:@"%li",(long)pageIndex];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids_Filter_Ex"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    
    parametersDict[@"Device"] = @"0";
    
    parametersDict[@"PageInDex"] = _PageInDex;
    
    parametersDict[@"PageSize"] = _PageSize;
    
    parametersDict[@"Count"] = @"1";
	
	parametersDict[@"EarningsDesc"] = @"1";
    
    if(_selectedPlatformArray.count > 0){
    
         NSString *str = [_selectedPlatformArray componentsJoinedByString:@","];
        parametersDict[@"PlatFormID"] = str;
    }
    if(_selectedProfitArray.count > 0){
        
        NSString *str = [_selectedProfitArray componentsJoinedByString:@","];
        parametersDict[@"AnnualEarnings"] = str;
    }
    if(_selectedTermArray.count > 0){
        
        NSString *str = [_selectedTermArray componentsJoinedByString:@","];
        parametersDict[@"Term"] = str;
    }
    if(_selectedProgressArray.count > 0){
        
        NSString *str = [_selectedProgressArray componentsJoinedByString:@","];
        parametersDict[@"ProgressPercent"] = str;
    }
    
    [manager POST:requestURL parameters:parametersDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBSujectRespondModel *responseModel = [BDBSujectRespondModel objectWithKeyValues:responseObject];
        
        if(refreshWay == pullUpRefresh){
            self.sujectModelDatas = responseModel.BidList;
            [self.showDataTableView.header endRefreshing];
        }
        
        if(refreshWay == dropDownRefresh){
            
            [_sujectModelDatas addObjectsFromArray:responseModel.BidList];
            [self.showDataTableView.footer endRefreshing];
        }
        
        if(_indicatePage != nil){
        
            [_indicatePage hide];
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
    
    [showDataTableView registerNib:[UINib nibWithNibName:@"BDBSubjectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentify"];
    
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
        
        
    }];
    showDataTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        
        [thisInstance loadBidsInf:dropDownRefresh];
        
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

//回到顶部按钮
- (void)loadBackToTopButton{
    
    
    UIButton *backToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backToTopButton.tag = 200;
    
    UIImage *image = [UIImage imageNamed:@"subject_backtop"];
    
    [backToTopButton setImage:image forState:UIControlStateNormal];
    
    __weak typeof(self) thisInstance = self;
    [backToTopButton handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        [thisInstance.showDataTableView setContentOffset:CGPointZero animated:YES];
    }];
    [self.view addSubview:backToTopButton];
    backToTopButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[backToTopButton]-10-|" options:0 metrics:nil views:@{@"backToTopButton":backToTopButton}];
    
    [self.view addConstraints:hConstraint];
    
    NSLayoutConstraint *vConstraint = [NSLayoutConstraint constraintWithItem:backToTopButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0f constant:-10.0f];
    
    [self.view addConstraint:vConstraint];
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
    
    
    
    BDBSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"forIndexPath:indexPath];
    
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
