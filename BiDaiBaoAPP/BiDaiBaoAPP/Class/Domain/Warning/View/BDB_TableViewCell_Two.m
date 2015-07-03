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
    
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
//    [self.slider2 setNumberFormatter:formatter];
//    self.slider2.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:26];
//    
//   
//    self.slider2.popUpViewAnimatedColors = @[[UIColor blueColor]];
//   
//    self.slider2.popUpViewArrowLength = 10;
//    self.slider2.maximumValue = 25;
   
    
    
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"%"];
    [tempFormatter setNegativeSuffix:@"%"];
    

    [self.slider2 setNumberFormatter:tempFormatter];
    self.slider2.minimumValue = 0;
    self.slider2.maximumValue = 25;
    
    self.slider2.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:26];
    self.slider2.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIColor *blue = [UIColor colorWithHue:0.58 saturation:0.75 brightness:1.0 alpha:1.0];

    [self.slider2 setPopUpViewAnimatedColors:@[blue] withPositions:@[@0]];
    
    
    
    
    UIImage *stetchLeftTrack= [UIImage imageNamed:@"slider_min_blackground"];
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

- (IBAction)change:(ASValueTrackingSlider *)sender {
    [_delegate updateSliderValue:sender.value];
}

@end

