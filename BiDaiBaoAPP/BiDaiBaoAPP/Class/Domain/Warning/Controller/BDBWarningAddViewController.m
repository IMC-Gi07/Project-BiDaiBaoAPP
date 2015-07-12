//
//  ViewController.m
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//
#import "ZXLLoadDataIndicatePage.h"
#import "BDBWarningAddViewController.h"
#import "BDB_TableViewCell_Two.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "BDBWarningAddResponseModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"

//<<-----warningTime------
#import "BDBCustomTableViewCellOne.h"
#import "BDBCustomTableViewCellTwo.h"
#import "BDBCustomTableViewCellThree.h"
#import "BDBWarningTimeResponseModel.h"
#import "BDBwarningAddTableViewCellBtn.h"
#import "BDBWarningViewController.h"
#import "BDBwarningMoreBtnTableViewCell.h"
//-----warningTime------>>



static const CGFloat MJDuration = 2.0;

/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface BDBWarningAddViewController ()<UITableViewDelegate,UITableViewDataSource,BDB_TableViewCell_TwoDelegate,BDBCustomTableViewCellTwoDelegate,BDBCustomTableViewCellOneDelegate,BDBCustomTableViewCellThreeDelegate,BDBwarningMoreBtnTableViewCellDelegate>
@property(nonatomic,weak) ZXLLoadDataIndicatePage *

indicatePage;

@property (weak, nonatomic) IBOutlet UIButton *warningTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *warningAddButton;

@property (weak, nonatomic) IBOutlet UIButton *theSureButton;



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

@property (nonatomic,copy)NSString *gainDatePicker;
@property (nonatomic,copy)NSString *gainDatePickerHour;
@property (nonatomic,copy)NSString *CSgainDatePicker;
@property (nonatomic,copy)NSString *CSgainDatePickerHour;
@property (nonatomic,copy)NSString *CSgainDatePickerYearAndHour;
@property(nonatomic,assign)BOOL isNothing;


//<<-----warningTime------

@property (nonatomic,assign) BOOL isFloded;

@property (nonatomic,strong) NSMutableArray *cellButtonArray;

@property (nonatomic,assign) BOOL isYearPicker;

//-----warningTime------>>


- (void)hideDataIndicatePage;

@end

@implementation BDBWarningAddViewController



- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        self.rowNumber = 2;
        self.rowrow = 1;
        
        self.IsSegmentedAlarm = NO;
        self.isNothing = NO;
		
		self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.WarningTableView.dataSource = self;
    self.WarningTableView.delegate = self;
    self.WarningTableView.bounces = NO;
    
    
    self.isFloded = YES;
    self.isYearPicker = YES;
    
    self.indicatePage = [ZXLLoadDataIndicatePage showInView:self.view];
	
	[self performSelector:@selector(hideDataIndicatePage) withObject:nil afterDelay:2.0f];
}

//<<---------Model-------------

- (void)warningAddLoadDatas {
    if (!_thresHold == 0 && !_PlatFormIDnum == 0) {
        
        self.isNothing = NO;
        
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
            BDBWarningAddResponseModel *warningAddResponseModel = [BDBWarningAddResponseModel objectWithKeyValues:responseObject];
            self.warningAddModel = warningAddResponseModel;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"error response: %@",error);
        }];
    }else if(_thresHold == 0 && !_PlatFormIDnum == 0){
        _thresHold = 13;
        self.isNothing = NO;
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
    }else if (!_thresHold == 0 && _PlatFormIDnum == 0){
        self.isNothing = YES;
    }else if (_thresHold == 0 && _PlatFormIDnum == 0){
        self.isNothing = YES;
    }

}

