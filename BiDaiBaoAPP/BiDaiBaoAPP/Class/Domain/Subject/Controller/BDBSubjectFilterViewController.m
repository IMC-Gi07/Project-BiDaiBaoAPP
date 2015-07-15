//
//  BDBSujectFilterViewController.m
//  BiDaiBaoAPP
//
//  Created by Imcore.olddog.cn on 15/7/6.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBSubjectFilterViewController.h"
#import "BDBButtonForSift.h"
#import "BDBSiftButtonInfoModel.h"
#import "BDBSujectP2PListResponseModel.h"
#import "BDBSubjectDeepexcavationContronller.h"

/**
 *  筛选页面
 */
@interface BDBSubjectFilterViewController ()

@property(nonatomic,weak) UIScrollView *filterScrollView;

@property(nonatomic,weak) UILabel *selectedPlatformName;

@property(nonatomic,weak) NSLayoutConstraint *heigtConstraintForPlatformView;

@property(nonatomic,strong) NSMutableArray *platformArray;

//被选中的平台按钮
@property(nonatomic,strong) NSMutableArray *selectedPlatformArray;

//被选中的收益率按钮
@property(nonatomic,strong) NSMutableArray *selectedProfitArray;

//被选中的期限按钮
@property(nonatomic,strong) NSMutableArray *selectedTermArray;

//被选中的进度按钮
@property(nonatomic,strong) NSMutableArray *selectedProgressArray;

//被选中的所有筛选按钮的数组
@property(nonatomic,strong) NSMutableArray *selectedFilterArray;

//筛选条件的字典
@property(nonatomic,strong) NSMutableDictionary *filterCondition;

@property(nonatomic,strong) FMDatabaseQueue *dbqueue;


- (void)loadDBP2PList;

- (void)loadButtonOfBottom;

- (void)loadFilterScrollView;

- (void)loadFilterScrollViewSubView;

@end

@implementation BDBSubjectFilterViewController


