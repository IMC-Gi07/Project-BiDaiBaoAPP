//
//  BDBMessageTableViewCell.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/17.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBMessageTableViewCell.h"

@implementation BDBMessageTableViewCell

+ (BDBMessageTableViewCell *)cell {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BDBMessageTableViewCell" owner:nil options:nil];
    BDBMessageTableViewCell *cell = (BDBMessageTableViewCell *)objects[0];
    return cell;
}

@end
