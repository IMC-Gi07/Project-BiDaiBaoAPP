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
#import "BDBWarningTableViewCellTwo.h"

@interface BDBWarningViewController ()<UITableViewDataSource,UITableViewDelegate,BDBWarningTableViewCellDelegate,BDBWarningTableViewCellTwoDelegate>

@property(nonatomic,weak) ZXLLoadDataIndicatePage *

indicatePage;


@property(nonatomic,copy) NSString *userChooseID_1;
@property(nonatomic,copy) NSString *userChooseID_2;


@property (weak, nonatomic) IBOutlet UITableView *warningListTableView;



@property (nonatomic, strong) NSMutableArray *warningAddModels;
@property (nonatomic ,strong) NSMutableArray *warningTimeModels;


@property (weak, nonatomic) IBOutlet UIButton *addWarningButton;

@property (nonatomic,assign) NSUInteger warningRowsNum;





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
        
        self.warningAddModels = [NSMutableArray array];
        self.warningTimeModels = [NSMutableArray array];
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWarningTableView];
    
    [self gainPlatFormID];
    
    
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
    
    [_warningListTableView registerNib:[UINib nibWithNibName:@"BDBWarningTableViewCellTwo" bundle:nil] forCellReuseIdentifier:@"BDBWarningTableViewCellTwo"];

    
    
    __weak typeof(self) thisInstance = self;
    _warningListTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        [thisInstance warningLoadDatas];
    }];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _warningAddModels.count + _warningTimeModels.count;
}

//调用nib的cell，定制色彩块颜色
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
        NSUInteger rowNo = indexPath.row;
    
    if (rowNo < _warningAddModels.count ) {
        BDBWarningTableViewCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:@"BDBWarningTableViewCell" forIndexPath:indexPath];
        
        
        cell_1.delegate = self;
//        NSInteger colorRow = (indexPath.row + 1) % 4;
//        switch (colorRow) {
//            case 1:
//                [cell_1.colorBlock setImage:[UIImage imageNamed:@"cell_bg_blueBlock"]];
//                break;
//            case 2:
//                [cell_1.colorBlock setImage:[UIImage imageNamed:@"cell_bg_purpleBlock"]];
//                break;
//            case 3:
//                [cell_1.colorBlock setImage:[UIImage imageNamed:@"cell_bg_orangeBlock"]];
//                break;
//            case 0:
//                [cell_1.colorBlock setImage:[UIImage imageNamed:@"cell_bg_greenBlock"]];
//                break;
//                
//            default:
//                break;
//        }
        BDBWarningModelOne *warningModelOne = _warningAddModels[indexPath.row];
        
        cell_1.PlateFormNameLable.text = warningModelOne.ID;
        cell_1.ThresHoldLable.text = warningModelOne.ThresHold;
        
        cell_1.delButton.tag = [warningModelOne.ID integerValue];
        
    
        cell= cell_1;
        
        
    }else{
        NSUInteger row = indexPath.row - _warningAddModels.count;
        

        BDBWarningTableViewCellTwo *cell_2 = [tableView dequeueReusableCellWithIdentifier:@"BDBWarningTableViewCellTwo" forIndexPath:indexPath];

        cell_2.delegate_2 = self;
       
        BDBWarningModelTwo *warningModelTwo = _warningTimeModels[row];
        
        cell_2.warningTimeTitleLabel.text = warningModelTwo.Title;
        cell_2.warningTimeTimeLabel.text = warningModelTwo.BidCompletedTime;
        
        cell_2.delButton_2.tag = [warningModelTwo.ID integerValue];
        
        
        cell = cell_2;

        
    }
    
    
        
    
        
        
        return cell;

}



#pragma mark - BDBWarningTableViewCellDelegate Methods

-(void)delete_2ButtonClickedAction:(UIButton *)button{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"删除预警" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
    self.userChooseID_2 = [NSString stringWithFormat:@"%ld",button.tag];
    
}

-(void)deleteButtonClickedAction:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"删除预警" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
    self.userChooseID_1 = [NSString stringWithFormat:@"%ld",button.tag];
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
        
        
        
        if (_userChooseID_1 == nil) {
             NSLog(@"aaaaaaaaa");
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            
            
            parameters[@"UID"] = @"99999999999";
            
            parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
            
            
            parameters[@"Action"] = @"2";
            parameters[@"ID"] = _userChooseID_2;
            
            
            
            [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                
                ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
                
                [self warningLoadDatas];
                [_warningListTableView reloadData];
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ZXLLOG(@"error response: %@",error);
            }];
            
           
        }else if (_userChooseID_2 == nil){
            
            NSLog(@"bbbbbbb");
            AFHTTPRequestOperationManager *manager_2 = [AFHTTPRequestOperationManager manager];
            NSString *requestUrl_2 = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmEarnings"];
            NSMutableDictionary *parameters_2 = [NSMutableDictionary dictionary];
            
            
            
            parameters_2[@"UID"] = @"99999999999";
            
            parameters_2[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
            
            
            parameters_2[@"Action"] = @"2";
            parameters_2[@"ID"] = _userChooseID_1;
            
            
            
            [manager_2 POST:requestUrl_2 parameters:parameters_2 success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                
                ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
                
                [self warningLoadDatas];
                [_warningListTableView reloadData];
                
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ZXLLOG(@"error response: %@",error);
            }];
            
        }
        
       
        
        
        
    
        
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
    
    parameters[@"Type"] = @"1";
    
    
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ZXLLOG(@"success response: %@",responseObject);
//        NSArray *t = responseObject[@"P2PList"];
//        NSDictionary *m = t[13];
//        ZXLLOG(@"success/////////// response: %@",m[@"PlatformName"]);

        
        
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
        
        
        [_warningAddModels addObjectsFromArray:warningResponseModel.AlarmEarningsList];
        [_warningTimeModels addObjectsFromArray:warningResponseModel.AlarmRingList];
        
        
        
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
        
//
//         self.warningModels = warningResponseModel.AlarmRingList;
        
         self.warningAddModels = warningResponseModel.AlarmEarningsList;
        self.warningTimeModels = warningResponseModel.AlarmRingList;
        
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
