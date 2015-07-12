//
//  BDBUserTableViewCell.h
//  BiDaiBaoAPP
//
//  Created by olddog on 15/7/4.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBUserTableViewCell : UITableViewCell

@property(nonatomic,weak)UILabel *contentQuestionLabel;

@property (weak, nonatomic) IBOutlet UILabel *questonTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionAskTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *answerLebel;




@end
