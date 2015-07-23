//
//  BDBSubjectViewController.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectViewController.h"
#import "BDBButtonForTopView.h"
#import "BDBSubjectTableViewCell.h"
#import "BDBTableViewCell_Sift.h"
#import "BDBSiftButtonInfoModel.h"
#import "BDBButtonForSift.h"
#import "BDBSujectRespondModel.h"
#import "BDBSujectModel.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBSubjectDeepexcavationContronller.h"
#import "BDBSubjectProfitCalculatorViewController.h"
#import "BDBSubjectFilterViewController.h"
#import "BDBSubjectShowWebViewController.h"
#import "BDBMyCollectViewController.h"

typedef enum{
    pullUpRefresh,dropDownRefresh} RefreshWays;


/**
 *  标的首页
 */
@interface BDBSubjectViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) UIView *topView;

@property(nonatomic,weak) UITableView *showDataTableView;

@property(nonatomic,weak) UILabel *selectedPlatformName;

@property(nonatomic,weak) UIView *showBidInfoCountView;

@property(nonatomic,weak) UILabel *bidCountLabel;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;

@property(nonatomic,strong) NSMutableDictionary *filterCondition;

@property(nonatomic,weak) NSLayoutConstraint *heigtConstraintForPlatformView;

@property(nonatomic,weak) NSLayoutConstraint *constrainHeightForTopView;

@property(nonatomic,strong) NSMutableDictionary *isCollectedDict;

@property(nonatomic,strong) NSMutableDictionary *isRefreshingDict;

@property(nonatomic,copy) NSString *pageIndex;

@property(nonatomic,copy) NSString *pageSize;

@property(nonatomic,strong) NSMutableArray *sujectModelDatas;

@property(nonatomic,strong) BDBSujectRespondModel *sujectRespondModel;

@property(nonatomic,assign) CGFloat benginScrollY;

- (void)loadTopView;

- (void)loadShowDataTableView;

- (void)loadBidsInfWithRefreshWay: (RefreshWays)refreshWay;

- (void)showBidInfoCount;

- (void)hiddenBidInfoCount;

- (void)loadBackToTopButton;

- (void)topViewButtonClicked:(BDBButtonForTopView *)button;

@end

@implementation BDBSubjectViewController

#pragma mark - Initial Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        self.title = @"标的";
        
        self.filterCondition = [NSMutableDictionary dictionary];
        
        self.isCollectedDict = [NSMutableDictionary dictionary];
        
        self.isRefreshingDict = [NSMutableDictionary dictionary];
        
        self.sujectModelDatas = [NSMutableArray array];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.pageIndex = @"1";
        
        self.pageSize = @"10";
    }
    
    return self;
}

#pragma mark - Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //添加navigationItemRight按钮
    
    UIBarButtonItem *pushCollectionViewButton = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"subject_navigationRight_icon"] highlightedImage:nil clickedHandler:^{
        
        //判断用户是否登录
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userUID = [userDefaults objectForKey:@"UID"];
        
        if(userUID == nil){
        
            //提示用户登录
            
            UIAlertView *alerLogin = [[UIAlertView alloc] initWithTitle:nil message:@"未登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alerLogin show];
        }
        else{
        
            UIStoryboard *userStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
            
            UIViewController *controller = [userStoryboard instantiateViewControllerWithIdentifier:@"userCollectionViewController"];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }];
    
    self.navigationItem.rightBarButtonItem = pushCollectionViewButton;
    
    [self loadTopView];
    [self loadShowDataTableView];
    [self loadBackToTopButton];
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    [self loadBidsInfWithRefreshWay:pullUpRefresh];

}

