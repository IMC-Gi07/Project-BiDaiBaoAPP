//
//  ViewController.m
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import "BDBWarningTimeViewController.h"
#import "BDBCustomTableViewCellOne.h"
#import "BDBCustomTableViewCellTwo.h"
#import "BDBCustomTableViewCellThree.h"


@interface BDBWarningTimeViewController ()<UITableViewDelegate,UITableViewDataSource,BDBCustomTableViewCellTwoDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) BOOL isFloded;

@property (nonatomic,strong) NSMutableArray *cellButtonArray;

//@property (nonatomic,assign) NSIndexPath *indexPath_3;
//
//@property (nonatomic,assign) NSIndexPath *indexPath_4;

@property (nonatomic,assign) BOOL isYearPicker;

@end



@implementation BDBWarningTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    
    self.isFloded = YES;
    self.isYearPicker = YES;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
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
    }
    
    
    
    return cell;
    
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

#pragma mark - BDBCustomTableViewCellDelegate Methods
-(void)shrinkButtonClickedForChangingHeightOfRow:(UIButton *)sender {


    self.isFloded = !_isFloded;

    [_tableView reloadData];
    

}


-(void)changeYear_Month_Day_Picker:(UIButton *)sender {

    self.isYearPicker = YES;
    [self.tableView reloadData];
    
}
-(void)changeHour_Minutes_Picker:(UIButton *)sender {
    
    self.isYearPicker = NO;
    [self.tableView reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
