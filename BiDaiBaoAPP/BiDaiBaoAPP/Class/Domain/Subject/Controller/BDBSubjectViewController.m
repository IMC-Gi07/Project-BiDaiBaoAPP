//
//  BDBSubjectViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/6.
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


@interface BDBSubjectViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UIView *topView;

@property(nonatomic,weak) UITableView *showDataTableView;

@property(nonatomic,weak) UIScrollView *sievingScrollView;

@property(nonatomic,copy) NSArray *sievingButtonArray;

@property(nonatomic,weak) UIButton *sureButtonOfBottom;

@property(nonatomic,weak) UIButton *resetButtonOfBottom;

@property(nonatomic,weak) UILabel *selectedPlatformName;

//@property(nonatomic,strong) BDBSiftButtonInfoModel *sievingButtonInfos;

@property(nonatomic,strong) NSMutableArray *sujectModelDatas;

@property(nonatomic,weak) UIScrollView *platformView;

@property(nonatomic,weak) NSLayoutConstraint *heigtConstraintForPlatformView;


- (void)loadTopView;

- (void)loadShowDataTableView;

- (void)loadSievingButtonInfos;

- (void)loadBidsInf;

- (void)loadButtonOfBottom;

- (void)layoutSievingViewButtons:(NSInteger)number view:(UIView *)aView;

@end

@implementation BDBSubjectViewController

#pragma mark - Initial Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if(self = [super initWithCoder:aDecoder]){
    
        self.title = @"标的";
        
//        self.sievingButtonInfos = [[BDBSiftButtonInfoModel alloc] init];
        
        self.sujectModelDatas = [NSMutableArray array];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [self loadBidsInf];
        
        [self loadSievingButtonInfos];

        
    }
    
    return self;
}

#pragma mark - Instance Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadTopView];
    [self loadShowDataTableView];
    
    //[self loadSievingScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LoadDatas  Methods

- (void)loadSievingButtonInfos{

    self.sievingButtonArray = [NSArray arrayWithContentsOfFile:FilePathInBundleWithNameAndType(@"siftButtons",@"plist")];
    
}

- (void)loadBidsInf{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *serviceHTTP = @"http://117.25.155.115:8082";
    
    NSString *requestURL = [serviceHTTP stringByAppendingPathComponent:@"GetWorthyBids"];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    
    parametersDict[@"Machine_id"] = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    parametersDict[@"Device"] = @"0";
    
    parametersDict[@"PageInDex"] = @"1";
    
    parametersDict[@"PageSize"] = @"5";
    
    parametersDict[@"Count"] = @"0";
    
    [manager POST:requestURL parameters:parametersDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBSujectRespondModel *sujectREspondModel = [BDBSujectRespondModel objectWithKeyValues:responseObject];
        
        self.sujectModelDatas = [[_sujectModelDatas arrayByAddingObjectsFromArray:sujectREspondModel.BidList] mutableCopy];
    
        [_showDataTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ZXLLOG(@"%@",error);
    }];
    
}

