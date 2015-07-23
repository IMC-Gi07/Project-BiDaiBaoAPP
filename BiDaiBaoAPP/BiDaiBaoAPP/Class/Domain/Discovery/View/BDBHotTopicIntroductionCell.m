//
//  BDBHotTopicFirstCell.m
//  BDB_HotTopics
//
//  Created by Tomoxox on 15/6/15.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBHotTopicIntroductionCell.h"

@implementation BDBHotTopicIntroductionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.introductionCellTitle.textColor = UIColorWithRGB16Radix(0x4c4c4c);
    self.introductionContent.textColor = UIColorWithRGB16Radix(0x666666);
}

@end
