//
//  ViewController.m
//  BDB_Draft
//
//  Created by Tomoxox on 15/6/8.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBWarningViewController.h"
#import "BDBWarningTableViewCell.h"
@interface BDBWarningViewController ()<UITableViewDataSource,UITableViewDelegate,BDBWarningTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *warningListTableView;

@property (weak, nonatomic) IBOutlet UIButton *addWarningButton;

@property (nonatomic,assign) NSUInteger warningRowsNum;



@end

@implementation BDBWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.warningListTableView.dataSource = self;
    self.warningListTableView.delegate = self;
    
    self.warningListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.warningListTableView.rowHeight = 100.0f;
    self.warningListTableView.allowsSelection = NO;
    self.warningListTableView.showsVerticalScrollIndicator = NO;
    
    self.warningRowsNum = 2;
    
}


//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _warningRowsNum;
}

//调用nib的cell，定制色彩块颜色
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BDBWarningTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBWarningTableViewCell" owner:nil options:nil][0];
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
    
//    bdb
//    
//    cell.PlateFormNameLable.text =
    
    
    
    
    return cell;
}

#pragma mark - BDBWarningTableViewCellDelegate Methods

-(void)deleteButtonClickedAction:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"删除预警" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    [alertView show];
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
        
       
        
    }
    [_warningListTableView reloadData];
}
- (IBAction)warningAddButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"towarningAddViewControllerSegue" sender:self];
    
}

- (void)warningLoadDatas{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetMyAlarmInf"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameters[@"Device"] = @"0";
    
    parameters[@"UID"] = @"99999999999";
    
    parameters[@"PSW"] = @"52C69E3A57331081823331C4E69D3F2E";
    
    
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ZXLLOG(@"success response: %@",responseObject[@"Msg"]);
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
}


@end
