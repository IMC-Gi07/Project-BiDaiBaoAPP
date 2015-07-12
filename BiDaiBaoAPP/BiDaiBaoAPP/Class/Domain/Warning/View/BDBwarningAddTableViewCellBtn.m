//
//  BDBwarningAddTableViewCellBtn.m
//  BiDaiBaoAPP
//
//  Created by mianshuai on 15/7/8.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBwarningAddTableViewCellBtn.h"

@interface BDBwarningAddTableViewCellBtn ()
@property (weak, nonatomic) IBOutlet UIButton *renrendaiBtn;



@end

@implementation BDBwarningAddTableViewCellBtn

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)plathBtnAction:(UIButton *)sender {
    
    [sender setBackgroundImage:[UIImage imageNamed:@"subject_cell_sift_btn_other_highlight_img"] forState:UIControlStateNormal];
    
    [_btnDelegate gainBtnTagAction:sender.tag];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
