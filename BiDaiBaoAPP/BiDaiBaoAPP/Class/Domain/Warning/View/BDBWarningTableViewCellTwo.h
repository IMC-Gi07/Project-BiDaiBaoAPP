//
//  BDBWarningTableViewCellTwo.h
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/2.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDBWarningTableViewCellTwoDelegate;

@interface BDBWarningTableViewCellTwo : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *warningTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningTimeTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *delButton_2;
@property(weak,nonatomic) id<BDBWarningTableViewCellTwoDelegate>delegate_2;


@end

@protocol BDBWarningTableViewCellTwoDelegate <NSObject>

- (void)delete_2ButtonClickedAction:(UIButton *)button;

@end