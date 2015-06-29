//
//  BDBTableViewCell.h
//  Subject_verson1
//
//  Created by Imcore.olddog.cn on 15/6/8.
//  Copyright (c) 2015年 Imcore.olddog.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBSujectModel.h"
@interface BDBTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *BidNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *PlatformNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *AnnualEarningsLabel;

@property (weak, nonatomic) IBOutlet UILabel *TermLabel;

@property (weak, nonatomic) IBOutlet UILabel *AmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *ProgressPercentLabel;



+ (BDBTableViewCell *)cellWithModel:(BDBSujectModel *) model;

@end
