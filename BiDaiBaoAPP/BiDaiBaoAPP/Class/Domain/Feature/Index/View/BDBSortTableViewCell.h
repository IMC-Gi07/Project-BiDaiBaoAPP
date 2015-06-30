//
//  BDBSortTableViewCell.h
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBSortTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *redView;

@property (weak, nonatomic) IBOutlet UIView *greenView;

@property (weak, nonatomic) IBOutlet UIView *blueView;

@property (weak, nonatomic) IBOutlet UILabel *moreThanFifteenPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreThanTwelvePercentLessThanFifteenPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessThanTwelvePercentLabel;

+ (BDBSortTableViewCell *)cell;

@end
