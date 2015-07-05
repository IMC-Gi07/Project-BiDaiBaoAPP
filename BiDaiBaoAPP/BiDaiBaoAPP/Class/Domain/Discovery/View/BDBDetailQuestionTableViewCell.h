//
//  questionTableViewCell.h
//  discover_encyclopedia_JT
//
//  Created by mianshuai on 15/6/11.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBDetailQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *askUser;
@property (weak, nonatomic) IBOutlet UIButton *replyNum;
@property (weak, nonatomic) IBOutlet UILabel *askTime;
@property (weak, nonatomic) IBOutlet UITextView *ask;

@end
