//
//  BDBTableViewCell.m
//  BDBHomePage
//
//  Created by Jamy on 15/6/16.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import "BDBDetailedMessageTableViewCell.h"

@implementation BDBDetailedMessageTableViewCell

+ (BDBDetailedMessageTableViewCell *)cell {
    NSArray *objects = [[NSBundle mainBundle]loadNibNamed:@"BDBDetailedMessageTableViewCell" owner:nil options:nil];
    BDBDetailedMessageTableViewCell *cell = (BDBDetailedMessageTableViewCell *)objects[0];
    return cell;
}

@end
