//
//  BDBParameterTableViewCell.h
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBParameterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *hideAndShowButton;
@property (weak, nonatomic) IBOutlet UILabel *AmountRemainLabel;
@property (weak, nonatomic) IBOutlet UILabel *BidNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *EarningsMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvestorNumLabel;

+ (BDBParameterTableViewCell *)cell;


@end
