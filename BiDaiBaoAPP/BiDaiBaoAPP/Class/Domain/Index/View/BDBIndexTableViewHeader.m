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
//	UIImageView *advImageView = [[UIImageView alloc] init];
//	advImageView.image = [UIImage imageNamed:@"index_adv.gif"];
//	[self addSubview:advImageView];
//	self.advImageView = advImageView;
	
    
    NSString *earthRotationFilePath = [[NSBundle mainBundle] pathForResource:@"earth" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:earthRotationFilePath];
    
    FLAnimatedImage *earthGifImage = [FLAnimatedImage animatedImageWithGIFData:data];
    FLAnimatedImageView *earthGifImageView = [[FLAnimatedImageView alloc] init];
    earthGifImageView.animatedImage = earthGifImage;
    
    
    [self addSubview:earthGifImageView];
    
    self.earthGifImageView = earthGifImageView;
    
	_earthGifImageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSString *visulaFormat = @"H:|[earthGifImageView]|";
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visulaFormat options:0 metrics:nil views:@{@"earthGifImageView": earthGifImageView}];
	[self addConstraints:constraints];
    
    CGSize imageViewSize = earthGifImage.size;
    
    CGFloat widthSize = imageViewSize.width;
    
    CGFloat heightSize = imageViewSize.height;
    
    CGFloat proportion = heightSize / widthSize;
    
    CGFloat imageHeight = SCREEN_WIDTH * proportion;
    
    
	visulaFormat = @"V:|[earthGifImageView(height)]-(>=0)-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visulaFormat options:0 metrics:@{@"height":[NSNumber numberWithDouble:imageHeight]} views:@{@"earthGifImageView": earthGifImageView}];
    
	[self addConstraints:constraints];

    
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_earthGifImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_earthGifImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:10.0f];
//    [earthGifImageView addConstraint:constraint];

}

- (void)layoutSubviews {
	[super layoutSubviews];
}




@end
