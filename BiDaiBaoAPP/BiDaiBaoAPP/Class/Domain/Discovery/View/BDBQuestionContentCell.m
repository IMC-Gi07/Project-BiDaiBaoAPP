//
//  BDBQuestionContentCell.m
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBQuestionContentCell.h"

@implementation BDBQuestionContentCell
- (void)layoutSubviews {
    [super layoutSubviews];
    _userPhotoView.layer.contents = (id)UIImageWithName(@"default_head_img").CGImage;
    _userPhotoView.layer.borderWidth = 2.0f;
    _userPhotoView.layer.borderColor = UIColorWithRGB(152, 192, 238).CGColor;
    
    _userPhotoView.layer.cornerRadius = 20.0f;
    _userPhotoView.layer.masksToBounds = YES;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
