//
//  BDB_TableViewCell_Two.m
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import "BDB_TableViewCell_Two.h"


@implementation BDB_TableViewCell_Two

- (void)awakeFromNib {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [self.slider2 setNumberFormatter:formatter];
    self.slider2.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:26];
    
   
    self.slider2.popUpViewAnimatedColors = @[[UIColor blueColor]];
   
    self.slider2.popUpViewArrowLength = 10;
    
    UIImage *stetchLeftTrack= [UIImage imageNamed:@"slider_min_blackground.png"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"slider_max_blackground.png"];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"slider_button.png"];
    [self.slider2 setFrame:CGRectMake(30, 320, 257, 7)];
 
    
    [self.slider2 setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [self.slider2 setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    
    [self.slider2 setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.slider2 setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end

