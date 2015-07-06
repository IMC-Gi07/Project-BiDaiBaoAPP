//
//  BDBSubjectViewController.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectViewController.h"
#import "BDBButtonForTopView.h"
#import "BDBTableViewCell.h"
#import "BDBTableViewCell_Sift.h"
#import "BDBSiftButtonInfoModel.h"
#import "BDBButtonForSift.h"
#import "BDBSujectRespondModel.h"
#import "BDBSujectModel.h"
#import "ZXLLoadDataIndicatePage.h"
#import "BDBSubjectFilterContronller.h"
#import "BDBSujectProfitCalculatorViewController.h"

typedef enum{
    pullUpRefresh,dropDownRefresh} RefreshWays;

@interface BDBSubjectViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) UITableView *showDataTableView;

@property(nonatomic,weak) UIScrollView *filterScrollView;

@property(nonatomic,copy) NSArray *filterButtonArray;

@property(nonatomic,weak) UIButton *sureButtonOfBottom;

@property(nonatomic,weak) UIButton *resetButtonOfBottom;

@property(nonatomic,weak) UILabel *selectedPlatformName;

@property(nonatomic,weak) UIView *showBidInfoCountView;

@property(nonatomic,weak) UILabel *bidCountLabel;

@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;

@property(nonatomic,strong) NSMutableDictionary *filterCondition;

@property(nonatomic,weak) NSLayoutConstraint *heigtConstraintForPlatformView;

@property(nonatomic,strong) NSMutableDictionary *isCollectedDict;

@property(nonatomic,strong) NSMutableDictionary *isRefreshingDict;

@property(nonatomic,copy) NSString *pageIndex;

@property(nonatomic,copy) NSString *pageSize;

@property(nonatomic,strong) NSMutableArray *sujectModelDatas;

@property(nonatomic,strong) BDBSujectRespondModel *sujectRespondModel;


- (void)loadTopView;

- (void)loadShowDataTableView;

- (void)loadFilterScrollView;

- (void)loadFilterButtonInfos;

- (void)loadBidsInfWithRefreshWay: (RefreshWays)refreshWay;

- (void)loadButtonOfBottom;

- (void)layoutFilterViewButtons:(NSInteger)number view:(UIView *)aView;

- (void)showBidInfoCount;

- (void)hiddenBidInfoCount;

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
        
        _filterCondition[@"平台"] = @"";
        
        _filterCondition[@"收益率"] = @"";
        
        _filterCondition[@"期限"] = @"";
        
        _filterCondition[@"进度"] = @"";
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.pageIndex = @"1";
        
        self.pageSize = @"10";
        
        [self loadFilterButtonInfos];
        
        
    }
    
    return self;
}

#pragma mark - Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadTopView];
    [self loadShowDataTableView];
    
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    
    [self loadBidsInfWithRefreshWay:pullUpRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if(_filterScrollView == nil){
        
        self.tabBarController.tabBar.hidden = NO;
    }
    else{
    
        self.tabBarController.tabBar.hidden = YES;
    }
    
    
}

#pragma mark - LoadDatas  Methods

/**
 *  加载筛选界面按钮数据
 */