#pragma mark - Add SubViews Methods

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
    
    UIImageView *topViewBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subject_btnTopview_bg_img"]];
    
    [topView addSubview:topViewBackgroundImage];
    
    topViewBackgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstrainsTopViewBackgroundImage = [NSLayoutConstraint constraintsWithVisualFormat:@"|[topViewBackgroundImage]|" options:NSLayoutFormatAlignmentMask metrics:nil views:@{@"topViewBackgroundImage":topViewBackgroundImage}];
    
    NSArray *vConstrainsTopViewBackgroundImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topViewBackgroundImage]|" options:NSLayoutFormatAlignAllTop metrics:nil views:@{@"topViewBackgroundImage":topViewBackgroundImage}];
    
    [topView addConstraints:hConstrainsTopViewBackgroundImage];
    [topView addConstraints:vConstrainsTopViewBackgroundImage];
    
    //topView按钮

    BDBButtonForTopView *buttonOfProfit = [BDBButtonForTopView buttonWithTitle:@"收益率" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    
    buttonOfProfit.frame = CGRectMake(0, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfProfit];
    
    BDBButtonForTopView *buttonOfProgress = [BDBButtonForTopView buttonWithTitle:@"进度" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    buttonOfProgress.frame = CGRectMake(SCREEN_WIDTH / 4 * 1, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfProgress];
    
    BDBButtonForTopView *buttonOfTimeLimit = [BDBButtonForTopView buttonWithTitle:@"期限" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    buttonOfTimeLimit.frame = CGRectMake(SCREEN_WIDTH / 4 * 2, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfTimeLimit];
    
    BDBButtonForTopView *buttonOfSift = [BDBButtonForTopView buttonWithTitle:@"筛选" titleColor:UIColorWithRGB(69 , 165, 225) image:[UIImage imageNamed:@"subject_btnTopview_icon_sift"]];
    
    __weak typeof (self) thisInstance = self;
    
    [buttonOfSift handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        
        
        if(thisInstance.sievingScrollView == nil){
            
            buttonOfProfit.enabled = NO;
            buttonOfProgress.enabled = NO;
            buttonOfTimeLimit.enabled = NO;
            
            buttonOfProfit.isClicked = NO;
            buttonOfProgress.isClicked = NO;
            buttonOfTimeLimit.isClicked = NO;
            
            [buttonOfTimeLimit setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
            [buttonOfProgress setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
            [buttonOfProfit setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
            
            [thisInstance loadButtonOfBottom];
            [thisInstance loadSievingScrollView];
            
            
            CATransition *transition = [CATransition animation];
            
            transition.type = kCATransitionPush;
            
            transition.duration = 0.2f;
            
            transition.subtype = kCATransitionFromBottom;
            
            [thisInstance.sievingScrollView.layer addAnimation:transition forKey:nil];
            
            [thisInstance.showDataTableView removeFromSuperview];

        }
        else{
        
            buttonOfProfit.enabled = YES;
            buttonOfProgress.enabled = YES;
            buttonOfTimeLimit.enabled = YES;
            
            [thisInstance loadShowDataTableView];
            [thisInstance removeButtonsOfBottom];
            [thisInstance.sievingScrollView removeFromSuperview];
            CATransition *transition = [CATransition animation];
            
            transition.type = kCATransitionPush;
            
            transition.duration = 0.2f;
            
            transition.subtype = kCATransitionFromTop;
            
            [thisInstance.showDataTableView.layer addAnimation:transition forKey:nil];
            
            NSLog(@"%@,",thisInstance.sievingScrollView);
            
            
        }

        
    }];
    
    buttonOfSift.frame = CGRectMake(SCREEN_WIDTH / 4 * 3, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfSift];
    
    [buttonOfTimeLimit handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        
        if(buttonOfTimeLimit.isClicked){
            
            buttonOfTimeLimit.isClicked = NO;
        }
        else{
            
            buttonOfTimeLimit.isClicked = YES;
            
        }
        
        [buttonOfTimeLimit setTitleColor:UIColorWithRGB(74, 168, 232) forState:UIControlStateNormal];
        [buttonOfProgress setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
        [buttonOfProfit setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
    }];
    
    [buttonOfProgress handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        
        if(buttonOfProgress.isClicked){
            
            buttonOfProgress.isClicked = NO;
        }
        else{
            
            buttonOfProgress.isClicked = YES;
            
        }
        
        [buttonOfProgress setTitleColor:UIColorWithRGB(74, 168, 232) forState:UIControlStateNormal];
        [buttonOfTimeLimit setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
        [buttonOfProfit setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
    }];
    [buttonOfProfit handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        
        if(buttonOfProfit.isClicked){
            
            buttonOfProfit.isClicked = NO;
        }
        else{
            
            buttonOfProfit.isClicked = YES;
            
        }
        
        [buttonOfProfit setTitleColor:UIColorWithRGB(74, 168, 232) forState:UIControlStateNormal];
        [buttonOfTimeLimit setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
        [buttonOfProgress setTitleColor:UIColorWithRGB(136, 136, 136) forState:UIControlStateNormal];
    }];
    
    


}

- (void)loadSievingScrollView{
    
    
    //筛选页面
    UIScrollView *sievingScrollView = [[UIScrollView alloc] init];
    
    sievingScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:sievingScrollView];
    
    self.sievingScrollView = sievingScrollView;
    
    sievingScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *constraintsVFL = @"H:|[sievingScroView]|";
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"sievingScroView":sievingScrollView}];
    
    [self.view addConstraints:hConstraints];
    
    constraintsVFL = @"V:[topView][sievingScroView]-50-|";
    
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"topView":_topView,@"sievingScroView":sievingScrollView}];
    
    [self.view addConstraints:vConstraints];
    
    
    //筛选页面－》选择平台
    UIScrollView *platformView = [[UIScrollView alloc] init];
    
    [sievingScrollView addSubview:platformView];
    
    self.platformView = platformView;
    
    platformView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[platformView(screenWidth)]";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"platformView":platformView}];
    
    [sievingScrollView addConstraints:hConstraints];
    
    //筛选页面－》选择平台(分割线)
    
    UIView *separator_0 = [[UIView alloc] init];
    
    separator_0.backgroundColor = UIColorWithRGB(204, 204, 204);
    
    [sievingScrollView addSubview:separator_0];
    
    separator_0.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|-[separator_0]-|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_0":separator_0}];
    
    [sievingScrollView addConstraints:hConstraints];
    
    //筛选页面－》年化收益率
    UIScrollView *profitView = [[UIScrollView alloc] init];
    
    [sievingScrollView addSubview:profitView];
    
    profitView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[profitView(screenWidth)]|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"profitView":profitView}];
    
    [sievingScrollView addConstraints:hConstraints];
    
    //筛选页面－》年化收益率(分割线)
    
    UIView *separator_1 = [[UIView alloc] init];
    
    separator_1.backgroundColor = UIColorWithRGB(204, 204, 204);
    
    [sievingScrollView addSubview:separator_1];
    
    separator_1.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|-[separator_1]-|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_1":separator_1}];
    
    [sievingScrollView addConstraints:hConstraints];
    
    //筛选页面－》投资期限
    
    UIScrollView *termView = [[UIScrollView alloc] init];
    
    [sievingScrollView addSubview:termView];
    
    termView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[termView(screenWidth)]|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"termView":termView}];
    
    [sievingScrollView addConstraints:hConstraints];
    
    //筛选页面－》年化收益率(分割线)
    
    UIView *separator_2 = [[UIView alloc] init];
    
    separator_2.backgroundColor = UIColorWithRGB(204, 204, 204);
    
    [sievingScrollView addSubview:separator_2];
    
    separator_2.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|-[separator_2]-|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_2":separator_2}];
    
    [sievingScrollView addConstraints:hConstraints];
    
    // 筛选页面－》投资进度
    UIScrollView *progressView = [[UIScrollView alloc] init];
    
    [sievingScrollView addSubview:progressView];
    
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraintsVFL = @"H:|[progressView(screenWidth)]|";
    
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"progressView":progressView}];
    
    [sievingScrollView addConstraints:hConstraints];

    
    constraintsVFL = @"V:|[platformView][separator_0(1)][profitView(65)][separator_1(1)][termView(105)][separator_2(1)][progressView(65)]|";
    
    vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"platformView":platformView,@"separator_0":separator_0,@"profitView":profitView,@"separator_1":separator_1,@"termView":termView,@"separator_2":separator_2,@"progressView":progressView}];
    
    NSLayoutConstraint *heigtConstraintForPlatformView = [NSLayoutConstraint constraintWithItem:platformView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:65.0f];

    self.heigtConstraintForPlatformView = heigtConstraintForPlatformView;
    
    [platformView addConstraint:heigtConstraintForPlatformView];
    
    [sievingScrollView addConstraints:vConstraints];
    
    //筛选页面－》选择平台(选择平台)
    
    UILabel *platformLabel = [[UILabel alloc] init];
    
    platformLabel.text = @"选择平台:";
    
    [platformView addSubview:platformLabel];
    
    platformLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    platformLabel.frame = CGRectMake(10, 10, 70, 15);
    
    //筛选页面－》选择平台(显示更多平台按钮)
    
    BDBButtonForSift *showMoreButton = [BDBButtonForSift showMoreButton];
    
    [showMoreButton handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        if(showMoreButton.isShowMores){
        
            showMoreButton.isShowMores = NO;
            [UIView animateWithDuration:0.5f animations:^{
                heigtConstraintForPlatformView.constant = 65.0f;
                
                [platformView setNeedsLayout];
                [platformView layoutIfNeeded];
                [sievingScrollView setNeedsLayout];
                [sievingScrollView layoutIfNeeded];

            }];
            
        }
        else{
        
            showMoreButton.isShowMores = YES;
            [UIView animateWithDuration:0.5f animations:^{
                heigtConstraintForPlatformView.constant = 150.0f;
                
                [platformView setNeedsLayout];
                [platformView layoutIfNeeded];
                [sievingScrollView setNeedsLayout];
                [sievingScrollView layoutIfNeeded];
            }];
        }
    }];
    
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
    
    progressLabel.text = @"投资期限:";
    
    [progressView addSubview:progressLabel];
    
    progressLabel.font  = [UIFont systemFontOfSize:15.0f];
    
    progressLabel.frame = CGRectMake(10, 10, 80, 15);
    
    [self layoutSievingViewButtons:0 view:platformView];
    [self layoutSievingViewButtons:1 view:profitView];
    [self layoutSievingViewButtons:2 view:termView];
    [self layoutSievingViewButtons:3 view:progressView];
    
    [_resetButtonOfBottom handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
       
        for (id obj in sievingScrollView.subviews) {
            
            UIView *view = obj;
            
            for (id viewSubView in view.subviews) {
                
                if([viewSubView isKindOfClass:[BDBButtonForSift class]]){
                    
                    BDBButtonForSift *tmpButton = viewSubView;
                    
                    if(tmpButton.isSelected){
                    
                        tmpButton.isSelected = NO;
                    }
                }
            }
        }
    }];
    
}

