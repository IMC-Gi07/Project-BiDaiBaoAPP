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
#import "BDBWarningTableViewCellTwo.h"
#import "BDBWarningAddViewController.h"
#import "BDBUserRegisterViewController.h"


@interface BDBWarningViewController ()<UITableViewDataSource,UITableViewDelegate,BDBWarningTableViewCellDelegate,BDBWarningTableViewCellTwoDelegate>

@property(nonatomic,weak) ZXLLoadDataIndicatePage *indicatePage;


@property(nonatomic,copy) NSString *userChooseID_1;
@property(nonatomic,copy) NSString *userChooseID_2;


@property (weak, nonatomic) IBOutlet UITableView *warningListTableView;



@property (nonatomic, strong) NSMutableArray *warningAddModels;
@property (nonatomic ,strong) NSMutableArray *warningTimeModels;


@property (weak, nonatomic) IBOutlet UIButton *addWarningButton;

/**
 *  平台数据
 */
@property(nonatomic,strong) NSMutableArray *platformModels;


@property(nonatomic,weak)UIButton *alearDel;


/**
 *	刷新表格界面
 */
- (void)refreshWarningListTableViewDatas;



@end

@implementation BDBWarningViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.warningAddModels = [NSMutableArray array];
        self.warningTimeModels = [NSMutableArray array];
        self.platformModels = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWarningTableView];
	
	self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
}
- (void)initWarningTableView{
    _warningListTableView.estimatedRowHeight = 50;
	
	_warningListTableView.dataSource = self;
	_warningListTableView.delegate = self;
	
	_warningListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_warningListTableView.rowHeight = 100.0f;
	_warningListTableView.allowsSelection = NO;
	_warningListTableView.showsVerticalScrollIndicator = NO;
    
    [_warningListTableView registerNib:[UINib nibWithNibName:@"BDBWarningTableViewCell" bundle:nil] forCellReuseIdentifier:@"BDBWarningTableViewCell"];
    
    [_warningListTableView registerNib:[UINib nibWithNibName:@"BDBWarningTableViewCellTwo" bundle:nil] forCellReuseIdentifier:@"BDBWarningTableViewCellTwo"];

    __weak typeof(self) thisInstance = self;
    _warningListTableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        [thisInstance refreshWarningListTableViewDatas];
    }];
	
	[self refreshWarningListTableViewDatas];
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

        BDBWarningModelOne *warningModelOne = _warningAddModels[indexPath.row];
		cell_1.PlateFormNameLable.text = warningModelOne.PlatformName;
        cell_1.ThresHoldLable.text = warningModelOne.ThresHold;
        cell_1.delButton.tag = [warningModelOne.ID integerValue];
        cell = cell_1;
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
    self.alearDel = button;
    
}

-(void)deleteButtonClickedAction:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"删除预警" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
    self.userChooseID_1 = [NSString stringWithFormat:@"%ld",button.tag];
    
    self.alearDel = button;
}


#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"点击了取消");
        [self.alearDel setImage:[UIImage imageNamed:@"cell_btn_delete"] forState:UIControlStateNormal];
    }
    if (buttonIndex == 1) {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
		
        [self.alearDel setImage:[UIImage imageNamed:@"cell_btn_delete"] forState:UIControlStateNormal];
        self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
        
        if (_userChooseID_1 == nil) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
			NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
            
			NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
			parameters[@"Action"] = @"2";
			parameters[@"ID"] = _userChooseID_2;    
				
			NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            parameters[@"UID"] = [userDefaults objectForKey:@"UID"];
            parameters[@"PSW"] = [userDefaults objectForKey:@"PSW"];
            
            [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                [self refreshWarningListTableViewDatas];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ZXLLOG(@"error response: %@",error);
            }];
            
           
        }else if (_userChooseID_2 == nil){
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
			NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmEarnings"];
			
            NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
			requestParameters[@"Action"] = @"2";
			requestParameters[@"ID"] = _userChooseID_1;
            
			NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            requestParameters[@"UID"] = [userDefaults objectForKey:@"UID"];
            requestParameters[@"PSW"] = [userDefaults objectForKey:@"PSW"];
            
            [manager POST:requestURL parameters:requestParameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                [self refreshWarningListTableViewDatas];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ZXLLOG(@"error response: %@",error);
            }];
            
        }
	}
}
- (IBAction)warningAddButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"towarningAddViewControllerSegue" sender:self];
}

#pragma mark - Private Methods
- (void)refreshWarningListTableViewDatas {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
	NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetMyAlarmInf"];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
	parameters[@"Device"] = @"0";
	parameters[@"UserType"] = @"0";

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *UID = [userDefaults objectForKey:@"UID"];
	NSString *PSW = [userDefaults objectForKey:@"PSW"];
	if (!UID || [@"" isEqualToString:UID] || !PSW || [@"" isEqualToString:PSW]) {
		if(_indicatePage){
			[_indicatePage hide];	
		}
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未登录." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertView show];
		
		return;
	}

	
	[manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
	
		BDBWarningResponseModel *warningResponseModel = [BDBWarningResponseModel objectWithKeyValues:responseObject];
		self.warningAddModels = warningResponseModel.AlarmEarningsList;
		
		//根据model.platformID,查询数据库的平台名
		FMDatabase *database = [FMDatabase databaseWithPath:[CACHE_DIRECTORY stringByAppendingPathComponent:BDBGlobal_CacheDatabaseName]];
		if ([database open]) {
			[_warningAddModels enumerateObjectsUsingBlock:^(BDBWarningModelOne *warningModelOne, NSUInteger idx, BOOL *stop) {
				//查询表中的数据
				NSString *sql = @"SELECT name FROM t_platform where pid=:pid";
				
				NSMutableDictionary *sqlParameters = [NSMutableDictionary dictionary];
				sqlParameters[@"pid"] = warningModelOne.PlatFormID;
				
				FMResultSet *resultSet = [database executeQuery:sql withParameterDictionary:sqlParameters];
				while([resultSet next]){
					warningModelOne.PlatformName = [resultSet stringForColumn:@"name"];	
				}
				[resultSet close];
			}];
			
			[database close];
		}

		self.warningTimeModels = warningResponseModel.AlarmRingList;
		
		//加载页面的显示
		if (_indicatePage) {
			[_indicatePage hide];
		}
		
		if (_warningListTableView.header.isRefreshing) {
			[_warningListTableView.header endRefreshing];
		}
		
		[_warningListTableView reloadData];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		ZXLLOG(@"error response: %@",error);
		
		//加载页面的显示
		if (_indicatePage) {
			[_indicatePage hide];
		}
		
		if (_warningListTableView.header.isRefreshing) {
			[_warningListTableView.header endRefreshing];
		}
	}];

}




@end
