//
//  BDBParameterTableViewCell.h
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSInteger, BDBParameterTableViewCellButtonTag) {
	BDBParameterTableViewCellButtonTagInvestableFund = 9996,
	BDBParameterTableViewCellButtonTagInvestableProject,
	BDBParameterTableViewCellButtonTagMaxProfit,
	BDBParameterTableViewCellButtonTagInvestPeopleNumber
};


@class BDBParameterTableViewCell;

/**
 *  按钮点击协议
 */
@protocol BDBParameterTableViewCellDelegate <NSObject>

@optional

/**
 *  按钮点击方法
 */
- (void)button:(UIButton *)button withTag:(NSInteger)tag selectedInParameterTableViewCell:(BDBParameterTableViewCell *)parameterTableViewCell; 
 
@end


@interface BDBParameterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *hideAndShowButton;

/**
 *  可投资金
 */
@property (weak, nonatomic) IBOutlet UILabel *AmountRemainLabel;
/**
 *  可投项目
 */
@property (weak, nonatomic) IBOutlet UILabel *BidNumLabel;
/**
 *  最高收益
 */
@property (weak, nonatomic) IBOutlet UILabel *EarningsMaxLabel;
/**
 *  投资人数
 */
@property (weak, nonatomic) IBOutlet UILabel *InvestorNumLabel;

@property(nonatomic,weak) id<BDBParameterTableViewCellDelegate> delegate;

+ (BDBParameterTableViewCell *)cell;


@end
