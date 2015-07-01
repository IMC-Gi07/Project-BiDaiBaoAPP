//
//  BDBCustomTableViewCell.m
//  warning_time
//
//  Created by mianshuai on 15/6/8.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import "BDBCustomTableViewCell.h"


@interface BDBCustomTableViewCell()

@property (strong, nonatomic) IBOutlet UIButton *shrinkButton;


@end




@implementation BDBCustomTableViewCell

-(instancetype)init{
    if (self = [super init]) {
        
        self.onOFF = NO;
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)clickShrinkButton:(UIButton *)sender {
    if (_onOFF == YES) {
        sender.backgroundColor = [UIColor greenColor];
//        [sender setImage:[UIImage imageNamed:@"warning_topButton"] forState:UIControlStateHighlighted];
        _onOFF = NO;
        
        
    }else if(_onOFF == NO){
        
        sender.backgroundColor = [UIColor redColor];
//        [sender setImage:[UIImage imageNamed:@"waring_downButon"] forState:UIControlStateNormal];

        _onOFF = YES;
    }
    
    [_delegate shrinkButtonClickedForChangingHeightOfRow:sender];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
