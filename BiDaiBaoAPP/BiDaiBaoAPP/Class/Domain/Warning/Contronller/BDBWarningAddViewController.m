//
//  ViewController.m
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import "BDBWarningAddViewController.h"
#import "BDB_TableViewCell_One.h"
#import "BDB_TableViewCell_Two.h"

#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "BDBWarningAddResponseModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"
static const CGFloat MJDuration = 2.0;

/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface BDBWarningAddViewController ()<UITableViewDelegate,UITableViewDataSource,BDB_TableViewCell_TwoDelegate>
@property (weak, nonatomic) IBOutlet UIButton *packUp;

@property (nonatomic, assign)NSInteger row;
@property (nonatomic, assign)NSInteger rowrow;
@property (nonatomic, assign)NSInteger rowNumber;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property(nonatomic,strong)BDBWarningAddResponseModel *warningAddModel;

@property (nonatomic,assign)CGFloat thresHold;

@end

@implementation BDBWarningAddViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.rowNumber = 1;
        self.rowrow = 1;
    }
    return self;
}

- (IBAction)packup:(UIButton *)sender {
    
    
    if (self.rowrow % 2 == 0) {
        self.rowNumber = 1;
       
    } else  {
        self.rowNumber = 2;
    }
    
    
    [_tableView reloadData];
    self.rowrow ++;
}


- (void)loadNewData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.data insertObject:MJRandomData atIndex:0];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    self.tableView.header = header;
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
}

- (void)gainPlatFormID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetP2PList"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
}


- (void)warningAddLoadDatas {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmEarnings"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    
    parameters[@"UID"] = @"99999999999";
    
    parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
    
    
    parameters[@"Action"] = @"0";
    parameters[@"PlatFormID"] = @"0";
    parameters[@"Item"] = @"0";
    parameters[@"Comparison"] = @"0";
    parameters[@"ThresHold"] = [NSString stringWithFormat:@"%f",_thresHold];

    
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        ZXLLOG(@"success response: %@",responseObject);
        BDBWarningAddResponseModel *warningAddResponseModel = [BDBWarningAddResponseModel objectWithKeyValues:responseObject];
        self.warningAddModel = warningAddResponseModel;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    

}
    


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //self.rowNumber = 1;
    return self.rowNumber;
}


//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            self.row = 190;
            break;
        case 1:
            self.row = 128;
            break;
       
    }
    return self.row;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //    id cell;
    NSUInteger rowOn = indexPath.row;
//    根据行数判断return哪个自定义cell
    if (self.rowNumber == 1) {
        if (rowOn == 0) {
        
            BDB_TableViewCell_Two *cell_two =  [[NSBundle mainBundle] loadNibNamed:@"BDB_TableViewCell_Two" owner:nil options:nil][0];
            cell_two.delegate = self;
            cell = cell_two;
        }
    
    }else if (self.rowNumber == 2){
        if (rowOn == 0) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BDB_TableViewCell_One" owner:nil options:nil][0];
        } else if (rowOn == 1){
            
            BDB_TableViewCell_Two *cell_two =  [[NSBundle mainBundle] loadNibNamed:@"BDB_TableViewCell_Two" owner:nil options:nil][0];
            cell_two.delegate = self;
            cell = cell_two;
        }
    
    }

    
    return cell;
}





/**
 *  点击确认按钮，触发请求传输事件
 */
- (IBAction)confirmButtonClick:(UIButton *)sender {
    
    [self warningAddLoadDatas];
    
}
- (IBAction)warningTimeButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"warningAddTowariningTime" sender:self];
}

-(void)updateSliderValue:(CGFloat)sliderValue{
    self.thresHold = sliderValue;
  //  ZXLLOG(@"-----------%f",sliderValue);
}

@end