- (void)loadFilterButtonInfos{
    
    self.filterButtonArray = [NSArray arrayWithContentsOfFile:FilePathInBundleWithNameAndType(@"filterButtons",@"plist")];
    
}


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
            
            [self refreshBidInfoCount];
        }
        
        if(refreshWay == dropDownRefresh){
            
            [_sujectModelDatas addObjectsFromArray:_sujectRespondModel.BidList];
            
            [self hiddenBidInfoCount];
            
        }
        
        if(self.indicatePage != nil){
            
            [UIView transitionFromView:_indicatePage toView:_showDataTableView duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
        }
        
        [self.showDataTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ZXLLOG(@"%@",error);
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
        
        if(thisInstance.filterScrollView == nil){
            
            thisInstance.tabBarController.tabBar.hidden = YES;
            for (id obj in topView.subviews) {
                if([obj isKindOfClass:[BDBButtonForTopView class]]){
                    
                    BDBButtonForTopView *btn = obj;
                    
                    btn.isClicked = NO;
                    if(![[btn titleForState:UIControlStateNormal] isEqualToString:@"筛选"]){
                        
                        [btn setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
                    }
                    
                    
                }
            }
            [thisInstance loadFilterScrollView];
        }
        else{
            
            thisInstance.tabBarController.tabBar.hidden = NO;
            [UIView transitionFromView:thisInstance.filterScrollView toView:thisInstance.showDataTableView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
            
            [thisInstance.sureButtonOfBottom removeFromSuperview];
            [thisInstance.resetButtonOfBottom removeFromSuperview];
            
        }
    }];
    
    buttonOfSift.frame = CGRectMake(SCREEN_WIDTH / 4 * 3, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfSift];
    
}

- (void)loadFilterScrollView{
    
    
    //筛选页面
    UIScrollView *filterScrollView = [[UIScrollView alloc] init];
    
    filterScrollView.backgroundColor = [UIColor whiteColor];
    
    CATransition *transition_in = [[CATransition alloc] init];
    
    transition_in.type = kCATransitionMoveIn;
    
    transition_in.subtype = kCATransitionFromBottom;
    
    [filterScrollView.layer addAnimation:transition_in forKey:nil];
    
    [self.view addSubview:filterScrollView];
    
    self.filterScrollView = filterScrollView;
    
    filterScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *constraintsVFL = @"H:|[filterScrollView]|";
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"filterScrollView":filterScrollView}];
    
    [self.view addConstraints:hConstraints];
    
    constraintsVFL = @"V:[topView][filterScrollView]-50-|";
    
    UIView *topView = [self.view viewWithTag:100];
    
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"topView":topView,@"filterScrollView":filterScrollView}];
    
    [self.view addConstraints:vConstraints];
    
    
    //筛选页面－》选择平台
    UIScrollView *platformView = [[UIScrollView alloc] init];
    
    platformView.tag = 200;
    
    [filterScrollView addSubview:platformView];
    
    platformView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[platformView(screenWidth)]";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"platformView":platformView}];
    
    [filterScrollView addConstraints:hConstraints];
    
    //筛选页面－》选择平台(分割线)
    
    UIView *separator_0 = [[UIView alloc] init];
    
    separator_0.backgroundColor = UIColorWithRGB(204, 204, 204);
    
    [filterScrollView addSubview:separator_0];
    
    separator_0.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|-[separator_0]-|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_0":separator_0}];
    
    [filterScrollView addConstraints:hConstraints];
    
    //筛选页面－》年化收益率
    UIScrollView *profitView = [[UIScrollView alloc] init];
    
    [filterScrollView addSubview:profitView];
    
    profitView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[profitView(screenWidth)]|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"profitView":profitView}];
    
    [filterScrollView addConstraints:hConstraints];
    
    //筛选页面－》年化收益率(分割线)
    
    UIView *separator_1 = [[UIView alloc] init];
    
    separator_1.backgroundColor = UIColorWithRGB(204, 204, 204);
    
    [filterScrollView addSubview:separator_1];
    
    separator_1.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|-[separator_1]-|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_1":separator_1}];
    
    [filterScrollView addConstraints:hConstraints];
    
    //筛选页面－》投资期限
    
    UIScrollView *termView = [[UIScrollView alloc] init];
    
    [filterScrollView addSubview:termView];
    
    termView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[termView(screenWidth)]|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"termView":termView}];
    
    [filterScrollView addConstraints:hConstraints];
    
    //筛选页面－》年化收益率(分割线)
    
    UIView *separator_2 = [[UIView alloc] init];
    
    separator_2.backgroundColor = UIColorWithRGB(204, 204, 204);
    
    [filterScrollView addSubview:separator_2];
    
    separator_2.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|-[separator_2]-|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_2":separator_2}];
    
    [filterScrollView addConstraints:hConstraints];
    
    // 筛选页面－》投资进度
    UIScrollView *progressView = [[UIScrollView alloc] init];
    
    [filterScrollView addSubview:progressView];
    
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[progressView(screenWidth)]|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"progressView":progressView}];
    
    [filterScrollView addConstraints:hConstraints];
    
    
    constraintsVFL = @"V:|[platformView][separator_0(1)][profitView(65)][separator_1(1)][termView(105)][separator_2(1)][progressView(65)]|";
    
    vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"platformView":platformView,@"separator_0":separator_0,@"profitView":profitView,@"separator_1":separator_1,@"termView":termView,@"separator_2":separator_2,@"progressView":progressView}];
    
    NSLayoutConstraint *heigtConstraintForPlatformView = [NSLayoutConstraint constraintWithItem:platformView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:65.0f];
    
    self.heigtConstraintForPlatformView = heigtConstraintForPlatformView;
    
    [platformView addConstraint:heigtConstraintForPlatformView];
    
    [filterScrollView addConstraints:vConstraints];
    
    filterScrollView.hidden = NO;
    
    //筛选页面－》选择平台(选择平台)
    
    UILabel *platformLabel = [[UILabel alloc] init];
    
    platformLabel.text = @"选择平台:";
    
    
    [platformView addSubview:platformLabel];
    
    platformLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    platformLabel.frame = CGRectMake(10, 10, 70, 15);
    
    //筛选页面－》选择平台(显示更多平台按钮)
    
    BDBButtonForSift *showMoreButton = [BDBButtonForSift showMoreButton];
    
    [showMoreButton addTarget:self action:@selector(showMoreButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [platformView addSubview:showMoreButton];
    
    //筛选页面－》选择平台(显示被选择平台的名称)
    
    UILabel *selectedPlatformName = [[UILabel alloc] init];
    
    selectedPlatformName.textColor = UIColorWithRGB(12, 79, 125);
    
    [platformView addSubview:selectedPlatformName];
    
    self.selectedPlatformName = selectedPlatformName;
    
    selectedPlatformName.font  = [UIFont systemFontOfSize:12.0f];
    
    selectedPlatformName.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 60, 15);
    
    //筛选页面－》年化收益率(年化收益率)
    
    UILabel *profitLabel = [[UILabel alloc] init];
    
    profitLabel.text = @"年化收益率:";
    
    [profitView addSubview:profitLabel];
    
    profitLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    profitLabel.frame = CGRectMake(10, 10, 80, 15);
    
    //筛选页面－》投资期限(投资期限)
    
    UILabel *termLabel = [[UILabel alloc] init];
    
    termLabel.text = @"投资期限:";
    
    [termView addSubview:termLabel];
    
    termLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    termLabel.frame = CGRectMake(10, 10, 80, 15);
    
    //筛选页面－》投资期限(投资期限)
    
    UILabel *progressLabel = [[UILabel alloc] init];
    
    progressLabel.text = @"投标进度:";
    
    [progressView addSubview:progressLabel];
    
    progressLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    progressLabel.frame = CGRectMake(10, 10, 80, 15);
    
    [self layoutFilterViewButtons:0 view:platformView];
    [self layoutFilterViewButtons:1 view:profitView];
    [self layoutFilterViewButtons:2 view:termView];
    [self layoutFilterViewButtons:3 view:progressView];
    
    [self loadButtonOfBottom];
    
    
}

