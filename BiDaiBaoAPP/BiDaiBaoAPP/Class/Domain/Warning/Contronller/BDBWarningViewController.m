//
//  ViewController.m
//  BDB_Draft
//
//  Created by Tomoxox on 15/6/8.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBWarningViewController.h"
#import "BDBWarningTableViewCell.h"
#import "BDBWarningModelOne.h"
#import "BDBWarningModelTwo.h"
#import "BDBWarningResponseModel.h"
#import "ZXLLoadDataIndicatePage.h"

@interface BDBWarningViewController ()<UITableViewDataSource,UITableViewDelegate,BDBWarningTableViewCellDelegate>

@property(nonatomic,weak) ZXLLoadDataIndicatePage *

indicatePage;


@property(nonatomic,copy) NSString *userChooseID;


@property (weak, nonatomic) IBOutlet UITableView *warningListTableView;



@property (nonatomic, strong) NSMutableArray *warningModels;

@property (weak, nonatomic) IBOutlet UIButton *addWarningButton;

@property (nonatomic,assign) NSUInteger warningRowsNum;


///**
// *  收益预警记录数目
// */
//@property (nonatomic,assign) NSUInteger AlarmEarningsNum;
///**
// *  自定义闹铃信息数目
// */
//@property (nonatomic,assign) NSUInteger AlarmRingNum;



/**
 公告页数
 */
@property(nonatomic,assign) NSUInteger pageIndex;

/**
 每页显示数量
 */
@property(nonatomic,assign) NSUInteger pageSize;




@end

@implementation BDBWarningViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        
        self.pageSize = 5;
        
        self.warningModels = [NSMutableArray array];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWarningTableView];
    
    self.warningListTableView.dataSource = self;
    self.warningListTableView.delegate = self;
    
    self.warningListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.warningListTableView.rowHeight = 100.0f;
    self.warningListTableView.allowsSelection = NO;
    self.warningListTableView.showsVerticalScrollIndicator = NO;
    
//    self.warningRowsNum = 2;
    
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    
    
    [self warningLoadDatas];
    
}
- (void)initWarningTableView{
    _warningListTableView.estimatedRowHeight = 50;
    
    [_warningListTableView registerNib:[UINib nibWithNibName:@"BDBWarningTableViewCell" bundle:nil] forCellReuseIdentifier:@"BDBWarningTableViewCell"];
    
    
    __weak typeof(self) thisInstance = self;
    _warningListTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        [thisInstance warningLoadDatas];
    }];
    
    _warningListTableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        [thisInstance warningLoadMoreDatas];
    }];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _warningModels.count;
}

//调用nib的cell，定制色彩块颜色
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    BDBWarningTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBWarningTableViewCell" owner:nil options:nil][0];
    BDBWarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BDBWarningTableViewCell" forIndexPath:indexPath];
    
    
    cell.delegate = self;
    NSInteger colorRow = (indexPath.row + 1) % 4;
    switch (colorRow) {
        case 1:
            [cell.colorBlock setImage:[UIImage imageNamed:@"cell_bg_blueBlock"]];
            break;
        case 2:
            [cell.colorBlock setImage:[UIImage imageNamed:@"cell_bg_purpleBlock"]];
            break;
        case 3:
            [cell.colorBlock setImage:[UIImage imageNamed:@"cell_bg_orangeBlock"]];
            break;
        case 0:
            [cell.colorBlock setImage:[UIImage imageNamed:@"cell_bg_greenBlock"]];
            break;
            
        default:
            break;
    }
    
    BDBWarningModelOne *warningModelOne = _warningModels[indexPath.row];
//    BDBWarningModelTwo *warningModelTwo = _warningModels[indexPath.row];
    
    cell.PlateFormNameLable.text = warningModelOne.ID;
    cell.ThresHoldLable.text = warningModelOne.ThresHold;
    
    cell.delButton.tag = [warningModelOne.ID integerValue];

    
    return cell;
}



#pragma mark - BDBWarningTableViewCellDelegate Methods

-(void)deleteButtonClickedAction:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"删除预警" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
    self.userChooseID = [NSString stringWithFormat:@"%ld",button.tag];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"点击了取消");
    }
    if (buttonIndex == 1) {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        NSLog(@"点击了确认");
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmEarnings"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        

        
        parameters[@"UID"] = @"99999999999";
        
        parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
        
        
        parameters[@"Action"] = @"2";
        parameters[@"ID"] = _userChooseID;
 
        
        
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
            
            [self warningLoadDatas];
            [_warningListTableView reloadData];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"error response: %@",error);
        }];
       
        
    }
    [_warningListTableView reloadData];
}
- (IBAction)warningAddButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"towarningAddViewControllerSegue" sender:self];
    
}




- (void)gainPlatFormID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetP2PList"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    
    parameters[@"Type"] = @"0";
    
    
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //ZXLLOG(@"success response: %@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    
    
    
}


-(void)warningLoadMoreDatas{
    self.pageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetMyAlarmInf"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    
    parameters[@"UID"] = @"99999999999";
    
    parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BDBWarningResponseModel *warningResponseModel = [BDBWarningResponseModel objectWithKeyValues:responseObject];
        
        
        [_warningModels addObjectsFromArray:warningResponseModel.AlarmEarningsList];
        
        
        
        [_warningListTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    
    
}

- (void)warningLoadDatas{
    self.pageIndex = 1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetMyAlarmInf"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    
    parameters[@"UID"] = @"99999999999";
    
    parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
    
    
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
   ZXLLOG(@"success response: %@",responseObject);
        
        BDBWarningResponseModel *warningResponseModel = [BDBWarningResponseModel objectWithKeyValues:responseObject];
        
        
        
        self.warningModels = warningResponseModel.AlarmEarningsList;

        
        //加载页面的显示
        if (_indicatePage) {
            [_indicatePage hide];
            self.navigationController.navigationBarHidden = NO;
        }else {
            [_warningListTableView.header endRefreshing];
        }
        
        
        [_warningListTableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
}


@end
