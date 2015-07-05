//
//  ViewController.m
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//
#import "ZXLLoadDataIndicatePage.h"
#import "BDBWarningAddViewController.h"
#import "BDB_TableViewCell_One.h"
#import "BDB_TableViewCell_Two.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "BDBWarningAddResponseModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "BDB_TableViewCell_Title.h"

//<<-----warningTime------
#import "BDBCustomTableViewCellOne.h"
#import "BDBCustomTableViewCellTwo.h"
#import "BDBCustomTableViewCellThree.h"
#import "BDBWarningTimeResponseModel.h"
//-----warningTime------>>



static const CGFloat MJDuration = 2.0;

/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface BDBWarningAddViewController ()<UITableViewDelegate,UITableViewDataSource,BDB_TableViewCell_TwoDelegate,BDBCustomTableViewCellTwoDelegate,BDBCustomTableViewCellOneDelegate>
@property(nonatomic,weak) ZXLLoadDataIndicatePage *

indicatePage;

@property (weak, nonatomic) IBOutlet UIButton *packUp;
@property (weak, nonatomic) IBOutlet UIButton *warningTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *warningAddButton;




@property (nonatomic, assign)NSInteger row;
@property (nonatomic, assign)NSInteger rowrow;
@property (nonatomic, assign)NSInteger rowNumber;
@property (strong, nonatomic) IBOutlet UITableView *WarningTableView;
@property (strong, nonatomic) NSMutableArray *data;
@property(nonatomic,strong)BDBWarningAddResponseModel *warningAddModel;
@property(nonatomic,strong)BDBWarningTimeResponseModel *warningTimeModel;

@property (nonatomic,assign)NSInteger thresHold;
@property (nonatomic,assign)NSInteger PlatFormIDnum;
@property (nonatomic,copy)NSString *titleTextFieldOutput;


@property (nonatomic,assign)BOOL IsSegmentedAlarm;


//<<-----warningTime------

@property (nonatomic,assign) BOOL isFloded;

@property (nonatomic,strong) NSMutableArray *cellButtonArray;

@property (nonatomic,assign) BOOL isYearPicker;


//-----warningTime------>>




@end

@implementation BDBWarningAddViewController



- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        self.hidesBottomBarWhenPushed = YES;
        self.rowNumber = 2;
        self.rowrow = 1;
        
        self.IsSegmentedAlarm = NO;
    }
    return self;
}

- (IBAction)packup:(UIButton *)sender {
    
    
    if (self.rowrow % 2 == 0) {
        self.rowNumber = 1;
       
    } else  {
        self.rowNumber = 2;
    }
    
    
    [_WarningTableView reloadData];
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
        [self.WarningTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.WarningTableView.header endRefreshing];
    });
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    self.WarningTableView.header = header;
    
    
    self.WarningTableView.dataSource = self;
    self.WarningTableView.delegate = self;
    self.WarningTableView.bounces = NO;
    
    
    self.isFloded = YES;
    self.isYearPicker = YES;

    
}

- (void)gainPlatFormID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetP2PList"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    parameters[@"Type"] = @"1";
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        ZXLLOG(@"success response: %@",responseObject);
        NSArray *t = responseObject[@"P2PList"];
        NSDictionary *m = t[2];
        ZXLLOG(@"success/////////// response: %@",m[@"PlatformName"]);
   
      
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
}





//<<---------Model-------------

- (void)warningAddLoadDatas {
    if (!_thresHold == 0) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmEarnings"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
        parameters[@"Device"] = @"0";
        
        parameters[@"UID"] = @"99999999999";
        
        parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
        
        
        parameters[@"Action"] = @"0";
        parameters[@"PlatFormID"] = [NSString stringWithFormat:@"%ld",_PlatFormIDnum];
        parameters[@"Item"] = @"0";
        parameters[@"Comparison"] = @"0";
        parameters[@"ThresHold"] = [NSString stringWithFormat:@"%ld",(long)_thresHold];
        parameters[@"Active"] = @"0";
        
        
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
            BDBWarningAddResponseModel *warningAddResponseModel = [BDBWarningAddResponseModel objectWithKeyValues:responseObject];
            self.warningAddModel = warningAddResponseModel;
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"error response: %@",error);
        }];
    }else {
        NSLog(@"请移动");
    }

}

- (void)warningTimeLoadDatas{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    
    parameters[@"UID"] = @"99999999999";
    parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
    
    
    parameters[@"Action"] = @"0";
    parameters[@"BidCompletedTime"] = @"2015-09-01 12:01:59";
    parameters[@"Minutes"] = @"0";
    if (_titleTextFieldOutput) {
        parameters[@"Title"] = _titleTextFieldOutput;
    }
    parameters[@"Active"] = @"0";
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
        BDBWarningTimeResponseModel *warningTimeResponseModel = [BDBWarningTimeResponseModel objectWithKeyValues:responseObject];
        self.warningTimeModel = warningTimeResponseModel;
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    
    
}