- (void)layoutFilterViewButtons:(NSInteger)number view:(UIView *) aView{
    
    
    NSArray *buttonsArray = _filterButtonArray[number];
    
    
    BDBSiftButtonInfoModel *sievingButtonInfos = [[BDBSiftButtonInfoModel alloc] init];
    
    for (NSDictionary *buttonDict in buttonsArray) {
        
        [buttonDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            [sievingButtonInfos setValue:obj forKey:key];
        }];
        CGFloat platformButtonHorizontalMargin;
        CGRect frame;
        
        if(number == 0){
            platformButtonHorizontalMargin = (SCREEN_WIDTH - 30 -4 * 65) / 3.0f;
            
            frame = CGRectMake(15 + 65 * sievingButtonInfos.xPoint + platformButtonHorizontalMargin * sievingButtonInfos.xPoint, 30 + 30 * sievingButtonInfos.yPoint + 10 * sievingButtonInfos.yPoint, 65, 30);
        }
        else{
            platformButtonHorizontalMargin = (SCREEN_WIDTH - 30 -3 * 90) / 2.0f;
            
            frame = CGRectMake(15 + 90 * sievingButtonInfos.xPoint + platformButtonHorizontalMargin * sievingButtonInfos.xPoint, 30 + 30 * sievingButtonInfos.yPoint + 10 * sievingButtonInfos.yPoint, 90, 30);
            
        }
        
        BDBButtonForSift *button = [BDBButtonForSift buttonWithTitle:sievingButtonInfos.title  isSelected:sievingButtonInfos.isSelected frame:frame];
        
        __weak typeof(self) thisInstance = self;
        [button handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
            
            if(!button.isSelected){
                
                for (id obj in aView.subviews) {
                    if([obj isKindOfClass:[BDBButtonForSift class]]){
                        
                        BDBButtonForSift *btn = obj;
                        
                        if(btn.isSelected == YES){
                            
                            btn.isSelected = NO;
                            break;
                        }
                    }
                }
                
                button.isSelected = YES;
            }
            
            if(number == 0){
                
                thisInstance.selectedPlatformName.text = [button titleForState:UIControlStateNormal];
            }
            
            switch (number) {
                case 0:
                    thisInstance.filterCondition[@"平台"] = [button titleForState:UIControlStateNormal];
                    
                    break;
                case 1:
                    thisInstance.filterCondition[@"收益率"] = [button titleForState:UIControlStateNormal];
                    break;
                case 2:
                    thisInstance.filterCondition[@"期限"] = [button titleForState:UIControlStateNormal];
                    break;
                case 3:
                    thisInstance.filterCondition[@"进度"] = [button titleForState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }];
        [aView addSubview:button];
        
    }
}

