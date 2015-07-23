//
//  BDBImformationCell.m
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/13.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBImformationCell.h"

@implementation BDBImformationCell

- (void)awakeFromNib {
   
    self.title.textColor = UIColorWithRGB16Radix(0x4c4c4c);
    self.firstSection.textColor = UIColorWithRGB16Radix(0x8c8c8c);
    self.DT.textColor = UIColorWithRGB16Radix(0x999999);
    self.commentNum.textColor = UIColorWithRGB16Radix(0x999999);
     self.PopularIndex.textColor = UIColorWithRGB16Radix(0x999999);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    // Configure the view for the selected state
}

@end
