//
//  BDBCustomTableViewCellTwo.h
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BDBCustomTableViewCellTwoDelegate;

@interface BDBCustomTableViewCellTwo : UITableViewCell

@property (nonatomic,weak) id<BDBCustomTableViewCellTwoDelegate>delegate1;
@property (weak, nonatomic) IBOutlet UIButton *yearBtnText;

@property (weak, nonatomic) IBOutlet UIButton *minutesBtnText;



@end

@protocol BDBCustomTableViewCellTwoDelegate <NSObject>

-(void)changeHour_Minutes_Picker:(UIButton *)sender;

- (void)changeYear_Month_Day_Picker:(UIButton *)sender;


@end
