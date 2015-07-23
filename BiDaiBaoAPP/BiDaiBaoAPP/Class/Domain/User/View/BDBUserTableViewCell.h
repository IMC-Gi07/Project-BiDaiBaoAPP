//
//  BDBUserTableViewCell.h
//  BiDaiBaoAPP
//
//  Created by olddog on 15/7/4.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BDBUserQestionsModel.h"
#import "BDBUserAnswerModel.h"

@protocol BDBUserTableViewCellDelegate

- (void)pushDestinationController:(NSString *)modelID;

@end

@interface BDBUserTableViewCell : UITableViewCell

@property(nonatomic,weak)UILabel *contentQuestionLabel;

@property (weak, nonatomic) IBOutlet UILabel *questonTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionAskTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *answerLebel;

@property(nonatomic,strong) BDBUserQestionsModel *questionModel;

@property(nonatomic,strong) BDBUserAnswerModel *answerModel;

@property(nonatomic,weak)id<BDBUserTableViewCellDelegate> delegate;


@end