- (instancetype)init{

    if (self = [super init]) {
        
        self.title = @"筛选";
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.platformArray = [NSMutableArray array];
        
        self.selectedPlatformArray = [NSMutableArray array];
        
        self.selectedProfitArray = [NSMutableArray array];
        
        self.selectedTermArray = [NSMutableArray array];
        
        self.selectedProgressArray = [NSMutableArray array];
        
        self.selectedFilterArray = [NSMutableArray array];
        
        self.filterCondition = [NSMutableDictionary dictionary];
        
        _filterCondition[@"平台"] = @"";
        
        _filterCondition[@"收益率"] = @"";
        
        _filterCondition[@"期限"] = @"";
        
        _filterCondition[@"进度"] = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDBP2PList];
    [self loadFilterScrollView];
    [self loadFilterScrollViewSubView];
    [self loadButtonOfBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadDBP2PList{

    NSString *dbFilePath = [CACHE_DIRECTORY stringByAppendingPathComponent:BDBGlobal_CacheDatabaseName];
    self.dbqueue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    
    if(_dbqueue){
    
        [_dbqueue inDatabase:^(FMDatabase *db) {
            
            NSString *sql = @"SELECT pid,name from t_platform";
            
            FMResultSet *resultSet = [db executeQuery:sql];
            
            while ([resultSet next]) {
                
                BDBSujectP2PListModel *platformModel = [[BDBSujectP2PListModel alloc] init];
                
                platformModel.PlatFormID = [resultSet stringForColumn:@"pid"];
                platformModel.PlatformName = [resultSet stringForColumn:@"name"];
                
                [_platformArray addObject:platformModel];
            }
        }];
    }
}

/**
 *  加载底部button（确认和重置）
 */
- (void)loadButtonOfBottom{
    
    UIButton *sureButtonOfBottom = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [sureButtonOfBottom setTitle:@"确认" forState:UIControlStateNormal];
    
    [sureButtonOfBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    sureButtonOfBottom.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    [sureButtonOfBottom addTarget:self action:@selector(changeColorInTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [sureButtonOfBottom addTarget:self action:@selector(sureButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButtonOfBottom];
    
    UIButton *resetButtonOfBottom = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [resetButtonOfBottom setTitle:@"重置" forState:UIControlStateNormal];
    
    [resetButtonOfBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    resetButtonOfBottom.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    
    [resetButtonOfBottom addTarget:self action:@selector(changeColorInTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [resetButtonOfBottom  addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:resetButtonOfBottom];
    
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

/**
 *  加载筛选页面
 */

- (void)loadFilterScrollView{
    
    //筛选页面
    UIScrollView *filterScrollView = [[UIScrollView alloc] init];
    
    filterScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:filterScrollView];
    
    self.filterScrollView = filterScrollView;
    
    filterScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *constraintsVFL = @"H:|[filterScrollView]|";
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"filterScrollView":filterScrollView}];
    
    [self.view addConstraints:hConstraints];
    
    constraintsVFL = @"V:|[filterScrollView]-50-|";
    
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"filterScrollView":filterScrollView}];
    
    
    [self.view addConstraints:vConstraints];
    
}
/**
 *  加载筛选页面的子视图
 */
- (void)loadFilterScrollViewSubView{

        //筛选页面－》选择平台
        UIScrollView *platformView = [[UIScrollView alloc] init];
    
        platformView.tag = 200;
    
        [_filterScrollView addSubview:platformView];
    
        platformView.translatesAutoresizingMaskIntoConstraints = NO;
    
        NSString *constraintsVFL = @"H:|[platformView(screenWidth)]|";
    
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"platformView":platformView}];
    
        [_filterScrollView addConstraints:hConstraints];
    
        //筛选页面－》选择平台(分割线)
    
        UIView *separator_0 = [[UIView alloc] init];
    
        separator_0.backgroundColor = UIColorWithRGB(204, 204, 204);
    
        [_filterScrollView addSubview:separator_0];
    
        separator_0.translatesAutoresizingMaskIntoConstraints = NO;
    
        constraintsVFL = @"H:|-[separator_0]-|";
    
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_0":separator_0}];
    
        [_filterScrollView addConstraints:hConstraints];
    
        //筛选页面－》年化收益率
        UIScrollView *profitView = [[UIScrollView alloc] init];
    
        [_filterScrollView addSubview:profitView];
    
        profitView.translatesAutoresizingMaskIntoConstraints = NO;
    
        constraintsVFL = @"H:|[profitView(screenWidth)]|";
    
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"profitView":profitView}];
    
        [_filterScrollView addConstraints:hConstraints];
    
        //筛选页面－》年化收益率(分割线)
    
        UIView *separator_1 = [[UIView alloc] init];
    
        separator_1.backgroundColor = UIColorWithRGB(204, 204, 204);
    
        [_filterScrollView addSubview:separator_1];
    
        separator_1.translatesAutoresizingMaskIntoConstraints = NO;
    
        constraintsVFL = @"H:|-[separator_1]-|";
    
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_1":separator_1}];
    
        [_filterScrollView addConstraints:hConstraints];
    
        //筛选页面－》投资期限
    
        UIScrollView *termView = [[UIScrollView alloc] init];
    
        [_filterScrollView addSubview:termView];
    
        termView.translatesAutoresizingMaskIntoConstraints = NO;
    
        constraintsVFL = @"H:|[termView(screenWidth)]|";
    
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"termView":termView}];
    
        [_filterScrollView addConstraints:hConstraints];
    
        //筛选页面－》年化收益率(分割线)
    
        UIView *separator_2 = [[UIView alloc] init];
    
        separator_2.backgroundColor = UIColorWithRGB(204, 204, 204);
    
        [_filterScrollView addSubview:separator_2];
    
        separator_2.translatesAutoresizingMaskIntoConstraints = NO;
    
        constraintsVFL = @"H:|-[separator_2]-|";
    
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"separator_2":separator_2}];
    
        [_filterScrollView addConstraints:hConstraints];
    
        // 筛选页面－》投资进度
        UIScrollView *progressView = [[UIScrollView alloc] init];
    
        [_filterScrollView addSubview:progressView];
    
        progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
        constraintsVFL = @"H:|[progressView(screenWidth)]|";
    
        hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:@{@"screenWidth":@SCREEN_WIDTH} views:@{@"progressView":progressView}];
    
        [_filterScrollView addConstraints:hConstraints];
    
    
        constraintsVFL = @"V:|[platformView][separator_0(1)][profitView(65)][separator_1(1)][termView(105)][separator_2(1)][progressView(65)]|";
    
       NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFL options:0 metrics:nil views:@{@"platformView":platformView,@"separator_0":separator_0,@"profitView":profitView,@"separator_1":separator_1,@"termView":termView,@"separator_2":separator_2,@"progressView":progressView}];
    
        NSLayoutConstraint *heigtConstraintForPlatformView = [NSLayoutConstraint constraintWithItem:platformView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:65.0f];
    
        self.heigtConstraintForPlatformView = heigtConstraintForPlatformView;
    
        [platformView addConstraint:heigtConstraintForPlatformView];
    
        [_filterScrollView addConstraints:vConstraints];
    
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
        
        //选择平台按钮
        
        [self layoutFilterViewPlatformButtonsWith:_platformArray view:platformView];
        
        //收益区间按钮
        [self layoutFilterViewButtons:0 view:profitView];
        
        //期限区间按钮
        [self layoutFilterViewButtons:1 view:termView];
        
        //投标进度按钮
        [self layoutFilterViewButtons:2 view:progressView];

}