- (void)loadShowDataTableView{
    
    UITableView *showDataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    showDataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    showDataTableView.backgroundColor = UIColorWithRGB(231, 231, 231);
    
    showDataTableView.dataSource = self;
    
    showDataTableView.delegate = self;
    
    [showDataTableView registerNib:[UINib nibWithNibName:@"BDBTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellIdentify"];
    
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
        
        [thisInstance.showDataTableView.header endRefreshing];
        
    }];
    showDataTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        
        [thisInstance loadBidsInfWithRefreshWay:dropDownRefresh];
        
        [showDataTableView.footer endRefreshing];
        
    }];
    
    [self showBidInfoCount];
}

- (void)loadButtonOfBottom{
    
    UIButton *sureButtonOfBottom = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [sureButtonOfBottom setTitle:@"确认" forState:UIControlStateNormal];
    
    [sureButtonOfBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    sureButtonOfBottom.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    [sureButtonOfBottom addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButtonOfBottom];
    
    self.sureButtonOfBottom = sureButtonOfBottom;
    
    
    UIButton *resetButtonOfBottom = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [resetButtonOfBottom setTitle:@"重置" forState:UIControlStateNormal];
    
    [resetButtonOfBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    resetButtonOfBottom.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    [resetButtonOfBottom  addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:resetButtonOfBottom];
    
    self.resetButtonOfBottom = resetButtonOfBottom;
    
    resetButtonOfBottom.translatesAutoresizingMaskIntoConstraints = NO;
    
    sureButtonOfBottom.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hConstrainsOfButtonOfBottomVFL = @"|[resetButtonOfBottom]-2-[sureButtonOfBottom(resetButtonOfBottom)]|";
    
    
    NSArray *hConstrains = [NSLayoutConstraint constraintsWithVisualFormat:hConstrainsOfButtonOfBottomVFL options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"sureButtonOfBottom":sureButtonOfBottom,@"resetButtonOfBottom":resetButtonOfBottom}];
    
    NSLayoutConstraint *heightConstraintOfSureButtonOfBottom = [NSLayoutConstraint constraintWithItem:sureButtonOfBottom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:44.0f];
    
    NSLayoutConstraint *bottomConstraintOfSureButtonOfBottom = [NSLayoutConstraint constraintWithItem:sureButtonOfBottom attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *heightConstrainsOfResetButtonOfBottom = [NSLayoutConstraint constraintWithItem:resetButtonOfBottom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:sureButtonOfBottom attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    
    [self.view addConstraint:bottomConstraintOfSureButtonOfBottom];
    
    [self.view addConstraint:heightConstrainsOfResetButtonOfBottom];
    
    [self.view addConstraints:hConstrains];
    
    [sureButtonOfBottom addConstraint:heightConstraintOfSureButtonOfBottom];
    
}


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
    
    
}

- (void)refreshBidInfoCount{
    _bidCountLabel.text = [NSString stringWithFormat:@"比贷宝为您挖掘了%@种新产品",_sujectRespondModel.BidCount];
}

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

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y <= 0){
        if( _showBidInfoCountView == nil){
            [self showBidInfoCount];
        }
        else{
            
            [self refreshBidInfoCount];
        }
        
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(scrollView.contentOffset.y > 0){
        
        [self hiddenBidInfoCount];
    }
    
}

#pragma mark - TableView Delegate And DataSource Methods

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

#pragma mark -Upadate SetBidsStore


- (void)upDateBidStore: (NSString *)action platformID: (NSString *)aPlatforID{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetBidsStore"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";
    parameterDict[@"UID"] = @"55555555555";
    parameterDict[@"PSW"] = @"5B1B68A9ABF4D2CD155C81A9225FD158";
    parameterDict[@"Action"] = action;
    parameterDict[@"ID"] = aPlatforID;
    parameterDict[@"UserType"] = @"0";
    
    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        ZXLLOG(@"%@",responseObject[@"Result"]);
        
    } failure:nil];
}


