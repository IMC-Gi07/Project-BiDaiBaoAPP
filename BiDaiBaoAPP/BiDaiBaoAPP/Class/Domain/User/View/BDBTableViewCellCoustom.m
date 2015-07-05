//
//  BDBTableViewCellCoustom.m
//  BiDaiBao(比贷宝)
//
//  Created by Carrie's baby on 15/6/8.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBTableViewCellCoustom.h"

@implementation BDBTableViewCellCoustom

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)deployPropertyWithModel:(BDBMyColletDateBidListModel *)model{

    _TermLabel.text = model.Term;
    
    _PlatformNameLabel.text = model.PlatformName;
    
    _BidNameLabel.text = model.BidName;
    
    _AnnualEarningsLabel.text = model.AnnualEarnings;
    
    _AmountLabel.text = model.Amount;
}

@end
