//
//  BDBNoticeTableViewCell.h
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/15.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBNoticeModel.h"

@interface BDBNoticeTableViewCell : UITableViewCell

/**
 *  内容标题
 */
@property (nonatomic,weak) UILabel *titleLabel;

/**
 *  发布时间
 */
@property(nonatomic,weak) UILabel *pubTimeLabel;


@end