- (void)layoutSievingViewButtons:(NSInteger)number view:(UIView  *) aView{

    NSArray *buttonsArray = _sievingButtonArray[number];
    
    
    BDBSiftButtonInfoModel *sievingButtonInfos = [[BDBSiftButtonInfoModel alloc] init];
    
    //__weak typeof(self) thisInstance = self;
    
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
            
                _selectedPlatformName.text = [button titleForState:UIControlStateNormal];
                
            }
        }];
        
        [aView addSubview:button];
        
    }
}

- (void)loadShowDataTableView{
    
    UITableView *showDataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    showDataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    showDataTableView.dataSource = self;
    
    showDataTableView.delegate = self;
        
    [self.view addSubview:showDataTableView];
    
    self.showDataTableView = showDataTableView;
    
    showDataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hConstrainsVFL = @"|[showDataTableView]|";
    
    NSString *vConstrainsVFL = @"V:[topView][showDataTableView]-(50)-|";
    
    NSArray *hConstrains = [NSLayoutConstraint constraintsWithVisualFormat:hConstrainsVFL options:NSLayoutFormatAlignAllBottom metrics:nil views:@{@"showDataTableView":showDataTableView}];
    
    NSArray *vConstrains = [NSLayoutConstraint constraintsWithVisualFormat:vConstrainsVFL options:NSLayoutFormatAlignAllLeading metrics:nil views:@{@"showDataTableView":showDataTableView,@"topView":_topView}];
    
    [self.view addConstraints:hConstrains];
    [self.view addConstraints:vConstrains];
    

}

