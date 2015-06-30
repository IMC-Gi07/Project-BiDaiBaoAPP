//
//  BDBWarningTableViewCell.m
//  BDB_Draft
//
//  Created by Tomoxox on 15/6/8.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBWarningTableViewCell.h"
@interface BDBWarningTableViewCell()



@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(UIButton *)sender;
- (IBAction)ringButtonClicked:(UIButton *)sender;



@end

@implementation BDBWarningTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//删除
- (IBAction)deleteButtonClicked:(UIButton *)sender {

    [self.deleteButton setImage:[UIImage imageNamed:@"cell_btn_delete_Highlighted"] forState:UIControlStateNormal];
    [_delegate deleteButtonClickedAction:sender];

}
//响铃
- (IBAction)ringButtonClicked:(UIButton *)sender {
    [sender setImage:[UIImage imageNamed:@"cell_btn_NORing"] forState:UIControlStateNormal];
    NSLog(@"RingButtonClicked...");
}
@end