#pragma mark -TopView Button  Methods

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
 *  显示更多平台
 */
- (void)showMoreButtonClickedAction: (BDBButtonForSift *)button{
    
    UIView *platformView = [_filterScrollView viewWithTag:100];
    
    if(button.isShowMores){
        
        button.isShowMores = NO;
        [UIView animateWithDuration:0.5f animations:^{
            _heigtConstraintForPlatformView.constant = 65.0f;
            
            [platformView setNeedsLayout];
            [platformView layoutIfNeeded];
            [_filterScrollView setNeedsLayout];
            [_filterScrollView layoutIfNeeded];
            
        }];
        
    }
    else{
        
        button.isShowMores = YES;
        [UIView animateWithDuration:0.5f animations:^{
            _heigtConstraintForPlatformView.constant = 150.0f;
            
            [platformView setNeedsLayout];
            [platformView layoutIfNeeded];
            [_filterScrollView setNeedsLayout];
            [_filterScrollView layoutIfNeeded];
        }];
    }
    
}


/**
 *  顶部按钮的点击事件
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
    
    if(_filterScrollView != nil){
        
        self.tabBarController.tabBar.hidden = NO;
        
        [_filterScrollView removeFromSuperview];
        
        [_sureButtonOfBottom removeFromSuperview];
        
        [_resetButtonOfBottom removeFromSuperview];
    }
    
    
}

- (void)sureButtonClicked:(UIButton *)button{
    
    BDBSubjectFilterContronller *filterController = [[BDBSubjectFilterContronller alloc] init];
    
    filterController.filterCondition = _filterCondition;
    
    [self.navigationController pushViewController:filterController animated:YES];
}


- (void)resetButtonClicked:(UIButton *)button{
    
    _filterCondition[@"平台"] = @"";
    
    _filterCondition[@"收益率"] = @"";
    
    _filterCondition[@"期限"] = @"";
    
    _filterCondition[@"进度"] = @"";
    
    for (id obj in _filterScrollView.subviews) {
        
        UIView *view = obj;
        
        for (id viewSubView in view.subviews) {
            
            if([viewSubView isKindOfClass:[BDBButtonForSift class]]){
                
                BDBButtonForSift *tmpButton = viewSubView;
                
                if(tmpButton.isSelected){
                    
                    tmpButton.isSelected = NO;
                    
                    break;
                }
            }
        }
    }
    
}

@end
