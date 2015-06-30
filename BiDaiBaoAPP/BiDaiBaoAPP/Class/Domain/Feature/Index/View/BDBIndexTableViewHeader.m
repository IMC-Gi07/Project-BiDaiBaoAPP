//
//  BDBIndexTableViewHeader.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/27.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBIndexTableViewHeader.h"

@interface BDBIndexTableViewHeader ()

/**
 *	广告动画
 */
@property(nonatomic,weak) UIImageView *advImageView;

/**
 *	初始化广告动画
 */
- (void)initAdvImageView;



@end

@implementation BDBIndexTableViewHeader

- (instancetype)init {
	if (self = [super init]) {
		self.translatesAutoresizingMaskIntoConstraints = YES;
		[self initAdvImageView];
	}
	return self;
}

#pragma mark - Private Methods
- (void)initAdvImageView {
	UIImageView *advImageView = [[UIImageView alloc] init];
	advImageView.image = [UIImage imageNamed:@"index_adv.gif"];
	[self addSubview:advImageView];
	self.advImageView = advImageView;
	
	_advImageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSString *visulaFormat = @"H:|[advImageView]|";
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visulaFormat options:0 metrics:nil views:@{@"advImageView": _advImageView}];
	[self addConstraints:constraints];
	
	visulaFormat = @"V:|[advImageView(200)]|";
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:visulaFormat options:0 metrics:nil views:@{@"advImageView": _advImageView}];
	[self addConstraints:constraints];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}




@end
