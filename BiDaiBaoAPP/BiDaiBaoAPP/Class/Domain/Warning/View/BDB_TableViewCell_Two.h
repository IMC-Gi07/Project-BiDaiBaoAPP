//
//  BDB_TableViewCell_Two.h
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"

@protocol BDB_TableViewCell_TwoDelegate <NSObject>

- (void)updateSliderValue:(NSInteger)sliderValue;

@end
@interface BDB_TableViewCell_Two : UITableViewCell
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider2;
@property (weak,nonatomic) id<BDB_TableViewCell_TwoDelegate>delegate;
@end
