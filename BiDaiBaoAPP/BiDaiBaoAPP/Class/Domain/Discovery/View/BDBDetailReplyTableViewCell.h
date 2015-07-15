//
//  replyTableViewCell.h
//  discover_encyclopedia_JT
//
//  Created by mianshuai on 15/6/14.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBDetailReplyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *photoView;

@property (weak, nonatomic,readwrite) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UILabel *hot;



@end
