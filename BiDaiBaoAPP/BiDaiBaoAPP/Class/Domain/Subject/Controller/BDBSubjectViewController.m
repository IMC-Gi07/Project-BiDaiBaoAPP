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

NSInteger const KnumberOfRowsForSievingPage  = 1;
NSInteger const KnumberOfSeciontsForSievingPage  = 4;
NSInteger const KnumberOfSeciontsForHomePage  = 1;

typedef enum {
    sujectHomePage,sujectSievingPage
}CurrentPage;

@interface BDBSubjectViewController () <UITableViewDataSource,UITableViewDelegate,BDBButtonForTopViewDelegate>

@property(nonatomic,weak)UIView *topView;

@property(nonatomic,weak) UITableView *showDataTableView;

@property(nonatomic,weak) UITableView *showSievingTableView;

@property(nonatomic,copy) NSArray *sievingButtonArray;

@property(nonatomic,strong) UILabel *platformLabel;

@property(nonatomic,weak) UIButton *sureButtonOfBottom;

@property(nonatomic,weak) UIButton *resetButtonOfBottom;

@property(nonatomic,strong) BDBSiftButtonInfoModel *sievingButtonInfos;

@property(nonatomic,strong) BDBButtonForSift *showMoreButton;

@property(nonatomic,strong) NSMutableArray *sujectModelDatas;

@property(nonatomic,assign) CurrentPage currentPage;


- (void)loadTopView;

- (void)loadShowDataTableView;

- (void)loadSievingButtonInfos;

- (void)loadBidsInf;

- (void)loadButtonOfBottom;

@end

@implementation BDBSubjectViewController

#pragma mark - Initial Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if(self = [super initWithCoder:aDecoder]){
    
        self.title = @"标的";
        
        self.sievingButtonInfos = [[BDBSiftButtonInfoModel alloc] init];
        
        self.showMoreButton = [BDBButtonForSift showMoreButton];
        
        self.sujectModelDatas = [NSMutableArray array];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.currentPage = sujectSievingPage;
        
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
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
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
    
    buttonOfProfit.delegate = self;
    
    buttonOfProfit.frame = CGRectMake(0, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfProfit];
    
    BDBButtonForTopView *buttonOfProgress = [BDBButtonForTopView buttonWithTitle:@"进度" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    buttonOfProgress.delegate = self;
    
    buttonOfProgress.frame = CGRectMake(SCREEN_WIDTH / 4 * 1, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfProgress];
    
    BDBButtonForTopView *buttonOfTimeLimit = [BDBButtonForTopView buttonWithTitle:@"期限" titleColor:UIColorWithRGB(93, 92, 97) image:[UIImage imageNamed:@"subject_btnTopview_icon_up"]];
    
    buttonOfTimeLimit.delegate = self;
    
    buttonOfTimeLimit.frame = CGRectMake(SCREEN_WIDTH / 4 * 2, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfTimeLimit];
    
    BDBButtonForTopView *buttonOfSift = [BDBButtonForTopView buttonWithTitle:@"筛选" titleColor:UIColorWithRGB(69 , 165, 225) image:[UIImage imageNamed:@"subject_btnTopview_icon_sift"]];
    
    buttonOfSift.delegate = self;
    
    buttonOfSift.frame = CGRectMake(SCREEN_WIDTH / 4 * 3, 0, SCREEN_WIDTH / 4, 44);
    
    [topView addSubview:buttonOfSift];

}

