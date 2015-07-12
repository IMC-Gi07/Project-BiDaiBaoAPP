//
//  BDBTableViewCell.m
//  Subject_verson1
//
//  Created by Imcore.olddog.cn on 15/6/8.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import "BDBSubjectTableViewCell.h"
#import "MOProgressView.h"
#import "BDBSubjectProfitCalculatorViewController.h"
#import "BDBSujectRespondModel.h"
#import "BDBSubjectShowWebViewController.h"
#import "BDBMyCollectViewController.h"

@interface BDBSubjectTableViewCell()

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



@implementation BDBSubjectTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.isRrefreshing = NO;
        
        
    }
    return self;
}

+ (BDBSubjectTableViewCell *)cell{
    
    BDBSubjectTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BDBSubjectTableViewCell" owner:nil options:nil][0];
    
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
    
    UITapGestureRecognizer *tapGestureForCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushWebView:)];
    
    [self addGestureRecognizer:tapGestureForCell];
}

#pragma mark -Setter And Getter Methods

- (void)setIsRrefreshing:(BOOL)isRrefreshing{

    _isRrefreshing = isRrefreshing;
    
    if(_isRrefreshing == YES){
        
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        basicAnimation.duration = 0.2f;
        basicAnimation.repeatCount = HUGE_VALF;
        basicAnimation.fillMode = kCAFillModeForwards;
        basicAnimation.removedOnCompletion = YES;
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
       
    }

}


//模拟贷款点击事件

- (IBAction)loanButtonClickedAction:(UIButton *)button {
    
    BDBSubjectProfitCalculatorViewController *profitCalculatorController = [[BDBSubjectProfitCalculatorViewController alloc] init];
    
            profitCalculatorController.AnnualEarnings = _model.AnnualEarnings;
    
            profitCalculatorController.Term = _model.Term;
    
    [_controller.navigationController pushViewController:profitCalculatorController animated:YES];
}



//收藏按钮点击事件

- (IBAction)collectButtonClickedAction:(UIButton *)button {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userUID = [userDefaults objectForKey:@"UID"];
    
    if(userUID == nil){
        
        //提示用户登录
        
        UIAlertView *alerLogin = [[UIAlertView alloc] initWithTitle:nil message:@"未登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alerLogin show];
    }
    else{
        
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
        
        [self upDateBidStore:action platformID:_model.ID];
    }

    

}


//刷新按钮点击事件

- (IBAction)refreshButtonClickedAction:(UIButton *)button {
    
    self.isRrefreshing = YES;
     _updateCellisRefresh(_isRrefreshing);
    
}


//链接到响应的页面
- (void)pushWebView:(UIGestureRecognizer *)gesture{

    _pushWebView();
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
         _updateCellisRefresh(_isRrefreshing);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.isRrefreshing = NO;
         _updateCellisRefresh(_isRrefreshing);
    }];
    
}

#pragma mark -Upadate SetBidsStore

//更新收藏信息
- (void)upDateBidStore: (NSString *)action platformID: (NSString *)aPlatforID{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *userUID = [userDefault objectForKey:@"UID"];
    NSString *userPSW = [userDefault objectForKey:@"PSW"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetBidsStore"];
    
    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
    
    parameterDict[@"Machine_id"] = IPHONE_DEVICE_UUID;
    parameterDict[@"Device"] = @"0";
    parameterDict[@"UID"] = userUID;
    parameterDict[@"PSW"] = userPSW;
    parameterDict[@"Action"] = action;
    parameterDict[@"ID"] = aPlatforID;
    parameterDict[@"UserType"] = @"0";
    
    [manager POST:requestURL parameters:parameterDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"alertViewCancel");
    UIStoryboard *userStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    
    BDBMyCollectViewController *controller = [userStoryboard instantiateViewControllerWithIdentifier:@"userLoginViewController"];
    
    [_controller.navigationController pushViewController:controller animated:YES];
}


@end
