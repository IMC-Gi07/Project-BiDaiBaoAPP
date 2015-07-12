//
//  BDBMyCollectViewController.m
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/15.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBMyCollectViewController.h"
#import "BDBTableViewCellCoustom.h"
#import "BDBMyColletDateModel.h"
#import "BDBMyColletDateBidListModel.h"
#import "BDBUserProfitCalculatorViewController.h"


typedef enum{

    notSoldOut,isSoldOut
}CollectionSoldOut;

@interface BDBMyCollectViewController () <UITableViewDelegate,UITableViewDataSource,buttonSelectd>


@property (weak, nonatomic) IBOutlet UITableView *collectTableView;

//用来承接给第二个model
@property(nonatomic,strong) NSMutableArray *noticeModels;
@property(nonatomic,assign) NSUInteger PageInDex;
//纪录cell的选中状态
@property (nonatomic,strong) NSMutableDictionary *selectedCellIndexPaths;

@property (weak, nonatomic) IBOutlet UISegmentedControl *collectionSegmented;

//是否售罄
@property(nonatomic,assign) CollectionSoldOut collectionSoldOut;


//请求数据
-(void)RequestDate;





@end

@implementation BDBMyCollectViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.title = @"我的收藏";
        self.selectedCellIndexPaths = [NSMutableDictionary dictionary];
        
        self.noticeModels = [NSMutableArray array];
        
        self.collectionSoldOut = notSoldOut;
        
        [self RequestDate];
        
    }
    
    return self;
    
}


-(void)RequestDate{
    /**
     *    用户请求收藏的数据
     **/
    self.PageInDex = 1;
    
    NSString *soldout;
    
    if(_collectionSoldOut == notSoldOut){
    
        soldout = @"0";
    }
    else{
    
        soldout = @"1";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultsUID = [defaults objectForKey:@"UID"];
    NSString *defaultsPSW = [defaults objectForKey:@"PSW"];
    
    AFHTTPRequestOperationManager *GetBidsStoreManager = [AFHTTPRequestOperationManager manager];
    
    NSString *GetBidsStoreUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetBidsStore"];
    
    NSMutableDictionary *GetBidsStoreParameters = [NSMutableDictionary dictionary];
    GetBidsStoreParameters[@"UID"] = defaultsUID;
    GetBidsStoreParameters[@"PSW"] = defaultsPSW;
    GetBidsStoreParameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    GetBidsStoreParameters[@"Device"] = @"0";
    GetBidsStoreParameters[@"PageInDex"] = [NSString stringWithFormat:@"%lu",(unsigned long)_PageInDex];;
    GetBidsStoreParameters[@"PageSize"] = @"10";
    GetBidsStoreParameters[@"Count"] = @"1";
    GetBidsStoreParameters[@"SoldOut"] = soldout;
    
    [GetBidsStoreManager POST:GetBidsStoreUrl parameters:GetBidsStoreParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /**
         *  将字典转换为模型
         */
        BDBMyColletDateModel *MyColletDateModel = [BDBMyColletDateModel objectWithKeyValues:responseObject];
        self.noticeModels = MyColletDateModel.BidList;
        
        [_collectTableView reloadData];
        [_collectTableView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    



}
//下一页数据
-(void)RequestNextPageIndex{
    
    NSString *soldout;
    
    if(_collectionSoldOut == notSoldOut){
        
        soldout = @"0";
    }
    else{
        
        soldout = @"1";
    }
    self.PageInDex ++;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultsUID = [defaults objectForKey:@"UID"];
    NSString *defaultsPSW = [defaults objectForKey:@"PSW"];
    
    AFHTTPRequestOperationManager *GetBidsStoreManager = [AFHTTPRequestOperationManager manager];
    
    NSString *GetBidsStoreUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetBidsStore"];
    
    NSMutableDictionary *GetBidsStoreParameters = [NSMutableDictionary dictionary];
    GetBidsStoreParameters[@"UID"] = defaultsUID;
    GetBidsStoreParameters[@"PSW"] = defaultsPSW;
    GetBidsStoreParameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    GetBidsStoreParameters[@"Device"] = @"0";
    GetBidsStoreParameters[@"PageInDex"] = [NSString stringWithFormat:@"%lu",(unsigned long)_PageInDex];;
    GetBidsStoreParameters[@"PageSize"] = @"10";
    GetBidsStoreParameters[@"Count"] = @"1";
    GetBidsStoreParameters[@"SoldOut"] = soldout;
    
    [GetBidsStoreManager POST:GetBidsStoreUrl parameters:GetBidsStoreParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /**
         *  将字典转换为模型
         */
        BDBMyColletDateModel *MyColletDateModel = [BDBMyColletDateModel objectWithKeyValues:responseObject];
        [_noticeModels addObjectsFromArray:MyColletDateModel.BidList];
        [_collectTableView.footer endRefreshing];
        
        [_collectTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];



}



-(void)viewWillAppear:(BOOL)animated{
    
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectTableView.delegate = self;
    _collectTableView.dataSource = self;
    self.collectTableView.rowHeight = 180;
    //隐藏tableview的头
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[self RequestDate];
    [self RefreshHeaderAndFoot];
    
    [_collectionSegmented addTarget:self action:@selector(switchSoudOutState:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)switchSoudOutState:(UISegmentedControl *)segment{

    if(segment.selectedSegmentIndex == 0){
    
        self.collectionSoldOut = notSoldOut;
    }
    else{
    
        self.collectionSoldOut = isSoldOut;
    }
    
    [self RequestDate];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    
    return _noticeModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BDBTableViewCellCoustom *cell = [[NSBundle mainBundle]loadNibNamed:@"BDBTableViewCellCoustom" owner:nil options:nil][0];
    
    BDBMyColletDateBidListModel *model = _noticeModels[indexPath.row];
    
    [cell deployPropertyWithModel: model indexPath:indexPath];
    
    cell.delegata = self;
    
    cell.cancelButton.selected = [_selectedCellIndexPaths[indexPath] boolValue];

    return cell;
    
}

#pragma mark - BDBTableViewCellCoustom Delegate Methods

- (void)buttonselectd:(BOOL)selected indexPath:(NSIndexPath *)aIndexPath{

    _selectedCellIndexPaths[aIndexPath] = [NSNumber numberWithBool:selected];
}

- (void)pushMyCollectionViewController:(NSString *)interestRateOfYear term:(NSString *)aTerm{

    BDBUserProfitCalculatorViewController *profitController = [[BDBUserProfitCalculatorViewController alloc] init];
    
    profitController.interestRateText = interestRateOfYear;
    
    profitController.termText = aTerm;
    
    [self.navigationController pushViewController:profitController animated:YES];
}


//头尾封装方法
-(void)RefreshHeaderAndFoot{
    __weak typeof (self) thisInstance = self;
     _collectTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
         
         [self.selectedCellIndexPaths removeAllObjects];
        [thisInstance RequestDate];
    }];
    _collectTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        [thisInstance RequestNextPageIndex];
    }];

}


@end
