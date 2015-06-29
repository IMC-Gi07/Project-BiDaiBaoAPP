//
//  BDBTableViewRefreshHeader.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/26.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBTableViewRefreshHeader.h"

@interface BDBTableViewRefreshHeader()

/**
 *  动画图标
 */
@property(nonatomic,weak)  FLAnimatedImageView *earthRocketIconImgView;

/**
 *  提示信息
 */
@property(nonatomic,weak) UILabel *indicateLabel;

/**
 *  实例化动画图标
 */
- (void)initEarthRocketIconImgView;

/**
 *  实例化提示信息
 */
- (void)initIndicateLabel;

@end

@implementation BDBTableViewRefreshHeader

- (void)prepare {
	[super prepare];
	
	[self initEarthRocketIconImgView];
	
	[self initIndicateLabel];
}

- (void)placeSubviews {
	[super placeSubviews];
	
	//center + bounds
	_earthRocketIconImgView.bounds = CGRectMake(0, 0, 40, 40);
	_earthRocketIconImgView.center = CGPointMake(self.mj_w*0.5-25, self.mj_h*0.5);
	
	_indicateLabel.bounds = CGRectMake(0, 0, 60, 30);
	_indicateLabel.center = CGPointMake(self.mj_w*0.5+25, self.mj_h*0.5);
}

#pragma mark - Private Methods
- (void)initEarthRocketIconImgView {
	NSString *earthRocketIconImgFilePath = FilePathInBundleWithNameAndType(@"global_refreshdata_icon",@"gif");
	NSData *earthRocketIconImgData = [NSData dataWithContentsOfFile:earthRocketIconImgFilePath];
	
	FLAnimatedImage *earthRocketIconImg = [FLAnimatedImage animatedImageWithGIFData:earthRocketIconImgData];
	
	FLAnimatedImageView *earthRocketIconImgView = [[FLAnimatedImageView alloc] init];
	
	earthRocketIconImgView.animatedImage = earthRocketIconImg;
	
	[self addSubview:earthRocketIconImgView];
	self.earthRocketIconImgView = earthRocketIconImgView;
	
}

- (void)initIndicateLabel {
	UILabel *indicateLabel = [[UILabel alloc] init];
	indicateLabel.text = @"松手更新...";
	indicateLabel.font = UIFontWithSize(12.0f);
	indicateLabel.textColor = UIColorWithRGB(179, 179, 179);
	
	[self addSubview:indicateLabel];
	
	self.indicateLabel = indicateLabel;
}

@end