- (void)warningTimeLoadDatas{
    
    if (_titleTextFieldOutput == nil) {
        
        self.isNothing = YES;
    }else if(_CSgainDatePicker == nil && _CSgainDatePickerHour ==nil){
        _CSgainDatePicker = @"2015-06-08";
        _CSgainDatePickerHour = @"22:56:00";
        self.isNothing = NO;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
        parameters[@"Device"] = @"0";
        
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        parameters[@"UID"] = [userDefaults objectForKey:@"UID"];
        parameters[@"PSW"] = [userDefaults objectForKey:@"PSW"];
        
        
        parameters[@"Action"] = @"0";
        //    parameters[@"BidCompletedTime"] = @"2015-09-01 12:01:59";
        _CSgainDatePickerYearAndHour = [NSString stringWithFormat:@"%@ %@",_CSgainDatePicker,_CSgainDatePickerHour];
        NSLog(@"1234567890%@",_CSgainDatePickerYearAndHour);
        
        parameters[@"BidCompletedTime"] = _CSgainDatePickerYearAndHour;
        
        
        parameters[@"Minutes"] = @"0";
        
        parameters[@"Title"] = _titleTextFieldOutput;
        
        parameters[@"Active"] = @"0";
        
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
            BDBWarningTimeResponseModel *warningTimeResponseModel = [BDBWarningTimeResponseModel objectWithKeyValues:responseObject];
            self.warningTimeModel = warningTimeResponseModel;
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"error response: %@",error);
        }];
    }else if (_CSgainDatePicker == nil){
        _CSgainDatePicker = @"2015-06-08";
        self.isNothing = NO;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
        parameters[@"Device"] = @"0";
        
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		parameters[@"UID"] = [userDefaults objectForKey:@"UID"];
		parameters[@"PSW"] = [userDefaults objectForKey:@"PSW"];
        
        
        parameters[@"Action"] = @"0";
        //    parameters[@"BidCompletedTime"] = @"2015-09-01 12:01:59";
        _CSgainDatePickerYearAndHour = [NSString stringWithFormat:@"%@ %@",_CSgainDatePicker,_CSgainDatePickerHour];
        NSLog(@"1234567890%@",_CSgainDatePickerYearAndHour);
        
        parameters[@"BidCompletedTime"] = _CSgainDatePickerYearAndHour;
        
        
        parameters[@"Minutes"] = @"0";
        
        parameters[@"Title"] = _titleTextFieldOutput;
        
        parameters[@"Active"] = @"0";
        
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
            BDBWarningTimeResponseModel *warningTimeResponseModel = [BDBWarningTimeResponseModel objectWithKeyValues:responseObject];
            self.warningTimeModel = warningTimeResponseModel;
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"error response: %@",error);
        }];
    }else if (_CSgainDatePickerHour == nil){
        _CSgainDatePickerHour = @"22:56:00";
        self.isNothing = NO;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
        parameters[@"Device"] = @"0";
        
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		parameters[@"UID"] = [userDefaults objectForKey:@"UID"];
		parameters[@"PSW"] = [userDefaults objectForKey:@"PSW"];
        
        
        parameters[@"Action"] = @"0";
        //    parameters[@"BidCompletedTime"] = @"2015-09-01 12:01:59";
        _CSgainDatePickerYearAndHour = [NSString stringWithFormat:@"%@ %@",_CSgainDatePicker,_CSgainDatePickerHour];
        NSLog(@"1234567890%@",_CSgainDatePickerYearAndHour);
        
        parameters[@"BidCompletedTime"] = _CSgainDatePickerYearAndHour;
        
        
        parameters[@"Minutes"] = @"0";
        
        parameters[@"Title"] = _titleTextFieldOutput;
        
        parameters[@"Active"] = @"0";
        
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
            BDBWarningTimeResponseModel *warningTimeResponseModel = [BDBWarningTimeResponseModel objectWithKeyValues:responseObject];
            self.warningTimeModel = warningTimeResponseModel;
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ZXLLOG(@"error response: %@",error);
        }];
    }
    
    
    
    
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
            self.row = 150;
            break;
        case 1:
            self.row = 178;
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
            BDBwarningMoreBtnTableViewCell *cell_One = [[NSBundle mainBundle] loadNibNamed:@"BDBwarningMoreBtnTableViewCell" owner:nil options:nil][0];
            cell_One.btnDelegate = self;
            cell = cell_One;

            
        } else if (rowOn == 1){
            BDB_TableViewCell_Two *cell_two =  [[NSBundle mainBundle] loadNibNamed:@"BDB_TableViewCell_Two" owner:nil options:nil][0];
            cell_two.delegate = self;
            cell = cell_two;
        }
    }
    }else if (_IsSegmentedAlarm == YES){
        static NSString *cellID2 = @"cellId2";
        static NSString *cellID3 = @"cellId3";
        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId0"];
        
        NSUInteger rowNo = indexPath.section;
        if(rowNo == 0){

            BDBCustomTableViewCellOne *cell_2 = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCellOne" owner:nil options:nil][0];
            
            cell_2.delegate = self;
        
            cell = cell_2;
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
            if (_gainDatePicker == nil) {
                [cell.yearBtnText setTitle:@"2015年06月08日" forState:UIControlStateNormal];
              
            }else{
                [cell.yearBtnText setTitle:_gainDatePicker forState:UIControlStateNormal];
               
            }
            
            if (_gainDatePickerHour == nil) {
                [cell.minutesBtnText setTitle:@"22:56" forState:UIControlStateNormal];
            }else{
                 [cell.minutesBtnText setTitle:_gainDatePickerHour forState:UIControlStateNormal];
            }
            
          
            return cell;
        }else if (rowNo == 2){
            BDBCustomTableViewCellThree *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCellThree" owner:nil options:nil];
            cell = topLevelObjects[0];
            cell.delegate3 = self;
            
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
    
    
    [_WarningTableView reloadData];
    
    if (self.IsSegmentedAlarm == NO) {
        [self warningAddLoadDatas];
    }else if (self.IsSegmentedAlarm == YES){
        [self warningTimeLoadDatas];
    }

    if (_isNothing == YES) {
        NSLog(@"点击button不能跳转");
    }else{
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
 

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

-(void)gainMoreBtnTagAction:(NSInteger)btnTag{
    self.PlatFormIDnum = btnTag;
}


//-(void)gainBtnTagAction:(NSInteger)btnTag{
//    
//    self.PlatFormIDnum = btnTag;
//}

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


//-----warningTime------>>


-(void)updateSliderValue:(NSInteger)sliderValue{
    self.thresHold = sliderValue;
}

-(void)transferTitleText:(NSString *)titleText{
    self.titleTextFieldOutput = titleText;
    
//    NSLog(@"%@",titleText);
    
}

- (void)datePickerText:(NSString *)datePickerText andDatePickerHour:(NSString *)datePickerHourText CSdatePickerText:(NSString *)CSdatePickerText andCSDatePickerHour:(NSString *)CSdatePickerHourText{
  
    
    if (_isYearPicker) {
        self.gainDatePicker = datePickerText;
        self.CSgainDatePicker = CSdatePickerText;
    }else{
        self.gainDatePickerHour = datePickerHourText;
        self.CSgainDatePickerHour = CSdatePickerHourText;
    }
    
    
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [self.WarningTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - Private Methods
- (void)hideDataIndicatePage {
	[_indicatePage hide];
}


@end
