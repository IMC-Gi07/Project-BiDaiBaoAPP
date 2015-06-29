//
//  ZXLLoadDataIndicatePage.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/19.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "ZXLLoadDataIndicatePage.h"
#import "FLAnimatedImage.h"

@interface ZXLLoadDataIndicatePage()

/**
 *  地球飞机图片
 */
//@property(nonatomic,weak) FLAnimatedImageView *earthPlaneImageView;

/**
 *  加载提示文字
 */
//@property(nonatomic,weak) UILabel *indicateTextLabel;


/**
 *  初始化子视图
 */
- (void)initSubViews;

@end

@implementation ZXLLoadDataIndicatePage

+ (instancetype)showInView:(UIView *)view {
	ZXLLoadDataIndicatePage *indicatePage = [[self alloc] init];
	[view addSubview:indicatePage];
	
	[indicatePage initSubViews];
	
	return indicatePage;
}

#pragma mark - Public Methods
- (void)hide {
	[UIView animateWithDuration:0.5f delay:0.0f options:0 animations:^{
		self.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

#pragma mark - Private
- (void)initSubViews {
	if(!self.superview) return;
	
	self.backgroundColor = [UIColor whiteColor];
	
	//地球图片
	NSData *earthPlaneImageData = [NSData dataWithContentsOfFile:FilePathInBundleWithNameAndType(@"global_loaddata_icon", @"gif")];
	FLAnimatedImage *earthPlaneImage = [FLAnimatedImage animatedImageWithGIFData:earthPlaneImageData];
	FLAnimatedImageView *earthPlaneImageView = [[FLAnimatedImageView alloc] init];
	earthPlaneImageView.animatedImage = earthPlaneImage;
	[self addSubview:earthPlaneImageView];
	
	//提示加载文字
	UILabel *indicateTextLabel = [[UILabel alloc] init];
	indicateTextLabel.text = @"网速不给力哦，努力加载中...";
	indicateTextLabel.textColor = UIColorWithRGB(164, 164, 164);
	indicateTextLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:indicateTextLabel];

	self.translatesAutoresizingMaskIntoConstraints = NO;
	earthPlaneImageView.translatesAutoresizingMaskIntoConstraints = NO;
	indicateTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	for (NSString *visualFormat in @[@"H:|[thisView]|",@"V:|[thisView]|"]) {
		NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:@{@"thisView": self}];
		[self.superview addConstraints:constraints];
	}
	
	NSString *visualFormat = @"V:|-(150)-[earthPlaneImageView(183)]-(55)-[indicateTextLabel]-(>=0)-|";
	NSDictionary *viewsDict = NSDictionaryOfVariableBindings(earthPlaneImageView,indicateTextLabel); 
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDict];
	[self addConstraints:constraints];
	
	visualFormat = @"H:|-(>=0)-[earthPlaneImageView(183)]-(>=0)-|";
	viewsDict = NSDictionaryOfVariableBindings(earthPlaneImageView);
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:viewsDict];
	[self addConstraints:constraints];
	
	visualFormat = @"H:|[indicateTextLabel]|";
	viewsDict = NSDictionaryOfVariableBindings(indicateTextLabel);
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:viewsDict];
	[self addConstraints:constraints];
	
}


@end
