//
//  BDBTableViewCellCoustom.h
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/8.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBMyColletDateBidListModel.h"
@interface BDBTableViewCellCoustom : UITableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *BidNameLabel;
//平台名称
@property (weak, nonatomic) IBOutlet UILabel *PlatformNameLabel;
//年率利
@property (weak, nonatomic) IBOutlet UILabel *AnnualEarningsLabel;
//限定期限
@property (weak, nonatomic) IBOutlet UILabel *TermLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *AmountLabel;
//进度
@property (weak, nonatomic) IBOutlet UILabel *ProgressPercentLabel;


- (void)deployPropertyWithModel:(BDBMyColletDateBidListModel *)model;

@end