//平台按钮

- (void)layoutFilterViewPlatformButtonsWith:(NSArray *)array view: (UIView *)aView{
    //更改横坐标
    NSInteger hButtonCount = 0;
    
    //更改纵坐标
    NSInteger vButtonCount = 0;
    
    
    for (BDBSujectP2PListModel *model in array) {
        
        BDBSiftButtonInfoModel *buttonModel = [[BDBSiftButtonInfoModel alloc] init];
        buttonModel.title = model.PlatformName;
        buttonModel.isSelected = NO;
        buttonModel.xPoint = hButtonCount;
        buttonModel.yPoint = vButtonCount;
        
        CGFloat platformButtonHorizontalMargin;
        CGRect frame;
        platformButtonHorizontalMargin = (SCREEN_WIDTH - 30 -4 * 65) / 3.0f;
        frame = CGRectMake(15 + 65 * buttonModel.xPoint + platformButtonHorizontalMargin * buttonModel.xPoint, 30 + 30 * buttonModel.yPoint + 10 * buttonModel.yPoint, 65, 30);
        
        BDBButtonForSift *button = [BDBButtonForSift buttonWithTitle:buttonModel.title  isSelected:buttonModel.isSelected frame:frame];
        __weak BDBButtonForSift *tmpButton = button;
        __weak typeof(self) thisInstance = self;
        [tmpButton handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
            if(!tmpButton.isSelected){
            
                tmpButton.isSelected = YES;
                
                //将被选中的按钮添加到数组中，以便重置
                [thisInstance.selectedFilterArray addObject:button];
                for (BDBSujectP2PListModel *model in _platformArray) {
                    
                    if([model.PlatformName isEqualToString:[tmpButton titleForState:UIControlStateNormal]]){
                        
                        //将被选中的平台按钮添加数组中
                        [thisInstance.selectedPlatformArray addObject:model.PlatFormID];
                        
                        break;
                    }
                }
            }
            
            else{
            
                tmpButton.isSelected = NO;
                [thisInstance.selectedFilterArray removeObject:tmpButton];
                
                for (BDBSujectP2PListModel *model in _platformArray) {
                    
                    if([model.PlatformName isEqualToString:[tmpButton titleForState:UIControlStateNormal]]){
                        
                        //将被选中的平台按钮移除数组
                        [thisInstance.selectedPlatformArray removeObject:model.PlatFormID];
                        
                        break;
                    }
                }
            }
            

        }];
        [aView addSubview:button];
        
        hButtonCount ++;
        
        if(hButtonCount == 4){
        
            vButtonCount += 1;
            
            hButtonCount = 0;
        }
        
    }
    
}


