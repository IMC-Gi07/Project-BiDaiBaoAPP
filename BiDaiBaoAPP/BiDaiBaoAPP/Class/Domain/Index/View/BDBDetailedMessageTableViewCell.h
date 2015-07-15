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
@property (weak, nonatomic) IBOutlet UILabel *ProgressPercentLabel;

@property (weak, nonatomic) IBOutlet UILabel *TermLabel;
@property (weak, nonatomic) IBOutlet UILabel *AmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *PlatformNameLabel;


@property (weak, nonatomic) IBOutlet UIImageView *iconBallImageView;


+ (BDBDetailedMessageTableViewCell *)cell;

@end