- (void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoadDatas  Methods

/**
 * 通过刷新的方式，刷新表格
 */
- (void)loadBidsInfWithRefreshWay: (RefreshWays)refreshWay{
    
    if(refreshWay == pullUpRefresh){
        
        self.pageIndex = @"1";
        
    }
    if(refreshWay == dropDownRefresh){
        
        NSInteger pageIndex = [_pageIndex integerValue];
        
        pageIndex ++;
        
        self.pageIndex = [NSString stringWithFormat:@"%li",(long)pageIndex];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetWorthyBids"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    
    parametersDict[@"Device"] = @"0";
    
    parametersDict[@"PageInDex"] = _pageIndex;
    
    parametersDict[@"PageSize"] = _pageSize;
    
    parametersDict[@"Count"] = @"1";
    
    
    [manager POST:requestURL parameters:parametersDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        self.sujectRespondModel = [BDBSujectRespondModel objectWithKeyValues:responseObject];
        
        if(refreshWay == pullUpRefresh){
            
            self.sujectModelDatas = _sujectRespondModel.BidList;
            
            [self.showDataTableView.header endRefreshing];
            
        }
        
        if(refreshWay == dropDownRefresh){
            
            [_sujectModelDatas addObjectsFromArray:_sujectRespondModel.BidList];
            
            [self.showDataTableView.footer endRefreshing];
        }
        
        if(self.indicatePage != nil){
            [_indicatePage hide];
        }
        [self refreshBidInfoCount];

        [self.showDataTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (_indicatePage) {
			__weak typeof(self) thisInstance = self;
			[_indicatePage showReloadButtonWithClickedHandler:^{
				[thisInstance loadBidsInfWithRefreshWay:pullUpRefresh];
			}];
		}
        
    }];
    
    
}


#pragma mark - Load SubViews Methods

/**
 *  为顶部的UIView添加SubViews
 */
- (void)loadTopView{
    
    UIView *topView = [[UIView alloc] init];
    
    topView.tag = 100;
    
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
    
    self.constrainHeightForTopView = constrainHeightForTopView;
    
    [self.view addConstraints:constrains];
    
    [topView addConstraint:constrainHeightForTopView];
    
    //TopView背景图片
    
    UIImageView *topViewBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subject_btnTopview_bg_img"]];
    
    [topView addSubview:topViewBackgroundImage];
    
    topViewBackgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstrainsTopViewBackgroundImage = [NSLayoutConstraint constraintsWithVisualFormat:@"|[topViewBackgroundImage]|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"topViewBackgroundImage":topViewBackgroundImage}];
    
    NSArray *vConstrainsTopViewBackgroundImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topViewBackgroundImage]|" options:NSLayoutFormatAlignAllTop metrics:nil views:@{@"topViewBackgroundImage":topViewBackgroundImage}];
    
    [topView addConstraints:hConstrainsTopViewBackgroundImage];
    [topView addConstraints:vConstrainsTopViewBackgroundImage];
    
    //topView按钮
    
    BDBButtonForTopView *buttonOfProfit = [BDBButtonForTopView buttonWithTitle:@"收益率" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    
    [buttonOfProfit addTarget:self action:@selector(sortSujectModelDatasWith:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonOfProfit.frame = CGRectMake(0, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfProfit];
    
    BDBButtonForTopView *buttonOfProgress = [BDBButtonForTopView buttonWithTitle:@"进度" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    [buttonOfProgress addTarget:self action:@selector(sortSujectModelDatasWith:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonOfProgress.frame = CGRectMake(SCREEN_WIDTH / 4 * 1, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfProgress];
    
    BDBButtonForTopView *buttonOfTimeLimit = [BDBButtonForTopView buttonWithTitle:@"期限" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    [buttonOfTimeLimit addTarget:self action:@selector(sortSujectModelDatasWith:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonOfTimeLimit.frame = CGRectMake(SCREEN_WIDTH / 4 * 2, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfTimeLimit];
    
    BDBButtonForTopView *buttonOfSift = [BDBButtonForTopView buttonWithTitle:@"筛选" titleColor:UIColorWithRGB(69 , 165, 225) image:[UIImage imageNamed:@"subject_btnTopview_icon_sift"]];
    
    __weak typeof (self) thisInstance = self;
    
    [buttonOfSift handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        
        BDBSubjectFilterViewController *controller = [[BDBSubjectFilterViewController alloc] init];
        [thisInstance.navigationController pushViewController:controller animated:YES];
        
    }];
    
    buttonOfSift.frame = CGRectMake(SCREEN_WIDTH / 4 * 3, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfSift];
    
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

/**
 *  加载tableView
 */
- (void)loadShowDataTableView{
    
    UITableView *showDataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    showDataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    showDataTableView.backgroundColor = UIColorWithRGB(231, 231, 231);
    
    showDataTableView.dataSource = self;
    
    showDataTableView.delegate = self;
    
    [showDataTableView registerNib:[UINib nibWithNibName:@"BDBSubjectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentify"];
    
    showDataTableView.estimatedRowHeight = 100.0f;
    
    [self.view addSubview:showDataTableView];
    
    self.showDataTableView = showDataTableView;
    
    showDataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hConstrainsVFL = @"|[showDataTableView]|";
    
    NSString *vConstrainsVFL = @"V:[topView][showDataTableView]-(50)-|";
    
    NSArray *hConstrains = [NSLayoutConstraint constraintsWithVisualFormat:hConstrainsVFL options:NSLayoutFormatAlignAllBottom metrics:nil views:@{@"showDataTableView":showDataTableView}];
    
    UIView *topView = [self.view viewWithTag:100];
    
    NSArray *vConstrains = [NSLayoutConstraint constraintsWithVisualFormat:vConstrainsVFL options:NSLayoutFormatAlignAllLeading metrics:nil views:@{@"showDataTableView":showDataTableView,@"topView":topView}];
    
    [self.view addConstraints:hConstrains];
    [self.view addConstraints:vConstrains];
    
    
    __weak typeof(self) thisInstance = self;
    showDataTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        
        [thisInstance loadBidsInfWithRefreshWay:pullUpRefresh];
        
    }];
    showDataTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        
        [thisInstance loadBidsInfWithRefreshWay:dropDownRefresh];
        
    }];
    
    [self showBidInfoCount];
}

//加载横幅

- (void)showBidInfoCount{
    
    UIView *bidInfoCountView = [[UIView alloc] init];
    
    bidInfoCountView.backgroundColor = UIColorWithRGB(230, 99, 99);
    
    [self.view addSubview:bidInfoCountView];
    
    self.showBidInfoCountView = bidInfoCountView;
    
    bidInfoCountView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *constrainsVFL = @"H:|[bidInfoCountView]|";
    
    NSArray *hConstrains = [NSLayoutConstraint constraintsWithVisualFormat:constrainsVFL options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"bidInfoCountView":bidInfoCountView}];
    
    UIView *topView = [self.view viewWithTag:100];
    
    NSLayoutConstraint *bidInfoCountViewTopConstrain = [NSLayoutConstraint constraintWithItem:bidInfoCountView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *bidInfoCountViewHeight = [NSLayoutConstraint constraintWithItem:bidInfoCountView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    [self.view addConstraint:bidInfoCountViewTopConstrain];
    [self.view addConstraints:hConstrains];
    [bidInfoCountView addConstraint:bidInfoCountViewHeight];
    
    NSArray *constrains = self.view.constraints;
    
    for (NSLayoutConstraint *constrain in constrains) {
        if(constrain.firstItem == _showDataTableView && constrain.secondAttribute == NSLayoutAttributeBottom){
            
            constrain.constant += 30.0f;
            
        }
    }
    
    
    UILabel *bidCountLabel = [[UILabel alloc] init];
    
    bidCountLabel.text = [NSString stringWithFormat:@"比贷宝为您挖掘了%@种新产品",_sujectRespondModel.BidCount];
    
    bidCountLabel.textColor = [UIColor whiteColor];
    
    bidCountLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [bidInfoCountView addSubview:bidCountLabel];
    
    self.bidCountLabel = bidCountLabel;
    
    bidCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    constrainsVFL = @"V:|[bidCountLabel]|";
    
    NSArray *vConstrains = [NSLayoutConstraint constraintsWithVisualFormat:constrainsVFL options:0 metrics:nil views:@{@"bidCountLabel":bidCountLabel}];
    
    [bidInfoCountView addConstraints:vConstrains];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:bidCountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bidInfoCountView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    
    [bidInfoCountView addConstraint:centerXConstraint];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:bidCountLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bidInfoCountView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
    [bidInfoCountView addConstraint:centerYConstraint];
    
    NSTimer *hiddenBidInfoCountTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hiddenBidInfoCount) userInfo:nil repeats:NO];
    
    
}

//刷新横幅
- (void)refreshBidInfoCount{
    
    _bidCountLabel.text = [NSString stringWithFormat:@"比贷宝为您挖掘了%@种新产品",_sujectRespondModel.BidCount];
}


//移除横幅
- (void)hiddenBidInfoCount{
    
    [_showBidInfoCountView removeFromSuperview];
    
    NSArray *constrains = self.view.constraints;
    
    for (NSLayoutConstraint *constrain in constrains) {
        if(constrain.firstItem == _showDataTableView && constrain.secondAttribute == NSLayoutAttributeBottom){
            [UIView animateWithDuration:0.2f animations:^{
                constrain.constant = 0.0f;
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }];
            
            break;
        }
    }
    
}

//显示筛选区域
- (void)showTopView{

    self.constrainHeightForTopView.constant = 44.0f;
}

//隐藏筛选区域
- (void)hiddenTopView{
    
    self.constrainHeightForTopView.constant = 0.0f;
    
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    self.benginScrollY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //到顶部时显示或者刷新横幅
    if(scrollView.contentOffset.y <= 0){
        
        if( _showBidInfoCountView == nil){
            [self showBidInfoCount];
        }
        else{
            
            [self refreshBidInfoCount];
            
        }
    }
    
    //下拉隐藏筛选区域 上拉显示
    if(scrollView.contentOffset.y - _benginScrollY > 0){
    
        [self hiddenTopView];
    }
    else{
    
       [self showTopView];
    }
}

#pragma mark - TableView Delegate And DataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _sujectModelDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BDBSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"forIndexPath:indexPath];
    
    BDBSujectModel *model = _sujectModelDatas[indexPath.row];
    
    [cell depoySubViewWithModel:model controller:self indexPath:indexPath];
    
    //保存当前收藏按钮的状态
    __weak typeof(self) thisInstance = self;
    cell.updateCollectButtonSelected = ^(BOOL selected){
        
        thisInstance.isCollectedDict[indexPath] = [NSNumber numberWithBool:selected];
        
    };
    
    //保存当前刷新按钮的状态
    cell.updateCellisRefresh = ^(BOOL isRefreshing){
        
        
        thisInstance.isRefreshingDict[indexPath] = [NSNumber numberWithBool:isRefreshing];
    };
    
    //点击刷新按钮后，更新数据
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

#pragma mark -TopView Button  Methods

/**
 *  筛选区域（顶部区域）按钮的点击事件：排序和更改状态
 */

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

/**
 *  根据收益率进行排序
 */

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

/**
 * 根据进度进行排序
 */
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

/**
 *  根据期限进行排序
 */

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

/**
 *  顶部按钮的更改颜色和被选中的状态
 */
- (void)topViewButtonClicked:(BDBButtonForTopView *)button{
    
    
    UIView *topView  = [self.view viewWithTag:100];
    
    for (id obj in topView.subviews) {
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

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIStoryboard *userStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    
    UIViewController *controller = [userStoryboard instantiateViewControllerWithIdentifier:@"userLoginViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
