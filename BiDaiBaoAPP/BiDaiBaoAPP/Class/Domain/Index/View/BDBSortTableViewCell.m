//
//  BDBSortTableViewCell.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBSortTableViewCell.h"

@interface BDBSortTableViewCell ()

/**
 *  最赚钱区间
 */
@property (weak, nonatomic) IBOutlet UIView *maxProfitableView;
@property (weak, nonatomic) IBOutlet UIImageView *maxProfitableIconImageView;

/**
 *  最稳健区间
 */
@property (weak, nonatomic) IBOutlet UIView *maxStableView;
@property (weak, nonatomic) IBOutlet UIImageView *maxStableIconImageView;

/**
 *  最保守区间
 */
@property (weak, nonatomic) IBOutlet UIView *maxSafeView;
@property (weak, nonatomic) IBOutlet UIImageView *maxSafeIconImageView;


- (void)theMaxViewTapped:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation BDBSortTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	/**
	 *  最赚钱区间
	 */
	UITapGestureRecognizer *maxProfitableViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theMaxViewTapped:)];
	[_maxProfitableView addGestureRecognizer:maxProfitableViewTapGestureRecognizer];
	_maxProfitableView.tag = BDBSortTableViewCellMaxViewTagMaxProfitable;
	
	
	/**
	 *  最稳健区间
	 */
	UITapGestureRecognizer *maxStableViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theMaxViewTapped:)];
	[_maxStableView addGestureRecognizer:maxStableViewTapGestureRecognizer];
	_maxStableView.tag = BDBSortTableViewCellMaxViewTagMaxStable;
	
	/**
	 *  最保守区间
	 */
	UITapGestureRecognizer *maxSafeViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theMaxViewTapped:)];
	[_maxSafeView addGestureRecognizer:maxSafeViewTapGestureRecognizer];
	_maxSafeView.tag = BDBSortTableViewCellMaxViewTagMaxSafe;
}

#pragma mark - Private Methods
- (void)theMaxViewTapped:(UIGestureRecognizer *)gestureRecognizer {
	NSInteger tappedMaxViewTag = gestureRecognizer.view.tag;
	switch (tappedMaxViewTag) {
		/**
		 *  最赚钱
		 */	
		case BDBSortTableViewCellMaxViewTagMaxProfitable:{
			_maxProfitableIconImageView.image = [UIImage imageNamed:@"Index_icon_max_profitable_selected"];
			_maxStableIconImageView.image = [UIImage imageNamed:@"Index_icon_max_stable"];
			_maxSafeIconImageView.image = [UIImage imageNamed:@"Index_icon_max_safe"];	
			break;
		}
		/**
		 *  最稳定
		 */	
		case BDBSortTableViewCellMaxViewTagMaxStable:{
			_maxProfitableIconImageView.image = [UIImage imageNamed:@"Index_icon_max_profitable"];
			_maxStableIconImageView.image = [UIImage imageNamed:@"Index_icon_max_stable_selected"];
			_maxSafeIconImageView.image = [UIImage imageNamed:@"Index_icon_max_safe"];
			break;
		}
		/**
		 *  最安全
		 */	
		case BDBSortTableViewCellMaxViewTagMaxSafe:{
			_maxProfitableIconImageView.image = [UIImage imageNamed:@"Index_icon_max_profitable"];
			_maxStableIconImageView.image = [UIImage imageNamed:@"Index_icon_max_stable"];
			_maxSafeIconImageView.image = [UIImage imageNamed:@"Index_icon_max_safe_selected"];
			break;
		}	
  		default:
			break;
	}
	
	if ([_delegate respondsToSelector:@selector(maxView:withTag:tappedInBDBSortTableViewCell:)]) {
		[_delegate maxView:gestureRecognizer.view withTag:tappedMaxViewTag tappedInBDBSortTableViewCell:self];
	}
}




@end