- (void)loadShowDataTableView{

    if(_currentPage == sujectHomePage){
        
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
    else{
    
        UITableView *showSievingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        showSievingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        showSievingTableView.dataSource = self;
        
        showSievingTableView.delegate = self;
        
        [self.view addSubview:showSievingTableView];
        
        self.showSievingTableView = showSievingTableView;
        
        showSievingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSString *hConstrainsVFL = @"|[showSievingTableView]|";
        
        NSString *vConstrainsVFL = @"V:[topView][showSievingTableView]-(50)-|";
        
        NSArray *hConstrains = [NSLayoutConstraint constraintsWithVisualFormat:hConstrainsVFL options:NSLayoutFormatAlignAllBottom metrics:nil views:@{@"showSievingTableView":showSievingTableView}];
        
        NSArray *vConstrains = [NSLayoutConstraint constraintsWithVisualFormat:vConstrainsVFL options:NSLayoutFormatAlignAllLeading metrics:nil views:@{@"showSievingTableView":showSievingTableView,@"topView":_topView}];
        
        [self.view addConstraints:hConstrains];
        [self.view addConstraints:vConstrains];
        
        [self loadButtonOfBottom];
        
    }
    

    
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
    
    
    __weak typeof(self) thisInstance = self;
    [resetButtonOfBottom handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
        
        thisInstance.platformLabel.text = @"人人贷";
        [thisInstance loadSievingButtonInfos];
        [thisInstance.showDataTableView reloadData];
        [thisInstance.showDataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.tabBar.hidden = YES;
    });
    
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
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numberOfSecionts;
    if(_currentPage == sujectHomePage){
    
        numberOfSecionts = KnumberOfSeciontsForHomePage;
    }
    else{
    
        numberOfSecionts = KnumberOfSeciontsForSievingPage;
    }
    return numberOfSecionts;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numberOfRows;
    
    if(_currentPage == sujectHomePage){
    
        numberOfRows = _sujectModelDatas.count;
    }
    else{
    
        numberOfRows = KnumberOfRowsForSievingPage;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(_currentPage == sujectHomePage){
        
        BDBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
        
        if(cell == nil){
            
            cell = [BDBTableViewCell cellWithModel:_sujectModelDatas[indexPath.row]];
        }
        
        return cell;
        
    }
    else{
        BDBTableViewCell_Sift *cell = [BDBTableViewCell_Sift cell];
        
        [cell createContentsAccordingSection:indexPath.section];
        
        if(indexPath.section == 0){
            
            [cell addSubview:_showMoreButton];
            
            [_showMoreButton handleControlEvent:UIControlEventTouchUpInside withHandleBlock:^{
                if(_showMoreButton.isShowMores){
                
                    _showMoreButton.isShowMores = NO;
                }
                else{
                
                    _showMoreButton.isShowMores = YES;
                }
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
        
        NSArray *array = _sievingButtonArray[indexPath.section];
        
        BDBButtonForSift *button;
        
        if(array.count != 0){
            
            
            for (NSDictionary *dic in array) {
                
                __weak typeof(self) thisInstance = self;
                
                [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    
                    [thisInstance.sievingButtonInfos setValue:obj forKey:key];
                }];
                
                CGFloat platformButtonHorizontalMargin;
                CGRect frame;
                
                if(indexPath.section == 0){
                    
                    platformButtonHorizontalMargin = (SCREEN_WIDTH - 30 -4 * 60) / 3.0f;
                    
                    frame = CGRectMake(15 + 60 * _sievingButtonInfos.xPoint + platformButtonHorizontalMargin * _sievingButtonInfos.xPoint, 30 + 30 * _sievingButtonInfos.yPoint + 10 * _sievingButtonInfos.yPoint, 65, 30);
                }
                else{
                    
                    platformButtonHorizontalMargin = (SCREEN_WIDTH - 30 -3 * 80) / 2.0f;
                    
                    frame = CGRectMake(15 + 80 * _sievingButtonInfos.xPoint + platformButtonHorizontalMargin * _sievingButtonInfos.xPoint, 40 + 30 * _sievingButtonInfos.yPoint + 10 * _sievingButtonInfos.yPoint, 80, 30);
                }
                
                button = [BDBButtonForSift buttonWithTitle:_sievingButtonInfos.title section:indexPath.section isSelected:_sievingButtonInfos.isSelected frame:frame];
                
                button.singleSelectForSiftBlock = ^(NSString *title,BOOL isSelected){
                    
                    NSMutableArray *tmpOriginalDatas = [_sievingButtonArray mutableCopy];
                    
                    NSMutableArray *tmpArray = [tmpOriginalDatas[indexPath.section] mutableCopy];
                    
                    for(NSInteger i = 0; i < tmpArray.count; i ++){
                        
                        NSMutableDictionary *tmpDict = [tmpArray[i] mutableCopy];
                        
                        if([tmpDict[@"title"] isEqualToString:title]){
                            
                            tmpDict[@"isSelected"] = [NSNumber numberWithBool:isSelected];
                            
                            [tmpArray replaceObjectAtIndex:i withObject:[tmpDict copy]];
                            
                            [tmpOriginalDatas replaceObjectAtIndex:indexPath.section withObject:tmpArray];
                            
                            _sievingButtonArray = [tmpOriginalDatas copy];
                            
                            break;
                        }
                    }
                };
                

                [cell.scrollView addSubview:button];
            }
        }
        return cell;
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat heightForRow;
    
    if(_currentPage == sujectHomePage){
        
        heightForRow = 150.0f;
    }
    else{
        
        if(indexPath.section == 0){
            
            if(_showMoreButton.isShowMores){
                
                heightForRow = 180.0f;
            }
            else{
                
                heightForRow = 130.0f;
            }
            
        }
        else{
            heightForRow = 120.0f;
        }
    }
    return heightForRow;
}


#pragma  mark -BDBButtonForTopViewDelegate Methods

- (void)swithCurrentView:(BDBButtonForTopView *)button{


}


@end
