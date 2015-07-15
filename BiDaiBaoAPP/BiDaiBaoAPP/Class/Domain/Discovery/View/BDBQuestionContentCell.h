//
//  BDBQuestionContentCell.h
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBQuestionContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *userPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *firstReply;
@property (weak, nonatomic) IBOutlet UILabel *askUser;
@property (weak, nonatomic) IBOutlet UILabel *askTime;

@end
