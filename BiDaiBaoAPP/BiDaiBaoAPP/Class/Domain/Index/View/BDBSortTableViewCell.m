//
//  BDBSortTableViewCell.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBSortTableViewCell.h"

@interface BDBSortTableViewCell ()


@end

@implementation BDBSortTableViewCell

+ (BDBSortTableViewCell *)cell {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BDBSortTableViewCell" owner:nil options:nil];
    BDBSortTableViewCell *cell = (BDBSortTableViewCell *)objects[0];
    return cell;
}

@end
