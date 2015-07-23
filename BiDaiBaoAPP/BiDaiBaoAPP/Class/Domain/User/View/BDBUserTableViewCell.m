//
//  BDBUserTableViewCell.m
//  BiDaiBaoAPP
//
//  Created by olddog on 15/7/4.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBUserTableViewCell.h"

@interface BDBUserTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderBackgroundImageVIew;

@property (weak, nonatomic) IBOutlet UIImageView *userQuestionBackgroundImageView;

@property(nonatomic,weak) UIImageView *userHeaderImageView;


@end

@implementation BDBUserTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if(self = [super initWithCoder:aDecoder]){
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClickedAction)];
		
		[self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)awakeFromNib {
    
    UIImageView *userHeaderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_QA_default_header_img"]];
    
    userHeaderImageView.layer.cornerRadius = 15;
    
    userHeaderImageView.layer.masksToBounds = YES;

    [_userHeaderBackgroundImageVIew addSubview:userHeaderImageView];
    
    self.userHeaderImageView = userHeaderImageView;
    
    userHeaderImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerXForUserHeaderImageView = [NSLayoutConstraint constraintWithItem:userHeaderImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_userHeaderBackgroundImageVIew attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    [_userHeaderBackgroundImageVIew addConstraint:centerXForUserHeaderImageView];
    
    NSLayoutConstraint *centerYForUserHeaderImageView = [NSLayoutConstraint constraintWithItem:userHeaderImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_userHeaderBackgroundImageVIew attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    [_userHeaderBackgroundImageVIew addConstraint:centerYForUserHeaderImageView];
    
    UILabel *contentQuestionLabel = [[UILabel alloc] init];
    
    contentQuestionLabel.numberOfLines = 0;
    
    contentQuestionLabel.font = [UIFont systemFontOfSize:15.0f];
    
    contentQuestionLabel.textColor = UIColorWithRGB(153, 153, 153);
    
    [_userQuestionBackgroundImageView addSubview:contentQuestionLabel];
    
    self.contentQuestionLabel = contentQuestionLabel;
    
    contentQuestionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leadingForContentQuestionLabel = [NSLayoutConstraint constraintWithItem:contentQuestionLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_userQuestionBackgroundImageView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:5.0f];
    
    [_userQuestionBackgroundImageView addConstraint:leadingForContentQuestionLabel];
    
    NSLayoutConstraint *trailingForContentQuestionLabel = [NSLayoutConstraint constraintWithItem:contentQuestionLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_userQuestionBackgroundImageView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-5.0f];
    
    [_userQuestionBackgroundImageView addConstraint:trailingForContentQuestionLabel];
    
    NSLayoutConstraint *topForContentQuestionLabel = [NSLayoutConstraint constraintWithItem:contentQuestionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userQuestionBackgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:12.0f];
    
    [_userQuestionBackgroundImageView addConstraint:topForContentQuestionLabel];
    
    NSLayoutConstraint *bottomForContentQuestionLabel = [NSLayoutConstraint constraintWithItem:contentQuestionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userQuestionBackgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-5.0f];
    
    [_userQuestionBackgroundImageView addConstraint:bottomForContentQuestionLabel];
    
    
    
}

- (void)cellClickedAction{

	if(_answerLebel.text.length > 0){
	
		[_delegate pushDestinationController:_answerModel.ID];
	
	}
	else{
		[_delegate pushDestinationController:_questionModel.ID];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
