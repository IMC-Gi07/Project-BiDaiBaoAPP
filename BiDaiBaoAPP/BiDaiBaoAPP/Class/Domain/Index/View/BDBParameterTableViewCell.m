//
//  BDBParameterTableViewCell.m
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/19.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBParameterTableViewCell.h"

@implementation BDBParameterTableViewCell

+ (BDBParameterTableViewCell *)cell {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BDBParameterTableViewCell" owner:nil options:nil];
    BDBParameterTableViewCell *cell = (BDBParameterTableViewCell *)objects[0];
    return cell;
}

@end
