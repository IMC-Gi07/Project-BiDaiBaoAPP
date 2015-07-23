//
//  BDBTableViewCellCoustom.h
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/8.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBMyColletDateBidListModel.h"
#import "MOProgressView.h"

@protocol buttonSelectd

- (void)buttonselectd:(BOOL)selected indexPath:(NSIndexPath *)aIndexPath;

- (void)pushMyCollectionViewController:(NSString *)interestRateOfYear term:(NSString *)aTerm;

@end

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
//进度条
@property (weak, nonatomic) IBOutlet MOProgressView *jindutiao;
//取消收藏
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property(weak,nonatomic) id<buttonSelectd> delegata;

@property(nonatomic,strong)NSIndexPath *indexPath;

- (void)deployPropertyWithModel:(BDBMyColletDateBidListModel *)model indexPath:(NSIndexPath *)aIndexPath;

@end