- (void)loadButtonOfBottom{
    
    UIButton *sureButtonOfBottom = [UIButton buttonWithType:UIButtonTypeSystem];

    [sureButtonOfBottom setTitle:@"确认" forState:UIControlStateNormal];
    
    [sureButtonOfBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    sureButtonOfBottom.hidden = NO;
    
    sureButtonOfBottom.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    [self.view addSubview:sureButtonOfBottom];
    
    self.sureButtonOfBottom = sureButtonOfBottom;
    
    UIButton *resetButtonOfBottom = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [resetButtonOfBottom setTitle:@"重置" forState:UIControlStateNormal];
    
    [resetButtonOfBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    resetButtonOfBottom.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    resetButtonOfBottom.hidden = NO;
    
    
//    __weak typeof(self) thisInstance = self;
//    [resetButtonOfBottom handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
//        
//        thisInstance.platformLabel.text = @"人人贷";
//        [thisInstance loadSievingButtonInfos];
//        [thisInstance.showDataTableView reloadData];
//        [thisInstance.showDataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }];
    
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
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)removeButtonsOfBottom{

    [_sureButtonOfBottom removeFromSuperview];
    [_resetButtonOfBottom removeFromSuperview];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)showRefreshMessage{
    
    UIView *refreshView = [[UIView alloc] init];
    
    refreshView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:refreshView];
    
    refreshView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hConstrainsVFL = @"|[refreshView]|";
    
    NSArray *hConstrains = [NSLayoutConstraint constraintsWithVisualFormat:hConstrainsVFL options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"refreshView":refreshView}];
    
    NSLayoutConstraint *refreshViewTopConstrain = [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *refreshViewHeight = [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    [self.view addConstraint:refreshViewTopConstrain];
    [self.view addConstraints:hConstrains];
    [refreshView addConstraint:refreshViewHeight];
    
    
    
    
    NSArray *constrains = self.view.constraints;
    
    for (NSLayoutConstraint *constrain in constrains) {
        if(constrain.firstItem == _showDataTableView && constrain.secondAttribute == NSLayoutAttributeBottom){
            
            constrain.constant += 30.0f;
            
        }
    }
    
    [self performSelector:@selector(removeVIewofMessage:) withObject:refreshView afterDelay:2];
    
}

- (void)removeVIewofMessage:(UIView *) view{
    
    [view removeFromSuperview];
    
    NSArray *constrains = self.view.constraints;
    
    for (NSLayoutConstraint *constrain in constrains) {
        if(constrain.firstItem == _showDataTableView && constrain.secondAttribute == NSLayoutAttributeBottom){
            constrain.constant = 0.0f;
            
            break;
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _sujectModelDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        
        BDBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
        
        if(cell == nil){
            
            cell = [BDBTableViewCell cellWithModel:_sujectModelDatas[indexPath.row]];
        }
        
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 150;
}


#pragma  mark -BDBButtonForTopViewDelegate Methods

- (void)showMoreButtonActionClicked: (BDBButtonForSift *)button{

    if(button.isShowMores){
        
        button.isShowMores = NO;
        [UIView animateWithDuration:0.5f animations:^{
            _heigtConstraintForPlatformView.constant = 65.0f;
            
            [button setNeedsLayout];
            [button layoutIfNeeded];
            [_sievingScrollView setNeedsLayout];
            [_sievingScrollView layoutIfNeeded];
            
        }];
        
    }
    else{
        
        button.isShowMores = YES;
        [UIView animateWithDuration:0.5f animations:^{
            _heigtConstraintForPlatformView.constant = 150.0f;
            
            [_platformView setNeedsLayout];
            [_platformView layoutIfNeeded];
            [_sievingScrollView setNeedsLayout];
            [_sievingScrollView layoutIfNeeded];
        }];
    }
    
}



@end
