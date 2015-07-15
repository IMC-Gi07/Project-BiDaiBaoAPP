//
//  BDBParameterTableViewCell.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBParameterTableViewCell.h"

@interface BDBParameterTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *investableFundButton;

@property (weak, nonatomic) IBOutlet UIButton *investableProjectButton;

@property (weak, nonatomic) IBOutlet UIButton *maxProfitButton;

@property (weak, nonatomic) IBOutlet UIButton *investPeopleNumberButton;

- (void)parameterTableViewCellButtonClickedAction:(UIButton *)button;

@end

@implementation BDBParameterTableViewCell

+ (BDBParameterTableViewCell *)cell {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BDBParameterTableViewCell" owner:nil options:nil];
    BDBParameterTableViewCell *cell = (BDBParameterTableViewCell *)objects[0];
    return cell;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	/**
	 *  可投资金
	 */
	_investableFundButton.tag = BDBParameterTableViewCellButtonTagInvestableFund;
	[_investableFundButton addTarget:self action:@selector(parameterTableViewCellButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
	
	/**
	 *  可投项目
	 */
	_investableProjectButton.tag = BDBParameterTableViewCellButtonTagInvestableProject;
	[_investableProjectButton addTarget:self action:@selector(parameterTableViewCellButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
	
	/**
	 *  最高收益
	 */
	_maxProfitButton.tag = BDBParameterTableViewCellButtonTagMaxProfit;
	[_maxProfitButton addTarget:self action:@selector(parameterTableViewCellButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
	
	/**
	 *  投资人数
	 */
	_investPeopleNumberButton.tag = BDBParameterTableViewCellButtonTagInvestPeopleNumber;
	[_investPeopleNumberButton addTarget:self action:@selector(parameterTableViewCellButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private Methods
- (void)parameterTableViewCellButtonClickedAction:(UIButton *)button {
	button.selected = YES;

	NSInteger buttonTag = button.tag;
	switch (buttonTag) {
		case BDBParameterTableViewCellButtonTagInvestableFund: {
			_investableProjectButton.selected = NO;
			_maxProfitButton.selected = NO;
			_investPeopleNumberButton.selected = NO;
			break;
		}
		case BDBParameterTableViewCellButtonTagInvestableProject: {
			_investableFundButton.selected = NO;
			_maxProfitButton.selected = NO;
			_investPeopleNumberButton.selected = NO;
			break;
		}
		case BDBParameterTableViewCellButtonTagMaxProfit: {
			_investableFundButton.selected = NO;
			_investableProjectButton.selected = NO;
			_investPeopleNumberButton.selected = NO;
			break;
		}
		case BDBParameterTableViewCellButtonTagInvestPeopleNumber: {
			_investableFundButton.selected = NO;
			_investableProjectButton.selected = NO;
			_maxProfitButton.selected = NO;
			break;
		}
			
	  default:
			break;
	}
	
	if ([_delegate respondsToSelector:@selector(button:withTag:selectedInParameterTableViewCell:)]) {
		[_delegate button:button withTag:buttonTag selectedInParameterTableViewCell:self];
	}
}



@end
