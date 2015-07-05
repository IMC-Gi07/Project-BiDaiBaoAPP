//
//  BDBCustomTableViewCellTwo.m
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import "BDBCustomTableViewCellTwo.h"


@implementation BDBCustomTableViewCellTwo

- (void)awakeFromNib {
    // Initialization code
}


- (IBAction)secondClockButton:(UIButton *)sender {

    [_delegate1 changeHour_Minutes_Picker:sender];
   
    
}

- (IBAction)calendarButtom:(UIButton *)sender {
    [_delegate1 changeYear_Month_Day_Picker:sender];

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
