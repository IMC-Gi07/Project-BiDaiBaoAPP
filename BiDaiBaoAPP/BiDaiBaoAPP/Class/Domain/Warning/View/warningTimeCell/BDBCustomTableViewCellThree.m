//
//  BDBCustomTableViewCellThree.m
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import "BDBCustomTableViewCellThree.h"
#import "BDBCustomTableViewCellTwo.h"



@interface BDBCustomTableViewCellThree()



@end

@implementation BDBCustomTableViewCellThree




- (void)awakeFromNib {
    // Initialization code
 
}

- (IBAction)datePickerAction:(UIDatePicker *)sender {
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatterYear = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatterYear setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStringYear = [pickerFormatterYear stringFromDate:pickerDate];
    
   // NSLog(@"1111111格式化显示时间1111111：%@",dateStringYear);
    
    
    
    NSDateFormatter *pickerFormatterHour = [[NSDateFormatter alloc] init];
    
    [pickerFormatterHour setDateFormat:@"HH:mm"];

    NSString *dateStringHour = [pickerFormatterHour stringFromDate:pickerDate];
    
   // NSLog(@"2222222格式化显示时间22222222：%@",dateStringHour);
    
    
    
    NSDate *CSpickerDate = [self.datePicker date];
    
    NSDateFormatter *CSpickerFormatterYear = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [CSpickerFormatterYear setDateFormat:@"yyyy-MM-dd"];
    NSString *CSdateStringYear = [CSpickerFormatterYear stringFromDate:CSpickerDate];
    
   // NSLog(@"33333333格式化显示时间3333333：%@",CSdateStringYear);
    
    
    
    NSDateFormatter *CSpickerFormatterHour = [[NSDateFormatter alloc] init];
    
    [CSpickerFormatterHour setDateFormat:@"HH:mm:ss"];
    
    NSString *CSdateStringHour = [CSpickerFormatterHour stringFromDate:CSpickerDate];
    
   // NSLog(@"44444444格式化显示时间44444444：%@",CSdateStringHour);
    

    
    
    
    
    [_delegate3 datePickerText:dateStringYear andDatePickerHour:dateStringHour CSdatePickerText:CSdateStringYear andCSDatePickerHour:CSdateStringHour];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end