//---------Model------------->>
    


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUInteger warningSections;
    if (_IsSegmentedAlarm == NO) {
        warningSections = 1;
    }else if (_IsSegmentedAlarm == YES){
        warningSections = 3;
    }
    
    return warningSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //self.rowNumber = 1;
    
    NSUInteger warningRow;
    
    if (_IsSegmentedAlarm == NO) {
     
    warningRow = self.rowNumber;
        
    }else if (_IsSegmentedAlarm == YES){
        warningRow = 1;
    }
    
    return warningRow;
    
}


//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger rowNo2;
    if (_IsSegmentedAlarm == NO) {
     
    switch (indexPath.row) {
        case 0:
            self.row = 130;
            break;
        case 1:
            self.row = 128;
            break;
       
            break;

    }
    return self.row;
    }else if (_IsSegmentedAlarm == YES){
        NSUInteger rowNo1 = indexPath.section;
        
        if(rowNo1 == 0){
            return 52.0f;
        }else if (rowNo1 == 1){
            return 52.0f;
        }else if(rowNo1 == 2){
            return 135.0f;
        }
        return rowNo1;
    }
    return rowNo2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (_IsSegmentedAlarm == NO) {
    
    
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
    }else if (_IsSegmentedAlarm == YES){
        static NSString *cellID1 = @"cellId1";
        static NSString *cellID2 = @"cellId2";
        static NSString *cellID3 = @"cellId3";
        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId0"];
        
        NSUInteger rowNo = indexPath.section;
        if(rowNo == 0){
            BDBCustomTableViewCellOne *cell_2 = [tableView dequeueReusableCellWithIdentifier:cellID1];
            if (cell_2 == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCellOne" owner:nil options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (BDBCustomTableViewCellOne *)currentObject;
                        // break;
                    }
                }
            }
            cell_2.delegate = self;
         //   self.titleTextFieldOutput = cell_2.titleTextField.text;
            return cell;
        }else if (rowNo == 1){
            BDBCustomTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCellTwo" owner:nil options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (BDBCustomTableViewCellTwo *)currentObject;
                        // break;
                    }
                }
            }
            cell.delegate1 = self;
            return cell;
        }else if (rowNo == 2){
            BDBCustomTableViewCellThree *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCellThree" owner:nil options:nil];
            cell = topLevelObjects[0];
            if (_isYearPicker) {
                cell.datePicker.datePickerMode = UIDatePickerModeDate;
                
            }else {
                cell.datePicker.datePickerMode = UIDatePickerModeTime;
            }
            
            return cell;
        }
        
        
        
    }
    
    return cell;
}





/**
 *  点击确认按钮，触发请求传输事件
 */
- (IBAction)confirmButtonClick:(UIButton *)sender {
    
    
    if (self.IsSegmentedAlarm == NO) {
        [self warningAddLoadDatas];
    }else if (self.IsSegmentedAlarm == YES){
        
        [self warningTimeLoadDatas];
        [self warningTimeLoadDatas];
    }
    
//    [self gainPlatFormID];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
  
    
}





- (IBAction)warningTimeButton:(UIButton *)sender {
    
    
    self.IsSegmentedAlarm = YES;
    
   
    
    [sender setBackgroundImage:[UIImage imageNamed:@"waring_uisegmentedcontrol_right"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.warningAddButton setBackgroundImage:[UIImage imageNamed:@"waring_uisegmentedcontrol_left"] forState:UIControlStateNormal];
    [self.warningAddButton setTitleColor:UIColorWithRGB(57, 127, 227) forState:UIControlStateNormal];
    
    [_WarningTableView reloadData];
    
}

- (IBAction)warningAddButton:(UIButton *)sender {
    
    self.IsSegmentedAlarm = NO;
    
   
    [sender setBackgroundImage:[UIImage imageNamed:@"waringAdd_uisegmentedcontrol_left"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    [self.warningTimeButton setBackgroundImage:[UIImage imageNamed:@"waringAdd_uisegmentedcontrol_right"] forState:UIControlStateNormal];
    [self.warningTimeButton setTitleColor:UIColorWithRGB(57, 127, 227) forState:UIControlStateNormal];
    
    
    [_WarningTableView reloadData];
    
}

//<<-----warningTime------

-(void)shrinkButtonClickedForChangingHeightOfRow:(UIButton *)sender {
    
    
    self.isFloded = !_isFloded;
    
    [_WarningTableView reloadData];
    
    
}


-(void)changeYear_Month_Day_Picker:(UIButton *)sender {
    
    self.isYearPicker = YES;
    [self.WarningTableView reloadData];
    
}
-(void)changeHour_Minutes_Picker:(UIButton *)sender {
    
    self.isYearPicker = NO;
    [self.WarningTableView reloadData];
    
}

//- (void)warningTimeloadDatas{
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    
//    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
//    parameters[@"Device"] = @"0";
//    
//    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        ZXLLOG(@"success response: %@",responseObject);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        ZXLLOG(@"error response: %@",error);
//    }];
//    
//}



//-----warningTime------>>

- (void)PlatFormIDButtonClickedAction:(NSInteger)buttonValue{
    self.PlatFormIDnum = buttonValue;
}

-(void)updateSliderValue:(NSInteger)sliderValue{
    self.thresHold = sliderValue;
   // ZXLLOG(@"-----------%ld",(long)sliderValue);
}

-(void)transferTitleText:(UITextField *)titleText{
    self.titleTextFieldOutput = titleText.text;
    
}

@end
