//
//  BDBMessageTableViewCell.h
//  BDBMessagePercent
//
//  Created by Jamy on 15/6/17.
//  Copyright (c) 2015年 Jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCyclingLabel;

@interface BDBMessageTableViewCell : UITableViewCell

@property(nonatomic,copy) NSArray *texts;

- (NSString *)displayingText;

@end
