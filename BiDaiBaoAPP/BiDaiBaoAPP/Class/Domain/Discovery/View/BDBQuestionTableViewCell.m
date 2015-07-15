//
//  BDBQuestionTableViewCell.m
//  BiDaiBao(比贷宝)
//
//  Created by moon on 15/6/30.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBQuestionTableViewCell.h"

@implementation BDBQuestionTableViewCell

- (void)awakeFromNib {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = UIColorWithRGB(83,83,83);

    [_bgroundView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *visualFormat = @"H:|-(19)-[titleLabel]-(18)-|";
    NSArray *titleLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:@{@"titleLabel": titleLabel}];
    [titleLabel.superview addConstraints:titleLabelConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
