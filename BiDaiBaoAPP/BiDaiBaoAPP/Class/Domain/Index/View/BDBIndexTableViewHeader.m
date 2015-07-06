//
//  BDBIndexTableViewHeader.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/27.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBIndexTableViewHeader.h"

@interface BDBIndexTableViewHeader ()


@property(nonatomic,strong) FLAnimatedImageView *earthGifImageView;


/**
 *	广告动画
 */
@property(nonatomic,weak) UIImageView *advImageView;

/**
 *	初始化广告动画
 */
- (void)initGifImageView;



@end

@implementation BDBIndexTableViewHeader

- (instancetype)init {
	if (self = [super init]) {
		self.translatesAutoresizingMaskIntoConstraints = YES;
		[self initGifImageView];
	}
	return self;
}

#pragma mark - Private Methods
- (void)initGifImageView {
    NSString *earthRotationFilePath = [[NSBundle mainBundle] pathForResource:@"index_top_adv" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:earthRotationFilePath];
    
    FLAnimatedImage *earthGifImage = [FLAnimatedImage animatedImageWithGIFData:data];
    FLAnimatedImageView *earthGifImageView = [[FLAnimatedImageView alloc] init];
    earthGifImageView.animatedImage = earthGifImage;
    
    [self addSubview:earthGifImageView];
    
    self.earthGifImageView = earthGifImageView;
    
	_earthGifImageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	//水平布局
	NSString *visulaFormat = @"H:|[earthGifImageView]|";
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visulaFormat options:0 metrics:nil views:@{@"earthGifImageView": earthGifImageView}];
	[self addConstraints:constraints];
    
	//保持图片的宽高比
	CGSize imageViewSize = earthGifImage.size;
	
	//实际高度
	CGFloat actualHeight = (imageViewSize.height / imageViewSize.width) * SCREEN_WIDTH;
	
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_earthGifImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:round(actualHeight)];
	[_earthGifImageView addConstraint:constraint];

	//紧贴父视图顶部
	constraint = [NSLayoutConstraint constraintWithItem:_earthGifImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_earthGifImageView.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
	[self addConstraint:constraint];
	
	
	//父视图高度
	constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:round(actualHeight)];
	[self addConstraint:constraint];

}

- (void)layoutSubviews {
	[super layoutSubviews];
}





@end
