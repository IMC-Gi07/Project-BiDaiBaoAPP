//
//  questionTableViewCell.m
//  discover_encyclopedia_JT
//
//  Created by mianshuai on 15/6/11.
//  Copyright (c) 2015年 bdb. All rights reserved.
//

#import "BDBDetailQuestionTableViewCell.h"

@implementation BDBDetailQuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CALayer *photoLayer = _photoView.layer;
    
    photoLayer.contents = (__bridge id)([UIImage imageNamed:@"discover_monkey"].CGImage);
    photoLayer.backgroundColor = [UIColor whiteColor].CGColor;
    photoLayer.cornerRadius = 50;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
