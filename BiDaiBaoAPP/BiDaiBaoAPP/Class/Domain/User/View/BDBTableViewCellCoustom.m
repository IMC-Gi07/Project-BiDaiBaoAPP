//
//  BDBTableViewCellCoustom.m
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/8.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBTableViewCellCoustom.h"
#import "BDBMyCollectViewModel.h"
#import "BDBMyColletDateModel.h"

@interface BDBTableViewCellCoustom()

@property(nonatomic,strong) BDBMyColletDateBidListModel *model;

@end

@implementation BDBTableViewCellCoustom


- (IBAction)cancelButton:(UIButton *)sender {
    
    NSString *action;
    
    if (sender.selected == YES) {
        
        sender.selected = NO;
        action = @"1";
    }
    else{
        
        sender.selected = YES;
        action = @"0";

    }
    
    [_delegata buttonselectd:sender.selected indexPath:_indexPath];

    
    [self upDateBidStore:action platformID:_model.ID];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)deployPropertyWithModel:(BDBMyColletDateBidListModel *)model indexPath:(NSIndexPath *)aIndexPath{

    self.model = model;
    self.indexPath = aIndexPath;
    
    _TermLabel.text = model.Term;

    _PlatformNameLabel.text = model.PlatformName;
    
    _BidNameLabel.text = model.BidName;
    
    _AnnualEarningsLabel.text = [NSString stringWithFormat:@"%g",[model.AnnualEarnings floatValue] * 100];
    
    CGFloat amountLabel = [model.Amount floatValue];
    amountLabel /= 10000.0f;
    _AmountLabel.text = [NSString stringWithFormat:@"%.2f",amountLabel];
    
    CGFloat progressPercentLabel = [model.ProgressPercent floatValue];
    progressPercentLabel *= 100.0f;
    _ProgressPercentLabel.text = [NSString stringWithFormat:@"%.0f%%",progressPercentLabel];
    
    [_jindutiao setProgress:[model.ProgressPercent doubleValue] ];
}


//收藏按钮点击事件
- (IBAction)mockLoanButtonClickedAction:(UIButton *)button {
    
    [_delegata pushMyCollectionViewController: _AnnualEarningsLabel.text term:_model.Term];
    
}


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
        
        //ZXLLOG(@"%@",responseObject[@"Result"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //ZXLLOG(@"%@",error);
    }];
}



@end
