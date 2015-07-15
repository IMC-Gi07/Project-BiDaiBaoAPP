//
//  BDBCollectionCell.m
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/13.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBCollectionCell.h"

@implementation BDBCollectionCell
- (IBAction)hotTopicsButtonClickedAction:(UIButton *)sender {
    [_delegate hotTopicsClicked];
}
- (IBAction)rookieButtonClickedAction:(UIButton *)sender {
    [_delegate rookieButtonClicked];
}
- (IBAction)investmentGuideButtonClickedAction:(UIButton *)sender {
    [_delegate inverstmentGuideClicked];
}

- (IBAction)securityAssuranceButtonClickedAction:(UIButton *)sender {
    [_delegate securityAssuranceButtonClicked];
}
- (IBAction)operationModeButtonClickedAction:(UIButton *)sender {
    [_delegate operationModeButtonClicked];
}

- (IBAction)debitAndCreditButtonClickedAction:(UIButton *)sender {
    [_delegate debitAndCreditButtonClicked];
}
- (IBAction)riskControlButtonClickedAction:(UIButton *)sender {
    [_delegate riskControlButtonClicked];
}

- (IBAction)infoOfLawButtonClickedAction:(UIButton *)sender {
    [_delegate infoOfLawButtonClicked];
}

- (IBAction)creditorsRightsTransferButtonClickedAction:(UIButton *)sender {
    [_delegate creditorsRightsTransferButtonClicked];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
