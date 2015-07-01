//
//  BDBwarnigTimeViewController.m
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/1.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBwarnigTimeViewController.h"
#import "BDBCustomTableViewCell.h"
#import "BDBCustomTableViewCellOne.h"
#import "BDBCustomTableViewCellTwo.h"
#import "BDBCustomTableViewCellThree.h"
#import "BDBCustomTableViewCellFive.h"
#import "BDBWarningTimeResponseModel.h"



@interface BDBwarnigTimeViewController()<UITableViewDelegate,UITableViewDataSource,BDBCustomTableViewCellDelegate,BDBCustomTableViewCellTwoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *warningTimeTableView;

@property (nonatomic,assign) BOOL isFloded;

@property (nonatomic,strong) NSMutableArray *cellButtonArray;

@property (nonatomic,assign) NSIndexPath *indexPath_3;

@property (nonatomic,assign) NSIndexPath *indexPath_4;

@property (nonatomic,assign) BOOL isYearPicker;


@end



@implementation BDBwarnigTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.warningTimeTableView.dataSource = self;
    self.warningTimeTableView.delegate = self;
    self.warningTimeTableView.bounces = NO;
    
    self.isFloded = YES;
    self.isYearPicker = YES;
    
    
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSUInteger rowNo1 = indexPath.section;
    
    if(rowNo1 == 0){
        return 52.0f;
    }else if (rowNo1 == 1){
        return 52.0f;
    }else if(rowNo1 == 2){
        return 135.0f;
    }else if(rowNo1 == 3){
        return 85.0f;
    }else if(rowNo1 == 4){
        if (_isFloded) {
            return 0.0f;
        }else {
            return 52.0f;
        }
    }
    return rowNo1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID1 = @"cellId1";
    static NSString *cellID2 = @"cellId2";
    static NSString *cellID3 = @"cellId3";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId0"];
    
    NSUInteger rowNo = indexPath.section;
    if(rowNo == 0){
        BDBCustomTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCellOne" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (BDBCustomTableViewCellOne *)currentObject;
                    // break;
                }
            }
        }
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
    }else if (rowNo == 3){
        BDBCustomTableViewCell *cell = [[BDBCustomTableViewCell alloc] init];
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCell" owner:nil options:nil];
        cell = topLevelObjects[0];
        
        self.indexPath_3 = indexPath;
        cell.delegate = self;
        return cell;
    }else if (rowNo == 4){
        BDBCustomTableViewCellFive *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBCustomTableViewCellFive" owner:nil options:nil][0];
        
        UIButton *button_1 = (UIButton *)[cell viewWithTag:1003];
        UIButton *button_2 = (UIButton *)[cell viewWithTag:1002];
        UIButton *button_3 = (UIButton *)[cell viewWithTag:1001];
        self.cellButtonArray = [NSMutableArray arrayWithObjects:button_1,button_2,button_3, nil];
        if (_isFloded) {
            for (UIButton *button in _cellButtonArray) {
                [button setTitle:@"" forState: UIControlStateNormal];
                button.alpha = 0;
            }
        }
        self.indexPath_4 = indexPath;
        return cell;
    }
    
    
    
    return cell;
    
}

#pragma mark - BDBCustomTableViewCellDelegate Methods
-(void)shrinkButtonClickedForChangingHeightOfRow:(UIButton *)sender {
    
    
    self.isFloded = !_isFloded;
    
    [_warningTimeTableView reloadData];
    
    
}


-(void)changeYear_Month_Day_Picker:(UIButton *)sender {
    
    self.isYearPicker = YES;
    [self.warningTimeTableView reloadData];
    
}
-(void)changeHour_Minutes_Picker:(UIButton *)sender {
    
    self.isYearPicker = NO;
    [self.warningTimeTableView reloadData];
    
}


- (IBAction)warningAddButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"warningTimeTowarningAdd" sender:self];
    
}


- (void)warningTimeloadDatas{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmRing"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ZXLLOG(@"success response: %@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
    
    
    
    
    
}



@end
