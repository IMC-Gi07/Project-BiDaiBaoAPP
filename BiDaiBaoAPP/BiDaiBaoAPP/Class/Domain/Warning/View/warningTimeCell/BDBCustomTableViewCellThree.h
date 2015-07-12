//
//  BDBCustomTableViewCellThree.h
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDBCustomTableViewCellThreeDelegate <NSObject>

- (void)datePickerText:(NSString *)datePickerText andDatePickerHour:(NSString *)datePickerHourText CSdatePickerText:(NSString *)CSdatePickerText andCSDatePickerHour:(NSString *)CSdatePickerHourText;

@end


@interface BDBCustomTableViewCellThree : UITableViewCell
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak,nonatomic) id<BDBCustomTableViewCellThreeDelegate>delegate3;


@end
