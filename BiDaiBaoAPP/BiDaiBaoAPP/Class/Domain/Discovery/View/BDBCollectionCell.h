//
//  BDBCollectionCell.h
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/13.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDBCollectionCellDelegate <NSObject>
- (void)hotTopicsClicked;
- (void)rookieButtonClicked;
- (void)inverstmentGuideClicked;
- (void)securityAssuranceButtonClicked;
- (void)operationModeButtonClicked;
- (void)debitAndCreditButtonClicked;
- (void)riskControlButtonClicked;
- (void)infoOfLawButtonClicked;
- (void)creditorsRightsTransferButtonClicked;
@end

@interface BDBCollectionCell : UITableViewCell
@property (nonatomic,weak) id<BDBCollectionCellDelegate>delegate;
@end
