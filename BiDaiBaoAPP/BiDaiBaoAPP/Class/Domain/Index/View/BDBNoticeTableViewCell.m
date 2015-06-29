//
//  BDBNoticeTableViewCell.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/15.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBNoticeTableViewCell.h"

@interface BDBNoticeTableViewCell ()

/**
 *  背景气泡
 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;

/**
 *  闹钟图片
 */
@property(nonatomic,weak) UIImageView *clockImgView;


@end


@implementation BDBNoticeTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	/**
	 *  内容标题
	 */
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	titleLabel.numberOfLines = 0;
	titleLabel.textColor = UIColorWithRGB(83,83,83);
	
	[_backgroundImgView addSubview:titleLabel];
	self.titleLabel = titleLabel;
	
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSString *visualFormat = @"H:|-(19)-[titleLabel]-(18)-|";
	NSArray *titleLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:@{@"titleLabel": titleLabel}];
	[titleLabel.superview addConstraints:titleLabelConstraints];
	
	
	/**
	 *  闹钟图片
	 */
	UIImageView *clockImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_notice_item_clock"]];
	[_backgroundImgView addSubview:clockImgView];
	self.clockImgView = clockImgView;
	
	clockImgView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSLayoutConstraint *clockImgViewConstraint_W = [NSLayoutConstraint constraintWithItem:clockImgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:11.0f];
	
	NSLayoutConstraint *clockImgViewConstraint_H = [NSLayoutConstraint constraintWithItem:clockImgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:11.0f];
	
	[clockImgView addConstraints:@[clockImgViewConstraint_W,clockImgViewConstraint_H]];
	
	 
	/**
	 *  发布时间
	 */
	UILabel *pubTimeLabel = [[UILabel alloc] init];
	pubTimeLabel.textColor = UIColorWithRGB(164, 164, 164);
	pubTimeLabel.text = @"2015/6/11 10:15:54";
	[_backgroundImgView addSubview:pubTimeLabel];
	self.pubTimeLabel = pubTimeLabel;
	
	pubTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	visualFormat = @"H:|-(13)-[clockImgView]-(7)-[pubTimeLabel]-(18)-|";
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"clockImgView": clockImgView,@"pubTimeLabel": pubTimeLabel}];
	[_backgroundImgView addConstraints:constraints];
	
	
	visualFormat = @"V:|-(14)-[titleLabel]-(13)-[pubTimeLabel]-(12)-|";
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:@{@"titleLabel": titleLabel,@"pubTimeLabel": pubTimeLabel}];
	[_backgroundImgView addConstraints:constraints];

}




#pragma mark - Private Methods




@end
