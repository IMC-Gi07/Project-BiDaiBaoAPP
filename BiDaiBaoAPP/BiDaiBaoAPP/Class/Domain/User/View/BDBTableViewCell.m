//
//  BDBTableViewCell.m
//  Subject_verson1
//
//  Created by Imcore.olddog.cn on 15/6/8.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBTableViewCell.h"
#import "MOProgressView.h"
//#import "BDBSujectProfitCalculatorViewController.h"
#import "BDBSujectRespondModel.h"

@interface BDBTableViewCell()

@property(weak, nonatomic) IBOutlet UILabel *BidNameLabel;

@property(weak, nonatomic) IBOutlet UILabel *PlatformNameLabel;

@property(weak, nonatomic) IBOutlet UILabel *AnnualEarningsLabel;

@property(weak, nonatomic) IBOutlet UILabel *TermLabel;

@property(weak, nonatomic) IBOutlet UILabel *AmountLabel;

@property(weak, nonatomic) IBOutlet UILabel *ProgressPercentLabel;

@property(weak, nonatomic) UIViewController *controller;

@property(nonatomic,strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet MOProgressView *progressView;


@end



@implementation BDBTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.isRrefreshing = NO;
        
    }
    return self;
}

+ (BDBTableViewCell *)cell{
    
    BDBTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBTableViewCell" owner:nil options:nil][0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.isRrefreshing = NO;
    
    
    return cell;
    
}

- (void)depoySubViewWithModel: (BDBSujectModel *) model controller:(UIViewController *)viewController indexPath: (NSIndexPath *)aIndexPath{
    
    self.model = model;
    
    self.controller = viewController;
    self.indexPath = aIndexPath;
    
    self.BidNameLabel.text = model.BidName;
    
    self.PlatformNameLabel.text = model.PlatformName;
    
    self.AnnualEarningsLabel.text = [NSString stringWithFormat:@"%g",[model.AnnualEarnings floatValue] * 100];
    
    self.TermLabel.text = model.Term;
    
    CGFloat amountNumber = [model.Amount floatValue];
    
    amountNumber /= 10000.0f;
    
    self.AmountLabel.text = [NSString stringWithFormat:@"%.2f",amountNumber];
    
    CGFloat progressPercent = [model.ProgressPercent floatValue];
    
    progressPercent *= 100;
    
    self.ProgressPercentLabel.text = [NSString stringWithFormat:@"%.0f%%",progressPercent];
    
    [self.progressView setProgress:[model.ProgressPercent floatValue]];
}

#pragma mark -Setter And Getter Methods

- (void)setIsRrefreshing:(BOOL)isRrefreshing{

    _isRrefreshing = isRrefreshing;
    
    
    if(_isRrefreshing == YES){
        
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        basicAnimation.duration = 0.5f;
        basicAnimation.repeatCount = HUGE_VALF;
        basicAnimation.fillMode = kCAFillModeForwards;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.toValue = [NSNumber numberWithDouble: - M_PI];
        [_refreshButton.layer addAnimation:basicAnimation forKey:nil];
        _refreshButton.userInteractionEnabled = NO;
    
        [self upDateGetBidsInf:_refreshButton];
    }
    else{
    
        [_refreshButton.layer removeAllAnimations];
        _refreshButton.userInteractionEnabled = YES;
    }
    
    if(_updateCellisRefresh != nil){
    
        _updateCellisRefresh(_isRrefreshing);

    }
}


//模拟贷款点击事件

- (IBAction)loanButtonClickedAction:(UIButton *)button {
    
//    BDBSujectProfitCalculatorViewController *profitCalculatorController = [[BDBSujectProfitCalculatorViewController alloc] init];
//    
//            profitCalculatorController.AnnualEarnings = _model.AnnualEarnings;
//    
//            profitCalculatorController.Term = _model.Term;
//    
//    [_controller.navigationController pushViewController:profitCalculatorController animated:YES];
}



//收藏按钮点击事件

- (IBAction)collectButtonClickedAction:(UIButton *)button {
    
    NSString *action;

    if(button.selected){

        button.selected = NO;

        action = @"0";

    }
    else{

        button.selected = YES;
        action = @"1";

    }
    _updateCollectButtonSelected(button.selected);
    
    [self upDateBidStore:action platformID:@"13"];
}


//刷新按钮点击事件

- (IBAction)refreshButtonClickedAction:(UIButton *)button {
    
    self.isRrefreshing = YES;
    
}

#pragma mark - Update GetBidsInf

- (void)upDateGetBidsInf:(UIButton *)button{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetBidsInf"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";
    parameterDict[@"UID"] = @"55555555555";
    parameterDict[@"PSW"] = @"5B1B68A9ABF4D2CD155C81A9225FD158";
    parameterDict[@"ID_List"] = _model.ID;
    
    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBSujectRespondModel *responseModel = [BDBSujectRespondModel objectWithKeyValues:responseObject];
        
        BDBSujectModel *newModel = responseModel.BidList[0];
        
        self.updateCellModel(newModel);
        
        self.isRrefreshing = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.isRrefreshing = NO;
    }];
    
}

#pragma mark -Upadate SetBidsStore

//更新收藏信息
- (void)upDateBidStore: (NSString *)action platformID: (NSString *)aPlatforID{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetBidsStore"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";
    parameterDict[@"UID"] = @"55555555555";
    parameterDict[@"PSW"] = @"5B1B68A9ABF4D2CD155C81A9225FD158";
    parameterDict[@"Action"] = action;
    parameterDict[@"ID"] = aPlatforID;
    parameterDict[@"UserType"] = @"0";
    
    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        ZXLLOG(@"%@",responseObject[@"Result"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"%@",error);
    }];
}



@end
