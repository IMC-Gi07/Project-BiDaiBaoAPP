//
//  BDBSortTableViewCell.h
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSInteger, BDBSortTableViewCellMaxViewTag) {
	BDBSortTableViewCellMaxViewTagMaxProfitable = 9000,
	BDBSortTableViewCellMaxViewTagMaxStable,
	BDBSortTableViewCellMaxViewTagMaxSafe
};


@class BDBSortTableViewCell;

@protocol BDBSortTableViewCellDelegate <NSObject>

@optional

- (void)maxView:(UIView *)view withTag:(NSInteger)tag tappedInBDBSortTableViewCell:(BDBSortTableViewCell *)sortTableViewCell;

@end

@interface BDBSortTableViewCell : UITableViewCell


@property(nonatomic,weak) id<BDBSortTableViewCellDelegate> delegate;


@end
