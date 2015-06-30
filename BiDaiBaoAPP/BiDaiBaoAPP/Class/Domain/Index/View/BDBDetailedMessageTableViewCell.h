//
//  BDBTableViewCell.h
//  BDBHomePage
//
//  Created by Jamy on 15/6/16.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBDetailedMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

+ (BDBDetailedMessageTableViewCell *)cell;

@end
