//
//  BDBCustomTableViewCellOne.m
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import "BDBCustomTableViewCellOne.h"

@implementation BDBCustomTableViewCellOne

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)TitleTextFieldAction:(UITextField *)sender {
    [_delegate transferTitleText:sender];
    self.input = sender.text;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