//投标进度按钮,期限区间按钮,收益区间按钮
- (void)layoutFilterViewButtons:(NSInteger)number view:(UIView *) aView{
    
    NSArray *filterButtonArray = [NSArray arrayWithContentsOfFile:FilePathInBundleWithNameAndType(@"filterButtons",@"plist")];
    
    NSArray *buttonsArray = filterButtonArray[number];
    
    
    BDBSiftButtonInfoModel *sievingButtonInfos = [[BDBSiftButtonInfoModel alloc] init];
    
    for (NSDictionary *buttonDict in buttonsArray) {
        
        [buttonDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            [sievingButtonInfos setValue:obj forKey:key];
        }];
        
        
        CGFloat platformButtonHorizontalMargin;
        CGRect frame;
        
            platformButtonHorizontalMargin = (SCREEN_WIDTH - 30 -3 * 90) / 2.0f;
            
            frame = CGRectMake(15 + 90 * sievingButtonInfos.xPoint + platformButtonHorizontalMargin * sievingButtonInfos.xPoint, 30 + 30 * sievingButtonInfos.yPoint + 10 * sievingButtonInfos.yPoint, 90, 30);
        
        BDBButtonForSift *button = [BDBButtonForSift buttonWithTitle:sievingButtonInfos.title  isSelected:sievingButtonInfos.isSelected frame:frame];
        
        __weak typeof(self) thisInstance = self;
        __weak BDBButtonForSift *weakButton = button;
        [button handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
            
            if(!weakButton.isSelected){
                
//                for (id obj in aView.subviews) {
//                    if([obj isKindOfClass:[BDBButtonForSift class]]){
//                        
//                        BDBButtonForSift *btn = obj;
//                        
//                        if(btn.isSelected == YES){
//                            
//                            btn.isSelected = NO;
//                            //移除上一个被选中的按钮
//                            [thisInstance.selectedFilterArray removeObject:btn];
//                            break;
//                        }
//                    }
//                }
                
                weakButton.isSelected = YES;
                //添加新选中的按钮
                [thisInstance.selectedFilterArray addObject:weakButton];
            }
            
            else{
            
                weakButton.isSelected = NO;
                [thisInstance.selectedFilterArray removeObject:weakButton];
            }
            
            NSString *buttonTitle = [button titleForState:UIControlStateNormal];
            
            NSString *filterStr = [NSString string];
            
            switch (number) {
                case 0:
                    
                    if([buttonTitle isEqualToString:@"<12%"]){
                        
                        filterStr = @"0.0|0.12";
                        
                    }
                    
                    if([buttonTitle isEqualToString:@"12%-15%"]){
                    
                        filterStr = @"0.12|0.15";
                        
                    }
                    
                    if([buttonTitle isEqualToString:@">15%"]){
                        
                        filterStr = @"0.15|1.0";
                        
                    }
                    
                    [thisInstance.selectedProfitArray addObject:filterStr];
                    break;
                case 1:
                    
                    if([buttonTitle isEqualToString:@"30天内"]){
                        
                        filterStr = @"0|30";

                    }
                    if([buttonTitle isEqualToString:@"1-3个月"]){
                        
                        filterStr = @"31|90";
                    }
                    if([buttonTitle isEqualToString:@"3-6个月"]){
                        
                        filterStr = @"91|120";
                        
                    }
                    if([buttonTitle isEqualToString:@"6-12个月"]){
                        
                        filterStr = @"121|365";
                        
                    }
                    if([buttonTitle isEqualToString:@"1-2年"]){
                        
                        filterStr = @"366|730";
                        
                    }
                    if([buttonTitle isEqualToString:@"2年以上"]){
                        
                        filterStr = @"731|9999999999";
                    }
                    
                    [thisInstance.selectedTermArray addObject:filterStr];
                    break;
                case 2:
                    
                    if([buttonTitle isEqualToString:@"50%以内"]){
                        
                        filterStr = @"0|0.5";

                    }
                    if([buttonTitle isEqualToString:@"50%-80%"]){
                        
                        filterStr = @"0.5|0.8";
                    }
                    if([buttonTitle isEqualToString:@"80%以上"]){
                        
                        filterStr = @"0.8|1.0";
                    }
                    
                    [thisInstance.selectedProgressArray addObject:filterStr];
                    break;
                default:
                    break;
            }

        }];
        [aView addSubview:button];
        
    }
}

/**
 * 按下按钮，改变按钮颜色
 */

- (void)changeColorInTouchDown:(UIButton *)button{
    
    button.backgroundColor = UIColorWithRGB(254, 157, 162);
}
/**
 * 确认键被按下时触发的事件
 */

- (void)sureButtonClickedAction: (UIButton *)button{
    
    button.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    //_filterCondition[@"平台"] = _selectedPlatformArray;
    
    BDBSubjectDeepexcavationContronller *controller = [[BDBSubjectDeepexcavationContronller alloc] init];
    
    controller.selectedPlatformArray = _selectedPlatformArray;
    controller.selectedProfitArray = _selectedProfitArray;
    controller.selectedTermArray = _selectedTermArray;
    controller.selectedProgressArray = _selectedProgressArray;
    [self.navigationController pushViewController:controller animated:YES];
}
/**
 * 重置键被按下时触发的事件
 */
- (void)resetButtonClicked:(UIButton *)button{

    button.backgroundColor = UIColorWithRGB(228, 93, 99);
    
    for (BDBButtonForSift *button in _selectedFilterArray) {
        
        button.isSelected = NO;
    }
    
    [self.selectedPlatformArray removeAllObjects];
    
    [self.selectedProgressArray removeAllObjects];
    
    [self.selectedTermArray removeAllObjects];
    
    [self.selectedProgressArray removeAllObjects];
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
            
            NSInteger buttonCount = _platformArray.count;
            
            if(buttonCount % 4 == 0){
                
                _heigtConstraintForPlatformView.constant = buttonCount / 4 * 30 +  (buttonCount / 4 - 1) * 10 + 40;
            }
            else{
            
                _heigtConstraintForPlatformView.constant = (buttonCount / 4 + 1) * 30 + buttonCount / 4  * 10 + 40;
            }
        
            [platformView setNeedsLayout];
            [platformView layoutIfNeeded];
            [_filterScrollView setNeedsLayout];
            [_filterScrollView layoutIfNeeded];
        }];
    }
    
}

@end
